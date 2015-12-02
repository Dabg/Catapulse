package Catapulse::Formatter;

use Moose;
use Module::Pluggable::Ordered
    search_path => 'Catapulse::Formatter',
    except      => qr/^Catapulse::Plugin::/,
    require     => 1;

=head1 NAME

Catapulse::Formatter - Base class for all formatters

=head1 SYNOPSIS

    package Catapulse::Formatter::Simple;

    use parent qw/Catapulse::Formatter/;

    sub format_content_order { 14 }
    # so that it runs after inclusion of obscene web sites
    # (Catapulse::Formatter::Include runs at 6)

    sub format_content {
        my ($class, $content, $c) = @_;
        $$content =~ s/fuck/f**k/g;
        return $content;
    }


=head1 DESCRIPTION

This is the class to inherit from if you want to write your own formatter.


=head1 WRITING YOUR OWN FORMATTER

See the synopsis for a really simple formatter example. Catapulse uses
L<Module::Pluggable::Ordered> to process all the formatter plugins. Just
specify when you want to trigger your formatter by providing a format_content_order
method which returns a number to specify when you want to run. The plugin order
for the default plugins is currently as follows:

=over 4

=item 1  - L<Catapulse::Formatter::Redirect> - handles {{redirect /path}}

=item 5  - L<Catapulse::Formatter::Include> - handles {{include <url>}} before
all other plugins, so that transcluded sections from the same wiki get parsed
for markup

=item 10 - L<Catapulse::Formatter::CPANHyperlink> - handles {{cpan My::Module}}

=item 10 - L<Catapulse::Formatter::YouTube> - handles {{youtube <url>}}

=item 10 - L<Catapulse::Formatter::Wiki> - handles [[wikilinks]]

=item 10 - L<Catapulse::Formatter::Pod> - handles {{pod}} ... {{end}} blocks

=item 14 - L<Catapulse::Formater::IRCLog> - handles {{irc}} ... {{end}} blocks

=item 14 - L<Catapulse::Formatter::SyntaxHighlight> - Performs syntax highlighting
on code blocks

=item 15 - Main formatter (L<Catapulse::Formatter::Markdown> or
L<Catapulse::Formatter::Textile>)

=item 16 - L<Catapulse::Formatter::Defang> - removes harmful HTML and XSS

=item 91 - L<Catapulse::Formatter::Comment> - handles {{comments}}, inserts a comment box

=item 95 - L<Catapulse::Formatter::TOC> - replaces {{toc}} with a table of contents

=back

Note that if your formatter expects HTML text, it should run after the
main formatter.


=head1 METHODS

=head2 format_content

If you want your formatter to do something, you also need to override
C<format_content>. It gets passed its classname, a scalar ref to the content,
and the context object. It should return the scalar ref.

=head2 main_format_content

Override this method if your formatter is a primary one (equivalent to Markdown or
Textile). It gets passed the same arguments as L</format_content>. Also make sure
to update "Site settings" (/.admin).

Note that the main formatter runs at 15.

=head2 module_loaded

Return true if a formatter module is loaded.

=cut

sub module_loaded { 1; }

=head2 gen_re

    gen_re(qr/irc/)

Returns a regular expression for the given tag between matching double braces.

=cut

sub gen_re {
    my ($self, $tag, $args)=@_;
    $args ||= '';
    return qr[\{\{\s*$tag\s*$args\s*}}];
}



=head1 SEE ALSO

L<Catapulse>, L<Catapulse::Formatter::Textile>, L<Catapulse::Formatter::Markdown>

=head1 AUTHORS

Marcus Ramberg <mramberg@cpan.org>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
