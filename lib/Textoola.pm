use strict;
use warnings;
package Textoola;


sub parse_file {
    my $path = shift;
    open(my $fh,"<",$path) or die "File $path not found";

    my %patstats;
    while(my $line=<$fh>) {
	chomp $line;
	$line =~ s/\t/ /g;
	$line =~ s/^\s+//g;
	$line =~ s/\s+$//g;
	$line =~ s/\s+/ /g;
	my $pattern;
	my @items = split /\s/,$line;
	while (scalar(@items)) {
	    $pattern //= shift @items;
	    $patstats{$pattern}++;
	    
	    while (scalar(@items)) {
		$pattern .= " ".shift @items;
		$patstats{$pattern}++;
	    }
	}
    }
    close $fh;
    return \%patstats;
}

1;
