use strict;
use warnings;
use v5.14;

package Textoola::PatternStatParser;

sub new {
    my $class = shift;
    my %args  = @_;

    my $self={
	separator       => '\s',
	separator_subst => ' ',
	path            => $args{path},
	patternstats    => {},
    };

    bless $self, $class;
    return $self;
}

sub parse_line {
    my $self = shift;
    my $line = shift;

    chomp $line;
    my $sep      = $self->{separator};
    my $sepsub   = $self->{separator_subst};
    my $patstats = $self->{patternstats};
    my @tokens   = split /$sep/,$line;

    my $pattern;
    if (scalar(@tokens)) {
	$pattern //= shift @tokens;
	$patstats->{$pattern}++;
	
	while (scalar(@tokens)) {
	    $pattern .= $sepsub.shift @tokens;
	    $patstats->{$pattern}++;
	}
    }
}

sub parse {
    my $self = shift;
    my $path = $self->{path};
    
    my $fh;
    if (defined $path) {
	open($fh,"<",$path) or die "File $path not found";
    } else {
	$fh=*STDIN;
    }

    while(my $line=<$fh>) {
	$self->parse_line($line);
    }
    
    close $fh;
}

sub patternstats {
    my $self = shift;
    return $self->{patternstats};
}


1;
