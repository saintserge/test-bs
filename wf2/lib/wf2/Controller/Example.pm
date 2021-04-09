package wf2::Controller::Example;
use Mojo::Base 'Mojolicious::Controller', -signatures;

# This action will render a template
sub welcome ($self) {

  # Render template "example/welcome.html.ep" with message
  $self->render(msg => 'Welcome to the Mojolicious real-time web framework!');
}
sub ws ( $self )
{
	$self->bs->initialize_client;
}
1;
