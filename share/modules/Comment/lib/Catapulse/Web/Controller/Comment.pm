use utf8;
package Catapulse::Web::Controller::Comment;

use Moose;
use namespace::autoclean;
use YAML;
use XML::Simple;
use JSON;
use JSON::XS;

BEGIN {extends 'Catalyst::Controller'; }


__PACKAGE__->config(
    'namespace' => '',

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

=head2 comment

Add a comment

=cut

sub comment  :Path('comment') :ActionClass('REST'){}

=head2 comment_GET

return comments page

=cut

sub comment_GET  :ActionClass('Serialize') {
    my ( $self, $c ) = @_;


    my $page = $self->get_page($c);
    return unless $page;

    return if ! $c->can_access([$page], ['view_Comment']);

    my $comments = $page->comments;
    my $results = [];
    while ( my $comment = $comments->next) {
        push(@$results, $comment->TO_JSON)
    }

    $c->stash->{json_data} = $results;
    $c->forward('View::JSON');
}

=head2 comment_POST

post a comment on page

=cut

sub comment_POST   :ActionClass('Serialize'){
    my ( $self, $c ) = @_;


    my $page = $self->get_page($c);
    return unless $page;

    return if ! $c->can_access([$page], ['add_Comment']);

    my $params = $c->request->body_parameters;

    my $id = delete $params->{id};
    my $parent_id = delete $params->{parent_id} || 0;

    my $user_has_upvoted	    = delete $params->{user_has_upvoted};
    my $upvote_count		    = delete $params->{upvote_count};
    my $profile_picture_url	    = delete $params->{profile_picture_url};
    my $created_by_current_user = delete $params->{created_by_current_user};
    my $fullname		        = delete $params->{fullname};
    $params->{created}		= DateTime->now;
    $params->{poster}		= defined $c->user ? $c->user->id : 2;

    my $comment = $c->model("DBIC::Comment")->create($params)->TO_JSON;

    $c->stash->{json_data} = $comment;
    $c->forward('View::JSON');
}


=head2 comment_PUT

update a comment

=cut

sub comment_PUT   :ActionClass('Serialize'){
    my ( $self, $c ) = @_;

    my $page = $self->get_page($c);
    return unless $page;

    return if ! $c->can_access([$page], ['add_Comment']);


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

    my $comment = $c->model("DBIC::Comment")->find($id)->update($params);

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

    my $page = $self->get_page($c);
    return unless $page;

    return if ! $c->can_access([$page], ['delete_Comment']);

    if ( my $comment = $c->model("DBIC::Comment")->find($comment_id) ) {
             $comment->delete();
     }
    $c->forward('comment_GET');
}


=head2 get_page

Add a resultset page

=cut

sub get_page{
    my ( $self, $c ) = @_;

    my $page_id = $c->request->params->{page_id};
    return unless $page_id;
    return $c->model("DBIC::Page")->search({ id => $page_id})->first;
}

=head2 comment_GET

return comments page

=cut


=head1 AUTHOR

Daniel Brosseau <dab@catapulse.org>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
