package wf2;
use Mojo::Base 'Mojolicious', -signatures;

# This method will run once at server start
sub startup ($self) {

  # Load configuration from config file
  my $config = $self->plugin('NotYAMLConfig');

	$self->plugin( BoardStreams => {db_string => 'postgresql://sergeyandreev:ps-password-1-2@127.0.0.1/bs'} );
	$self->plugin("wf2::DemoCounter");
  # Configure the application
  $self->secrets($config->{secrets});

  # Router
  my $r = $self->routes;

  # Normal route to controller
	$r->websocket('/ws')->to('example#ws');  
	$r->get('/')->to('example#welcome');
}

1;
