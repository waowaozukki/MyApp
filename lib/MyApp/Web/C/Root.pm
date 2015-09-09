package MyApp::Web::C::Root;
use strict;
use warnings;
use utf8;

use File::Spec;
use URI::Escape;

sub ranking {
    my ($class, $c, $args) = @_;

    my $sql = <<"SQL";
    select
        hp.player,
        count(*) as activity
    from
        hawkeye h
        inner join hawk_players hp on h.player_id = hp.player_id
        inner join hawk_worlds hw on h.world_id = hw.world_id
    group by
        hp.player
    order by
        activity desc
SQL

    my @rankings = $c->db->search_named($sql, {});

    return $c->render('web/ranking.tt', +{
        rankings => \@rankings,
    });
}

sub member {
    my ($class, $c, $args) = @_;

    my $sql = <<"SQL";
        SELECT
            h.data_id,
            h.timestamp,
            hp.player,
            hw.world,
            h.action,
            h.x,
            h.y,
            h.z,
            h.data
        FROM
            hawkeye h
            inner join hawk_players hp on h.player_id = hp.player_id
            inner join hawk_worlds hw on h.world_id = hw.world_id
        ORDER BY
            h.timestamp desc
        LIMIT
            100
SQL

    my @members = $c->db->search_named($sql, {});

    my @blocks = $c->db->search('block_id_name', {});

    my %block_id_map = map { $_->id => $_ } @blocks;
    my %data_name_map;

    for my $member (@members) {
        my $data = $member->data;
        next if exists($data_name_map{$data});
        if ($member->action) {
            my ($from,$to) = split('-', $data);
            $data_name_map{$data} .= $class->_get_block_name($from,\%block_id_map);
            $data_name_map{$data} .= ' -> ';
            $data_name_map{$data} .= $class->_get_block_name($to,\%block_id_map);
        } else {
            $data_name_map{$data} = $class->_get_block_name($data,\%block_id_map);
        }
    }

    return $c->render('web/member.tt', +{
        data_name_map => \%data_name_map,
        members => \@members,
    });
}

sub _get_block_name {
    my ($class, $data, $all_block_id_map) = @_;

    my $block = $all_block_id_map->{$data};
    if (!$block && $data =~ m|\d+:\d+|) {
        my ($base,$add) = split(':', $data);
        $block = $all_block_id_map->{$base};
    }

    my $block_name = ($block) ? $block->name : 'NO NAME';

    return $block_name;
}

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
