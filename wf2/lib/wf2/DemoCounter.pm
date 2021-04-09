package wf2::DemoCounter;

use Mojo::Base 'Mojolicious::Plugin', -signatures, -async_await;
use Mojo::JSON 'true';
use Mojo::Promise;
use Mojo::IOLoop;

use constant CHANNEL => 'counter';
use constant PASSWORD => '...';

sub register ( $self, $app, $config )
{
    $app->bs->create_channel( CHANNEL, 1 );

    $app->bs->on_join( CHANNEL, sub ( $channel_name, $c, $attrs )
    {
        say "Some one is join";
        my $is_reconnect = $attrs->{is_reconnect};
        return { limit => $is_reconnect ? 4 : 0 };
    } );

    $app->bs->on_action( CHANNEL, 'inc_counter', sub ( $channel_name, $c, $payload )
    {
        $c->bs->lock_state( CHANNEL, sub ( $state )
        {
            $state    += $payload;
            my $event = "Someone increased the counter by $payload";

            return $event, $state;
        } );
    } );

    $app->bs->on_request( CHANNEL, 'set_counter', sub ( $channel_name, $c, $payload )
    {
        my $p = Mojo::Promise->new;

        Mojo::IOLoop->timer( 3, sub {
            if ( 1 <= $payload <= 100 )
            {
                $c->bs->lock_state( CHANNEL, sub ( $state )
                {
                    $state    = $payload;
                    my $event = "Someone set the counter to $payload";

                    return $event, $state;
                } );
                $p->resolve( true );
            }
            else
            {
                $p->reject( 'out of bounds' ); # could be a JSON object too
            }
        } );

        return $p;
    } );

    $app->bs->on_action( CHANNEL, 'inc_by_1', sub ( $channel_name, $c, $payload )
    {
        sleep 1;
        say "Some one is inc_by_1 : " . $payload->{xx};


        $c->bs->lock_state( CHANNEL, sub ( $state )
        {
            $state += 1;
            $state = 1 if $state > 100;

            return $state, $state;
        } );
    } );
}

1;