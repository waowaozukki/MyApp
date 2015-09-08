#!perl
use strict;
use warnings;
use File::Spec;
use File::Basename;
use lib File::Spec->catdir(dirname(__FILE__), 'lib');
use MyApp;
use MyApp::Web;
use Plack::Builder;

    builder {
        mount "/" => MyApp::Web->to_app;
    };
