use utf8;
package Catapulse::Schema::Result::Comment;

=head1 NAME

Catapulse::Schema::Result::Comment

=cut

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';


use Text::Textile;
my $textile = Text::Textile->new(
    disable_html  => 1,
    flavor        => 'xhtml2',
    charset       => 'utf-8',
    char_encoding => 0,
);

__PACKAGE__->load_components(
    qw/DateTime::Epoch TimeStamp Core/);
__PACKAGE__->table("comment");
__PACKAGE__->add_columns(
    "id",
    {
        data_type         => "INTEGER",
        is_nullable       => 0,
        size              => undef,
        is_auto_increment => 1
    },
    "poster",
    { data_type => "INTEGER", is_nullable => 0, size => undef },
    "page",
    { data_type => "INTEGER", is_nullable => 0, size => undef },
    "posted",
    {
        data_type        => "BIGINT",
        is_nullable      => 0,
        size             => undef,
        inflate_datetime => 'epoch',
        set_on_create    => 1,
    },
    "body",
    { data_type => "TEXT", is_nullable => 0, size => undef },
);

__PACKAGE__->set_primary_key("id");
__PACKAGE__->belongs_to(
    "poster",
    "Catapulse::Schema::Result::User",
    { id => "poster" }
);

__PACKAGE__->belongs_to(
    "page",
    "Catapulse::Schema::Result::Page",
    { id => "page" }
);

__PACKAGE__->has_many(
  "obj_operations",
  "Catapulse::Schema::Result::ObjOperation",
  { "foreign.obj_id"     => "self.id" },
  {  where => { typeobj_id => 3 }},
  { cascade_copy => 0, cascade_delete => 0 },
);

__PACKAGE__->many_to_many( ops_to_access => 'obj_operations', 'operation',);


=head1 NAME

Catapulse::Schema::Result::Comment - store comments

=head1 METHODS

=head2 formatted

Returns a Textile formatted version of the given comment.

TODO: the default formatter may not be Textile.

=cut

sub formatted {
    my $self = shift;
    return $textile->process( $self->body );
}

=head1 AUTHOR

Marcus Ramberg <mramberg@cpan.org>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
