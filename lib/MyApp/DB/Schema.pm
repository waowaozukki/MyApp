package MyApp::DB::Shema::Schema;
use strict;
use warnings;
use Teng::Schema::Declare;
table {
    name 'block_id_name';
    pk 'id';
    columns (
        {name => 'name', type => 12},
        {name => 'id', type => 12},
    );
};

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

table {
    name 'mcmmo_cooldowns';
    pk 'user_id';
    columns (
        {name => 'blast_mining', type => 4},
        {name => 'axes', type => 4},
        {name => 'repair', type => 4},
        {name => 'mining', type => 4},
        {name => 'archery', type => 4},
        {name => 'herbalism', type => 4},
        {name => 'woodcutting', type => 4},
        {name => 'taming', type => 4},
        {name => 'acrobatics', type => 4},
        {name => 'excavation', type => 4},
        {name => 'unarmed', type => 4},
        {name => 'user_id', type => 4},
        {name => 'swords', type => 4},
    );
};

table {
    name 'mcmmo_experience';
    pk 'user_id';
    columns (
        {name => 'alchemy', type => 4},
        {name => 'axes', type => 4},
        {name => 'repair', type => 4},
        {name => 'mining', type => 4},
        {name => 'archery', type => 4},
        {name => 'herbalism', type => 4},
        {name => 'woodcutting', type => 4},
        {name => 'taming', type => 4},
        {name => 'fishing', type => 4},
        {name => 'acrobatics', type => 4},
        {name => 'excavation', type => 4},
        {name => 'unarmed', type => 4},
        {name => 'user_id', type => 4},
        {name => 'swords', type => 4},
    );
};

table {
    name 'mcmmo_huds';
    pk 'user_id';
    columns (
        {name => 'mobhealthbar', type => 12},
        {name => 'user_id', type => 4},
    );
};

table {
    name 'mcmmo_skills';
    pk 'user_id';
    columns (
        {name => 'alchemy', type => 4},
        {name => 'axes', type => 4},
        {name => 'repair', type => 4},
        {name => 'mining', type => 4},
        {name => 'archery', type => 4},
        {name => 'herbalism', type => 4},
        {name => 'woodcutting', type => 4},
        {name => 'taming', type => 4},
        {name => 'fishing', type => 4},
        {name => 'acrobatics', type => 4},
        {name => 'excavation', type => 4},
        {name => 'unarmed', type => 4},
        {name => 'user_id', type => 4},
        {name => 'swords', type => 4},
    );
};

table {
    name 'mcmmo_users';
    pk 'id';
    columns (
        {name => 'user', type => 12},
        {name => 'id', type => 4},
        {name => 'lastlogin', type => 4},
    );
};

1;
