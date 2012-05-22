#!/usr/bin/perl

use strict;
use warnings;

use Test::More;


my @moose_exports = qw(
    extends with
    has
    before after around
    override
    augment
    super inner
    blessed confess
);

{
    package Foo;

    eval 'use Moose';
    die $@ if $@;
}

can_ok('Foo', $_) for @moose_exports;

{
    package Foo;

    eval 'no Moose';
    die $@ if $@;
}

ok(!Foo->can($_), '... Foo can no longer do ' . $_) for @moose_exports;

my $va_ret;
{
    package Foo::Va;
    use Moose;
    $va_ret = eval 'vamoose';
}
ok($va_ret, 'vamoose returns true');
ok(!Foo::Va->can($_), 'Foo::Va can no longer do ' . $_) for @moose_exports;


# and check the type constraints as well

my @moose_type_constraint_exports = qw(
    type subtype as where message
    coerce from via
    enum
    find_type_constraint
);

{
    package Bar;

    eval 'use Moose::Util::TypeConstraints';
    die $@ if $@;
}

can_ok('Bar', $_) for @moose_type_constraint_exports;

{
    package Bar;

    eval 'no Moose::Util::TypeConstraints';
    die $@ if $@;
}

ok(!Bar->can($_), '... Bar can no longer do ' . $_) for @moose_type_constraint_exports;


{
    package Baz;

    use Moose;
    use Scalar::Util qw( blessed );

    no Moose;
}

can_ok( 'Baz', 'blessed' );

{
    package Moo;

    use Scalar::Util qw( blessed );
    use Moose;

    no Moose;
}

can_ok( 'Moo', 'blessed' );

my $blessed;
{
    package Quux;

    use Scalar::Util qw( blessed );
    use Moose blessed => { -as => \$blessed };

    no Moose;
}

can_ok( 'Quux', 'blessed' );
is( $blessed, \&Scalar::Util::blessed );

done_testing;
