package perl_CRUD;
use Mojo::Base 'Mojolicious', -signatures;

# This method will run once at server start

sub startup ($self) {

  # Load configuration from config file
  my $config = $self->plugin('NotYAMLConfig');

  # Configure the application
  $self->secrets($config->{secrets});

  $self->plugin('bcrypt', { cost => 4 });
  
  $self->hook(before_dispatch => sub {
  my $c = shift;

  # Add CORS headers
  $c->res->headers->header('Access-Control-Allow-Origin' => '*');
  $c->res->headers->header('Access-Control-Allow-Methods' => 'GET, POST, PUT, DELETE, OPTIONS');
  $c->res->headers->header('Access-Control-Allow-Headers' => 'Origin, X-Requested-With, Content-Type, Accept');

  # Handle preflight OPTIONS request
  if ($c->req->method eq 'OPTIONS') {
    $c->res->headers->header('Access-Control-Max-Age' => '1728000');
    $c->render(text => '', status => 204);
    return;
  }
  });
  # Router
  my $r = $self->routes;

  #login
  $r->get('/login')->to('LoginUser_Controller#login');
  $r->post('/action-login')->to('LoginUser_Controller#action_login');
  $r->get('/logout')->to('LoginUser_Controller#action_logout');

  #register
  $r->get('/register')->to('LoginUser_Controller#register');
  $r->post('/action-register')->to('LoginUser_Controller#action_register');

  # Normal route to controller
  $r->get('/')->to('CRUD_Controller#index');
  # form add-new
  $r->get('/layout-add-new')->to('CRUD_Controller#layout_Add_New');
  # form action-add-new
  $r->post('/action-add-new')->to('CRUD_Controller#action_Add_New');
  # form edit
  $r->get('/layout-edit/:id')->to('CRUD_Controller#layout_Edit');
  # form action edit
  $r->post('/action-edit/:id')->to('CRUD_Controller#action_Edit');
  # form action delete
  $r->get('/action-delete/:id')->to('CRUD_Controller#action_Delete');

  # GET /api/
  $r->get('/api/')->to('API_Controller#index');
  # GET /api/
  $r->get('/api/:id')->to('API_Controller#show');
  # PUT /api/
  $r->put('/api/update/:id')->to('API_Controller#update');
  # DELETE /api/
  $r->delete('/api/delete/:id')->to('API_Controller#delete');
  # # Route for the paginated pages
  # $r->get('/page/:page')->to('CRUD_Controller#index');
}



1;
