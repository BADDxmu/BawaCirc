#! /usr/bin/perl -w
use strict;
die "#usage;perl $0 <input.cds.fa><out.pep.fa>\n" unless @ARGV==2;
my $incds=shift;
my $outpep=shift;
###output the pep sequeces###
cds2pep($incds,$outpep);
#####################################
##############subroutine#############
#####################################
sub cds2pep{
	my ($infile,$outfile)=@_;
	open IN,'<',$infile||die;
	open OUT,'>',$outfile||die;
	my $p=code();
	$/=">";<IN>;$/="\n";
	while(<IN>){
		chomp;
		my $head=$_;
		$/=">";
		chomp(my $seq=<IN>);
		$/="\n";
		$seq=~s/\n+//g;
		my $out;
		for(my $i=0;$i<length$seq;$i+=3){
			my $codon=uc(substr($seq,$i,3));
			last if (length$codon <3);
			$out.= exists $p->{"standard"}{$codon} ? $p->{"standard"}{$codon} : "X";
		}
		$out =~ s/U$//;
		my $len=length$out;
		$out =~ s/([A-Z]{50})/$1\n/g;
		chop $out unless $len % 50;
		print OUT ">$head [translate_table: standard]\n$out\n"
	}
	close OUT;
}
#####################################
sub code{
	my $p={
        	"standard" =>
                 	{       
                        	'GCA' => 'A', 'GCC' => 'A', 'GCG' => 'A', 'GCT' => 'A',                               # Alanine
                                'TGC' => 'C', 'TGT' => 'C',                                                           # Cysteine
                                'GAC' => 'D', 'GAT' => 'D',                                                           # Aspartic Aci
                                'GAA' => 'E', 'GAG' => 'E',                                                           # Glutamic Aci
                                'TTC' => 'F', 'TTT' => 'F',                                                           # Phenylalanin
                                'GGA' => 'G', 'GGC' => 'G', 'GGG' => 'G', 'GGT' => 'G',                               # Glycine
                                'CAC' => 'H', 'CAT' => 'H',                                                           # Histidine
                                'ATA' => 'I', 'ATC' => 'I', 'ATT' => 'I',                                             # Isoleucine
                                'AAA' => 'K', 'AAG' => 'K',                                                           # Lysine
                                'CTA' => 'L', 'CTC' => 'L', 'CTG' => 'L', 'CTT' => 'L', 'TTA' => 'L', 'TTG' => 'L',   # Leucine
                                'ATG' => 'M',                                                                         # Methionine
                                'AAC' => 'N', 'AAT' => 'N',                                                           # Asparagine
                                'CCA' => 'P', 'CCC' => 'P', 'CCG' => 'P', 'CCT' => 'P',                               # Proline
                                'CAA' => 'Q', 'CAG' => 'Q',                                                           # Glutamine
                                'CGA' => 'R', 'CGC' => 'R', 'CGG' => 'R', 'CGT' => 'R', 'AGA' => 'R', 'AGG' => 'R',   # Arginine
                                'TCA' => 'S', 'TCC' => 'S', 'TCG' => 'S', 'TCT' => 'S', 'AGC' => 'S', 'AGT' => 'S',   # Serine
                                'ACA' => 'T', 'ACC' => 'T', 'ACG' => 'T', 'ACT' => 'T',                               # Threonine
                                'GTA' => 'V', 'GTC' => 'V', 'GTG' => 'V', 'GTT' => 'V',                               # Valine
                                'TGG' => 'W',                                                                         # Tryptophan
                                'TAC' => 'Y', 'TAT' => 'Y',                                                           # Tyrosine
                                'TAA' => 'U', 'TAG' => 'U', 'TGA' => 'U'                                              # Stop
                         }
       		## more translate table could be added here in future
              	## more translate table could be added here in future
              	## more translate table could be added here in future
	};
	return $p;
}
