package MyApp::DB::Shema;
use strict;
use warnings;
use Teng::Schema::Declare;
table {
    name 'hawk_players';
    pk 'player_id';
    columns (
        {name => 'player_id', type => 4},
        {name => 'player', type => 12},
    );
};

table {
    name 'hawk_worlds';
    pk 'world_id';
    columns (
        {name => 'world_id', type => 4},
        {name => 'world', type => 12},
    );
};

table {
    name 'hawkeye';
    pk 'data_id';
    columns (
        {name => 'world_id', type => 4},
        {name => 'data', type => 12},
        {name => 'x', type => 4},
        {name => 'data_id', type => 4},
        {name => 'y', type => 4},
        {name => 'timestamp', type => 11},
        {name => 'player_id', type => 4},
        {name => 'action', type => 4},
        {name => 'z', type => 4},
    );
};

1;
