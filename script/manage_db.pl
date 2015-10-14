#!/usr/bin/env perl

use FindBin;
use lib "$FindBin::Bin/../lib";

use Catapulse::Web;
use DBIx::Class::Migration::Script;

DBIx::Class::Migration::Script
    ->run_with_options(
        schema => Catapulse::Web->model('DBIC')->schema);


# my $conffile = 'catapulse_web.yml';
# -f $conffile or die "Error (conf: $conffile) : $!\n";

# my $cfg = Config::Any->load_files({files => [ $conffile ], use_ext => 1 });
# my ($filename, $conf) = %{$cfg->[0]};


# die "'connect_info' was not found in $conffile"
#     if ( ! defined $conf->{$model}->{connect_info});

# my $connect_info = $conf->{$model}->{connect_info};
# my $dsn = $connect_info->{dsn};

# print "dsn=$dsn\n";
