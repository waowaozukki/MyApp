package MyApp::Web::C::Root;
use strict;
use warnings;
use utf8;

use File::Spec;
use URI::Escape;
use Time::Piece;
use Data::Dumper;

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

    my $input = { %$args, %{$c->req->parameters->as_hashref} };
#    my $input = $c->validator({
#        params => { %$args, %{$c->req->parameters->as_hashref} },
#        rule   => {
#            start_date_time => { isa => 'Str',  optional => 1 },
#            end_date_time   => { isa => 'Str',  optional => 1 },
#            player_id       => { isa => 'Str',  optional => 1 },
#            limit           => { isa => 'UInt', default => 100, optional => 1 },
#            page            => { isa => 'UInt', default => 1, optional => 1 },
#            asc_desc        => { isa => 'Str',  default => 'desc',  optional => 1 },
#        },
#    });

    my $start_date_tp = ($input->{start_date_time}) ? Time::Piece->strptime($input->{start_date_time}, '%Y-%m-%d %H:%M:%S') : Time::Piece->strptime('2015-09-01 00:00:00', '%Y-%m-%d %H:%M:%S');
    my $start_date = $start_date_tp->strftime('%Y-%m-%d %H:%M:%S');
    my $end_date_tp   = ($input->{end_date_time})   ? Time::Piece->strptime($input->{end_date_time}, '%Y-%m-%d %H:%M:%S')   : Time::Piece->strptime(Time::Piece->new->ymd.' 23:59:59', '%Y-%m-%d %H:%M:%S');
    my $end_date = $end_date_tp->strftime('%Y-%m-%d %H:%M:%S');
    $input->{page} ||= 1;
    my $opt = {
        start_date => $start_date,
        end_date => $end_date,
    };

    my $player_id_sql = '';
    if ($input->{player_id}) {
        $opt->{player_id} = $input->{player_id};
        $player_id_sql = ' AND hp.player = :player_id ';
    }

    my $point_x_sql = '';
    if (defined($input->{point_x})) {
        $opt->{point_x} = $input->{point_x};
        $point_x_sql = ' AND h.x = :point_x ';
    }

    my $point_y_sql = '';
    if (defined($input->{point_y})) {
        $opt->{point_y} = $input->{point_y};
        $point_y_sql = ' AND h.y = :point_y ';
    }

    my $point_z_sql = '';
    if (defined($input->{point_z})) {
        $opt->{point_z} = $input->{point_z};
        $point_z_sql = ' AND h.z = :point_z ';
    }

    my $asc_desc = $input->{asc_desc} || 'desc';
    my $limit  = $input->{limit} || 100;
    my $offset = ($input->{page}-1) ? ($input->{page}-1)*100 : 0;

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
        WHERE
            h.timestamp >= :start_date
            AND h.timestamp <= :end_date
            $player_id_sql
            $point_x_sql
            $point_y_sql
            $point_z_sql 
        ORDER BY
            h.timestamp $asc_desc
        LIMIT
            $limit
        OFFSET
            $offset
SQL

    my @members = $c->db->search_named($sql, $opt, [], 'hawkeye');
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

    my $prev_page_params;
    if($input->{page} > 1) {
        my $prev_page = $input->{page} - 1;
        $prev_page_params = '?page='.$prev_page.'&start_date_time='.$start_date.'&end_date_time='.$end_date;
        $prev_page_params .= ($input->{player_id}) ? '&player_id='.$input->{player_id} : '';
        $prev_page_params .= (defined($input->{point_x})) ? '&point_x='.$input->{point_x} : '';
        $prev_page_params .= (defined($input->{point_y})) ? '&point_y='.$input->{point_y} : '';
        $prev_page_params .= (defined($input->{point_z})) ? '&point_z='.$input->{point_z} : '';
    }

    my $next_page = $input->{page} + 1;
    my $next_page_params = '?page='.$next_page.'&start_date_time='.$start_date.'&end_date_time='.$end_date;
    $next_page_params .= ($input->{player_id}) ? '&player_id='.$input->{player_id} : '';
    $next_page_params .= (defined($input->{point_x})) ? '&point_x='.$input->{point_x} : '';
    $next_page_params .= (defined($input->{point_y})) ? '&point_y='.$input->{point_y} : '';
    $next_page_params .= (defined($input->{point_z})) ? '&point_z='.$input->{point_z} : '';

    return $c->render('web/member.tt', +{
        prev_page_params => $prev_page_params,
        next_page_params => $next_page_params,
        data_name_map => \%data_name_map,
        members => \@members,
        (($input->{player_id}) ? (player_id => $input->{player_id}) : ()),
        ((defined($input->{point_x})) ? (point_x => $input->{point_x}) : ()),
        ((defined($input->{point_y})) ? (point_y => $input->{point_y}) : ()),
        ((defined($input->{point_z})) ? (point_z => $input->{point_z}) : ()),
        (($input->{start_date_time}) ? (start_date_time => $input->{start_date_time}) : ()),
        (($input->{end_date_time}) ? (end_date_time => $input->{end_date_time}) : ()),
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
