package perl_CRUD::Controller::API_Controller;
use Mojo::Base 'Mojolicious::Controller', -signatures;
use DBI;
use strict;
use Mojo::Pg;
use Mojo::Pg::Database;
my $Pg = Mojo::Pg->new('postgresql://postgres:trannguyendan@localhost/pagila');

sub index($self){
    my @rows;
    my $results = $Pg->db->select('actor',{'*'},undef,{order_by => {-desc => 'actor_id'}});
    while (my $next = $results->hash) {
        push @rows, $next;
    }
    $self->render(
    json => \@rows,status => 200, headers => {'Access-Control-Allow-Origin' => '*'}
    );
}
sub show($self) {
    my $actor_id = $self->param('id');
    my @rows;
    my $results = $Pg->db->select('actor',{'*'},{actor_id => $actor_id},{order_by => {-desc => 'actor_id'}});
    while (my $next = $results->hash) {
        push @rows, $next;
    }
    $self->render(
    json => \@rows
    );
}

sub update($self) {
    my $id = $self->param('id');
    my $first_name = $self->param('first_name');
    my $last_name = $self->param('last_name');
    # my $first_name = $self->req->json->first_name;
    # my $last_name = $self->req->json->last_name;
    # my $actor = $self->req->json;
    
    # Update user in database
     $Pg->db->update('actor', {first_name => $first_name, last_name => $last_name}, {actor_id => $id});
    # $actor->{actor_id} = $id; # Make sure ID is set correctly
    # $actor->{first_name} = $first_name;
    # $actor->{last_name} = $last_name;
    $self->render(json => {success => 1});
}

sub delete($self) {
    my $id = $self->param('id');
    # Delete user from database
    $Pg->db->delete('actor', {actor_id => $id});
    $self->render(text => "Actor $id deleted");
}

