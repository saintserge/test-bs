#!/usr/bin/perl

use v5.32;
use warnings;

use BoardStreams::Client;
use Mojo::IOLoop;

use constant PASSWORD => '...';

my $BS = BoardStreams::Client->new('ws://127.0.0.1/ws');
my $ch = $BS->join_channel('counter');

Mojo::IOLoop->recurring(2, sub {
    $ch->do_action('inc_by_1', {xx => time() });
});

Mojo::IOLoop->start;
