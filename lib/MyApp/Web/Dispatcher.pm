package MyApp::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Mine::Web::Dispatcher::Lite;

my $router = router {
    # root
    submapper('/', { controller => 'Root' })
        ->connect('bootcamp/', { action => 'bootcamp' })
        ->connect('info/', { action => 'info' })
        ->connect('plugins/', { action => 'plugins' })
        ->connect('staff/', { action => 'staff' })
        ->connect('news/', { action => 'news' })
        ->connect('news/{tmpl_path:[a-zA-Z0-9/_-]+}', { action => 'news_page' })
        ->connect('member/', { action => 'member' })
        ->connect('ranking/', { action => 'ranking' })
        ->connect('say/{tmpl_path:[a-zA-Z0-9/_-]+}/{hitokoto:[a-zA-Z0-9/_-]+}/', { action => 'say' })
};

dispatch_with $router,
    controller => controller();

sub controller { 'MyApp::Web::C' }

sub routing { $router }

1;
