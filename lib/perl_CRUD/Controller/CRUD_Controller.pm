package perl_CRUD::Controller::CRUD_Controller;
use Mojo::Base 'Mojolicious::Controller', -signatures;
use DBI;
use strict;
use Mojo::Pg;
use Mojo::Pg::Database;
# Connect database
# my $password  = "trannguyendan@123";
my $Pg = Mojo::Pg->new('postgresql://postgres:trannguyendan@localhost/pagila');
print "Opened database successfully\n";
# my $dsn       = "DBI:Pg:dbname = pagila;
#                   host = localhost;
#                   port = 5432";
# my $userid    = "postgres";

# my $dbh       = DBI->connect($dsn, $userid, $password, { RaiseError => 1 })
#   or die $DBI::errstr;
# print "Opened database successfully\n";
# sub index($self){
#   my $stmt = qq(SELECT * FROM actor ORDER BY actor_id DESC LIMIT 20 );
#   my $sth = $dbh->prepare( $stmt );
#   my $rv = $sth->execute() or die $DBI::errstr;
#   my @rows;
#   while (my $row = $sth->fetchrow_hashref) {
#     push @rows, $row;
#   }
#   $self->render(
#     rows => \@rows,
#     template => 'CRUD/index'
#   );
# }
sub layout_Add_New($self){
    if(!$self->session->{username} == ""){
        $self->render(
        template => 'CRUD/layout-add-new'
        );
    }else{
        return $self->redirect_to('/login');
    }
}
# sub action_Add_New($self){
#   my $first_name = $self->param('first_name');
#   my $last_name = $self->param('last_name');
#   my $stmt = qq(INSERT INTO actor (first_name,last_name,last_update) VALUES ('$first_name','$last_name',NOW()));
#   my $sth = $dbh->prepare( $stmt );
#   my $rv = $sth->execute() or die $DBI::errstr;
#   $self->redirect_to('/');
# }
# sub layout_Edit($self){
#   my $id = $self->stash('id');
#   my $stmt = qq(SELECT * from actor WHERE actor_id = $id limit 1);
#   my $sth = $dbh->prepare( $stmt );
#   my $rv = $sth->execute() or die $DBI::errstr;
#   my @rows;
#   while (my $row = $sth->fetchrow_hashref) {
#     push @rows, $row;
#   }
#   $self->render(
#     rows => \@rows,
#     template => 'CRUD/layout-edit'
#   );
# }
# sub action_Edit ($self){
#   my $id = $self->stash('id');
#   my $first_name = $self->param('first_name');
#   my $last_name = $self->param('last_name');
#   my $stmt = qq(UPDATE actor SET first_name='$first_name',last_name='$last_name' WHERE actor_id = $id);
#   my $sth = $dbh->prepare( $stmt );
#   my $rv = $sth->execute() or die $DBI::errstr;
#   $self->redirect_to('/');
# }
# sub action_Delete ($self){
#   my $id = $self->stash('id');
#   my $stmt = qq(DELETE FROM actor WHERE actor_id = $id);
#   my $sth = $dbh->prepare( $stmt );
#   my $rv = $sth->execute() or die $DBI::errstr;
#   $self->redirect_to('/');
# }
sub index($self){
    if(!$self->session->{username} == ""){
        my @rows;
        my $results = $Pg->db->select('actor',{'*'});
        while (my $next = $results->hash) {
            push @rows, $next;
        }
        $self->render(
        rows => \@rows,
        template => 'CRUD/index'
        );
    }else{
        return $self->redirect_to('/login');
    }
}
sub action_Add_New($self){
    if(!$self->session->{username} == ""){
        my $first_name = $self->param('first_name');
        my $last_name = $self->param('last_name');
        my $validation = $self->validation;
        
        # Set validation rules for each input field
        $validation->input({ first_name => $first_name, last_name => $last_name });
        $validation->required('first_name')->like(qr/^([\p{L} ]){2,50}$/);
        $validation->required('last_name')->like(qr/^([\p{L} ]){2,50}$/);;
        if ($validation->has_error) {
            $self->stash(error => 'You have entered the wrong character. Please re-enter.');
            $self->render(
            template => 'CRUD/layout-add-new'
            );
            } else {
            $Pg->db->insert('actor', {first_name => $first_name,last_name => $last_name,last_update => 'NOW()'});
            $self->redirect_to('/');
        }
    }else{
        return $self->redirect_to('/login');
    }
}
sub layout_Edit($self){
    if(!$self->session->{username} == ""){
        my $id = $self->stash('id');
        my @rows;
        my $results = $Pg->db->select('actor',{'*'},{actor_id => $id},{limit => 1});
        while (my $next = $results->hash) {
            push @rows, $next;
        }
        $self->render(
        rows => \@rows,
        template => 'CRUD/layout-edit'
        );
    }else{
        return $self->redirect_to('/login');
    }
}
sub action_Edit ($self){
    if(!$self->session->{username} == ""){
        my $id = $self->stash('id');
        my @rows;
        my $results = $Pg->db->select('actor',{'*'},{actor_id => $id},{limit => 1});
        while (my $next = $results->hash) {
            push @rows, $next;
        }
        my $first_name = $self->param('first_name');
        my $last_name = $self->param('last_name');
        my $validation = $self->validation;
        
        # Set validation rules for each input field
        $validation->input({ first_name => $first_name, last_name => $last_name });
        $validation->required('first_name')->like(qr/^([\p{L} ]){2,50}$/);
        $validation->required('last_name')->like(qr/^([\p{L} ]){2,50}$/);;
        if ($validation->has_error) {
            $self->stash(error => 'You have entered the wrong character. Please re-enter.');
            $self->render(
            rows => \@rows,
            template => 'CRUD/layout-edit'
            );
            } else {
            $Pg->db->update('actor', {first_name => $first_name, last_name => $last_name}, {actor_id => $id});
            $self->redirect_to('/');
        }
    }else{
        return $self->redirect_to('/login');
    }
}
sub action_Delete ($self){
    if(!$self->session->{username} == ""){
        my $id = $self->stash('id');
        $Pg->db->delete('actor', {actor_id => $id});
        $self->redirect_to('/');
    }else{
        return $self->redirect_to('/login');
    }
}