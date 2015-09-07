#!perl
use strict;
use warnings;
use File::Spec;
use File::Basename;
use lib File::Spec->catdir('/root/MyApp/', 'lib');
use MyApp::Web;
use Plack::Builder;

    builder {
        mount "/" => MyApp::Web->to_app;
    };
