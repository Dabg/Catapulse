use utf8;
package Catapulse::Web::Controller::Comment;

use Moose;
use namespace::autoclean;
use YAML;
use XML::Simple;
use JSON;
use JSON::XS;

#BEGIN {extends 'Catalyst::Controller::REST'; }
BEGIN {extends 'Catalyst::Controller'; }


__PACKAGE__->config(
    'namespace' => '',

#    'default' => 'text/html',
    'map'     => {
        'text/x-yaml'      => 'YAML',
        'application/json' => 'JSON',
    },
);

=head1 NAME

Catapulse::Controller::API::Comment - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=cut

=head1 METHODS

=cut

=head2 index

Add a comment

=cut

sub comment  :Path('comment') :ActionClass('REST'){}

=head2 comment_GET

return comments page

=cut

sub comment_GET  :ActionClass('Serialize') {
    my ( $self, $c ) = @_;

    my $page_id = $c->request->params->{page_id};

    my $rs = $c->model("DBIC::Comment")->search({ page_id => $page_id});
    my $result = [];

    while ( my $r = $rs->next) {
        push(@$result, $r->TO_JSON)
    }

    $c->stash->{json_data} = $result;
    $c->forward('View::JSON');
}

=head2 comment_POST

post a comment on page

=cut

sub comment_POST   :ActionClass('Serialize'){
    my ( $self, $c ) = @_;


    my $page = $c->stash->{page};

    my $params = $c->request->body_parameters;

    my $id = delete $params->{id};
    my $parent_id = delete $params->{parent_id} || 0;

    my $user_has_upvoted	    = delete $params->{user_has_upvoted};
    my $upvote_count		    = delete $params->{upvote_count};
    my $profile_picture_url	    = delete $params->{profile_picture_url};
    my $created_by_current_user = delete $params->{created_by_current_user};
    my $fullname		        = delete $params->{fullname};
    $params->{created}		= DateTime->now;
    $params->{poster}		= $c->user->id || 2;

    my $comment = $c->model("DBIC::Comment")->create($params)->TO_JSON;

    $c->stash->{json_data} = $comment;
    $c->forward('View::JSON');
}


=head2 comment_PUT

update a comment

=cut

sub comment_PUT   :ActionClass('Serialize'){
    my ( $self, $c ) = @_;


    my $page = $c->stash->{page};

    my $params = $c->request->body_parameters;

    my $id = delete $params->{id};
    my $parent_id = delete $params->{parent_id} || 0;

    my $user_has_upvoted	    = delete $params->{user_has_upvoted};
    my $upvote_count		    = delete $params->{upvote_count};
    my $profile_picture_url	    = delete $params->{profile_picture_url};
    my $created_by_current_user = delete $params->{created_by_current_user};
    my $fullname		        = delete $params->{fullname};
    $params->{created}		    = DateTime->now;
    $params->{poster}		    = $c->user->id;

    my $comment = $c->model("DBIC::Comment")->update($params);

    my $rs = $c->model("DBIC::Comment")->search({ page_id => $page->id});
    my $result = [];

    while ( my $r = $rs->next) {
        push(@$result, $r->TO_JSON)
    }

    $c->stash->{json_data} = {1};#$result;

    $c->forward('View::JSON');
}



=head2 comment_DELETE

Remove comment

=cut

sub comment_DELETE   :ActionClass('Serialize'){
    my ( $self, $c, $comment_id ) = @_;

     if ( my $comment = $c->model("DBIC::Comment")->find($comment_id) ) {
             $comment->delete();
     }
    $c->forward('comment_GET');
}


=head1 AUTHOR

Daniel Brosseau <dab@catapulse.org>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
