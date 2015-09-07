package MyApp::Web::C::Root;
use strict;
use warnings;
use utf8;

use File::Spec;
use URI::Escape;
sub say {
    my ($class, $c, $args) = @_;

    my %args;
    {
        my $valid_args = $c->validator({
            params => $args,
            rule   => {
                tmpl_path  => { isa => 'Str' },
                hitokoto   => { isa => 'Str' },
            },
        });
        $args{tmpl_path} = $valid_args->{tmpl_path};
        $args{hitokoto} = $valid_args->{hitokoto};
    }

    my $tmpl_path = "$args{tmpl_path}.tt";
    unless (-e File::Spec->catdir($c->base_dir(), 'tmpl/web/' . $tmpl_path)) {
        $c->warn_log_to('page.not_found  '. 'tmpl/web/' . $tmpl_path);
        return $c->res_404();
    }

    return $c->render('web/'.$tmpl_path, \%args);
}

1;
