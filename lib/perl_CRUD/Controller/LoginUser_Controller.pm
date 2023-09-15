package perl_CRUD::Controller::LoginUser_Controller;
use Mojo::Base 'Mojolicious::Controller', -signatures;
use DBI;
use strict;
use Mojo::Pg;
use Mojo::Pg::Database;
use Mojolicious::Plugin::Bcrypt;
use Digest::MD5 qw(md5_hex);

my $Pg = Mojo::Pg->new('postgresql://postgres:trannguyendan@localhost/pagila');
my $dbh = DBI->connect("dbi:Pg:dbname=pagila;host=localhost", "postgres", "trannguyendan");
sub login ($self) {
    if($self->session('username') eq ""){
        $self->render(
        template => 'layouts/login'
        );
    }else{
        return $self->redirect_to('/');
    }
}

sub action_login ($self) {
    if($self->session->{username} eq ""){
        my $username = $self->param('username');
        my $password = $self->param('password');
        my $stored_hashed_password = $dbh->selectrow_array("SELECT password FROM login WHERE user_name = ?", undef, $username);
        # my $result = $Pg->db->select('login',{'*'},{user_name => $username, password => $password},{limit => 1})->hash;
        
        if($self->bcrypt_validate($password, $stored_hashed_password)){
            $self->session->{username} = $username;
            return $self->redirect_to('/');
        }else{
            $self->stash(error => 'username or password wrong!');
            $self->render(
            template => 'layouts/login'
            );
        }
        # print $self->bcrypt_validate($password, $stored_hashed_password);
    }else{
        return $self->redirect_to('/');
    }
}

sub action_logout ($self) {
        $self->session(expires => 1);
        return $self->redirect_to('/login');
}

sub register ($self){
    if($self->session->{username} eq ""){
        $self->render(
        template => 'layouts/register'
        );
    }else{
        return $self->redirect_to('/');
    }
}

sub action_register ($self){
    if($self->session->{username} eq ""){
        my $username = $self->param('username');
        my $password = $self->param('password');
        my $hashed_password =  $self->bcrypt($password);
        my $register = $Pg->db->insert('login', {user_name => $username,password => $hashed_password});
        if($register){
            $self->session->{username} = $username;
            return $self->redirect_to('/');
        }
    }else{
        return $self->redirect_to('/');
    }
}
1;