#!/usr/bin/perl

use strict;
use warnings;

use Test::More 'no_plan';

use ok 'Search::GIN::Keys::Deep';

{
    package Foo;
    use Moose;

    with qw(Search::GIN::Keys::Deep);
}

my $foo = Foo->new;

ok( $foo->does("Search::GIN::Keys::Join"), "does Join" );
ok( $foo->does("Search::GIN::Keys::Expand"), "does Expand" );

is_deeply(
    [ $foo->join_keys(undef, [qw(foo bar gorch)], [qw(baz zot)]) ],
    [ "foo:bar:gorch", "baz:zot" ],
    "join keys",
);

is_deeply(
    [ $foo->expand_keys(undef, { foo => [qw(bar gorch)] }) ],
    [ [qw(foo bar)], [qw(foo gorch)] ],
    "expand keys",
);

is_deeply(
    [ $foo->process_keys(undef, qw(la la la)) ],
    [ qw(la la la) ],
    "simple keys",
);

is_deeply(
    [ $foo->process_keys(undef, { foo => [ qw(bar gorch) ] }) ],
    [ qw(foo:bar foo:gorch) ],
    "prefixing",
);

is_deeply(
    [ sort $foo->process_keys(undef, [ { a => [qw(b)], foo => [ { thingy => [qw(bar gorch)] }, "thing" ] } ]) ],
    [ sort qw(a:b foo:thingy:bar foo:thingy:gorch foo:thing) ],
    "complex",
);