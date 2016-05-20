use utf8;
package Catapulse::Web::Controller::Attachment;

use Moose;
use namespace::autoclean;
use YAML;
use XML::Simple;
use JSON;
use JSON::XS;
use Data::Dumper;
use MIME::Types;
use File::MimeInfo;
use jQuery::File::Upload;
use File::Path qw(make_path);
use FindBin qw($Bin);

my $app_root_dir = "$Bin/../root";
my $upload_url= "/static/uploads";
my $upload_dir_base = $app_root_dir . $upload_url;


$Data::Dumper::Indent = 1;
$Data::Dumper::Sortkeys = 1;

BEGIN { extends 'Catalyst::Controller' }


__PACKAGE__->config(
    'namespace' => '',

    'map'     => {
        'application/json' => 'JSON',
    },
);

=head1 NAME

Catapulse::Web::Controller::Attachment - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller to Up/Download files

=head1 METHODS

=cut

sub list :Path('attachment/list') : ActionClass('REST') { }


sub list_GET :ActionClass('Serialize') {
    my ( $self, $c ) = @_;

    my $path = $c->req->params->{path};
    my $upload_dir = $upload_dir_base . $path;

    opendir(my $dh, $upload_dir) || die "can't opendir $upload_dir: $!";
    my @Files = grep { $_ !~ /^thumb_/ && -f "$upload_dir/$_" } readdir($dh);
    closedir $dh;

    my $files = [];
    foreach my $f ( @Files ) {
        my $uri = $c->uri_for;
        my $F = {
            url           => $uri . $upload_url . $path . "/$f",
            name          => $f,
            deleteUrl     => "not_empty",
            deleteType    => "DELETE",
        };

        $F ->{thumbnailUrl} = $uri . $upload_url . $path . "/thumb_$f" if ( $f =~ /png$|gif$|jpg$/ );
        push(@$files, $F);
    }

    $c->stash->{'rest'} = {
			   files => $files
			  };
    $c->response->status(200);

}

sub attachment :Path('attachment') :ActionClass('REST'){
    my ( $self, $c ) = @_;

    $c->assets->include("/static/css/blueimp-gallery.min.css");
    $c->assets->include("/static/css/jquery.fileupload.css");
    $c->assets->include("/static/css/jquery.fileupload-ui.css");

    $c->assets->include("/static/js/vendor/jquery.ui.widget.js");
    $c->assets->include("/static/js/tmpl.min.js");
    $c->assets->include("/static/js/load-image.all.min.js");


    $c->assets->include("/static/js/canvas-to-blob.min.js");
    $c->assets->include("/static/js/jquery.blueimp-gallery.min.js");
    $c->assets->include("/static/js/jquery.iframe-transport.js");
    $c->assets->include("/static/js/jquery.fileupload.js");
    $c->assets->include("/static/js/jquery.fileupload-process.js");
    $c->assets->include("/static/js/jquery.fileupload-image.js");
    $c->assets->include("/static/js/jquery.fileupload-audio.js");
    $c->assets->include("/static/js/jquery.fileupload-video.js");
    $c->assets->include("/static/js/jquery.fileupload-validate.js");
    $c->assets->include("/static/js/jquery.fileupload-ui.js");
}

sub attachment_GET {
    my ( $self, $c ) = @_;

    $c->stash->{template} = 'attachment.tt';
}

sub attachment_POST {
    my ( $self, $c ) = @_;

	my $output;
    my $j_fu = jQuery::File::Upload->new(
		post_post => sub {
			my $j = shift;
			$output = $j->output;
			# $c->log->debug( $output );
			# $c->log->debug( '#' x 30 );
			# $c->log->debug( Dumper $j );
		}
	);

    my $filename = $c->request->params->{'files[]'};
    $j_fu->ctx($c);
    $j_fu->filename($filename);
    $j_fu->thumbnail_filename("thumb_$filename");

    my $local_dir = $c->stash->{path};
    my $upload_dir = $upload_dir_base . $local_dir;
    make_path($upload_dir) if ! -d $upload_dir;

    $j_fu->upload_dir("$upload_dir");
    $j_fu->upload_url_base($upload_url . $local_dir);
    $j_fu->thumbnail_url_base($upload_url . $local_dir);

    $j_fu->delete_params([ 'filename', $filename, 'thumbnail_filename', "thumb_$filename", 'image', 'y' ]);
    $j_fu->max_file_size(10000000);   # 10Mo

    $j_fu->handle_request;
    $j_fu->print_response;
	$c->res->body( $output );
}


sub attachment_DELETE :ActionClass('Serialize') {
    my ( $self, $c ) = @_;

    my $local_dir  = $c->stash->{path};
    my $upload_dir = $upload_dir_base . $local_dir;
    my $img        = $upload_dir . '/' . $c->req->param('filename');
    my $img_thumb  = $upload_dir . '/' .$c->req->param('thumbnail_filename');

    eval {
    	die unless -e $img;
    	die unless -e $img_thumb;

    	unlink $img or die;
    	unlink $img_thumb or die;
    };

    $c->stash->{'rest'} = {
			   files => [
				     { $c->req->param('filename') => $@ ? JSON::false : JSON::true },
				     { $c->req->param('thumbnail_filename') => $@ ? JSON::false : JSON::true },
				    ]
			  };
    $c->response->status(200);
}


=encoding utf8

=head1 AUTHOR

Daniel Brosseau, 2016, <dab@catapulse.org>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
