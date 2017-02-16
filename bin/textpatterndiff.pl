#!/usr/bin/perl

use strict;
use warnings;
use v5.14;

use Getopt::Long;
use Textoola::PatternStatParser;
use Textoola::PatternStatComparator;

my %args;

GetOptions (
    "from:s"        => \$args{from},
    "to:s"          => \$args{to},
    "threshhold:s"  => \$args{threshhold},
    );

my $from_parser = Textoola::PatternStatParser->new(path=>$args{from});
my $to_parser   = Textoola::PatternStatParser->new(path=>$args{to});

$from_parser->parse();
$to_parser->parse();

my $from_stats = $from_parser->patternstats();
my $to_stats   = $to_parser->patternstats();

my $c=Textoola::PatternStatComparator->new(
	patternstats1 => $from_stats,
	patternstats2 => $to_stats,
	);
my $result=$c->compare_reduce();

for my $pattern (sort keys %$result) {
    if ($result->{$pattern} eq '*') {
	say "   *%".": ".$pattern;
    } else {
	say sprintf("%4d%%",(100*$result->{$pattern})).": ".$pattern;
    }
}

