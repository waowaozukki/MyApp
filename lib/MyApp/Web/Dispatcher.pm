package MyApp::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Mine::Web::Dispatcher::Lite;

my $router = router {
    # root
    submapper('/', { controller => 'Root' })
        ->connect('say/{tmpl_path:[a-zA-Z0-9/_-]+}/{hitokoto:[a-zA-Z0-9/_-]+}/', { action => 'say' })
};

dispatch_with $router,
    controller => controller();

sub controller { 'MyApp::Web::C' }

sub routing { $router }

1;
