
###############################################################################
# Author: Carol Moraga 
# Laboratory: ERABLE
# Copyright (c)
# year: 2020
###############################################################################
use Data::Dumper;
use Getopt::Std;
use strict;

sub usage {
	print "$0 usage : -a <fai> -b <genome_size>  -c <min_contig_size>\n";
	print "Error in use\n";
	exit 1;
}

my %opts = ();
getopts( "a:b:c:", \%opts );
if ( !defined $opts{a}  ) {
	usage;
}


open(FILE,$opts{a}) or die "cannot open file $opts{a}\n";
my $min=0;
my $max=0;
my $size=0;
my $N50=0;
my @len=();
my $number=0;
my $minl=0;
if(defined $opts{c}){
	$minl=$opts{c};
}
	
while(my $line=<FILE>){
	chomp $line;
	my @data=split (" ",$line);
	#print Dumper(@data);
	#we skypt short contigs
	next if($data[1] < $minl);
	push(@len, $data[1]);
	$size+=$data[1];
	$number++;
}

my @len_sort=sort {$b<=>$a} @len;
#print Dumper(int($size * 0.5) ,$number);
my $acu=0;
my $i=0;
my $n50=0;
my $llen=$size;

if(defined $opts{b}){
	$llen=$opts{b};
}
foreach my $l(@len_sort){
	$acu+=$l;
	$i++;
	if($acu >= int($llen * 0.5)){
		#print join("\t",$i,$l,$acu)."\n";
		$n50=$l;
		last;
	}
}

 $acu=0;
 $i=0;
my $n75=0;
foreach my $l(@len_sort){
	$acu+=$l;
	$i++;
	if($acu >= int($llen * 0.75)){
		#print join("\t",$i,$l,$acu)."\n";
		$n75=$l;
		last;
	}
}



#print join("\t",$number,$len_sort[$#len_sort],$len_sort[0],$i,$n50,$acu,$size,)."\n";
print join("\t",$opts{a},$number,$len_sort[$#len_sort],$len_sort[0],$n50,$n75,$size)."\n";

