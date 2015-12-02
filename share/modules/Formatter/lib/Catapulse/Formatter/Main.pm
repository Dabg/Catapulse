package Catapulse::Formatter::Main;

use parent 'Catapulse::Formatter';

=head1 NAME

Catapulse::Formatter::Main - Catapulse's main formatter, dispatching between
Textile and MultiMarkdown

=head1 DESCRIPTION

This is the main Catapulse formatter, which transforms lightweight plain text
markup into XHTML. It reads the site preference main_formatter and calls the
corresponding formatter, either L<Text::Textile>, or L<Text::MultiMarkdown>.

=head1 METHODS

=head2 format_content_order

Format order can be 1-99. The main formatter runs on 15.

=cut

sub format_content_order { 15 }

=head2 format_content

Calls the formatter. Takes a ref to the content as well as the context object.
The latter is needed in order to determine the main formatter via a call to
C<< $c->pref('main_formatter') >>.

=cut

sub format_content {
    my ( $class, $content, $c ) = @_;

    # dispatch to the preferred formatter
    if ($c->pref('main_formatter') eq 'Catapulse::Formatter::Textile') {
        require Catapulse::Formatter::Textile;
        $$content = Catapulse::Formatter::Textile->main_format_content($content);
    } else {
        require Catapulse::Formatter::Markdown;
        $$content = Catapulse::Formatter::Markdown->main_format_content($content);
    }
}

=head1 SEE ALSO

L<Catapulse>, L<Module::Pluggable::Ordered>, L<Text::Textile>

=head1 AUTHORS

Marcus Ramberg <mramberg@cpan.org>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
