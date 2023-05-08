#!/usr/bin/perl
###############################################################################################################
###############################################################################################################
##Title: ENSEMBL Connection. Download the domains for each fusions-structure transcript from ENSEMBL.
###Version: 2.0.0
###Author: J. Rene Wong & C. Daniela Robles Espinoza.
###Laboratory: CGBio/Robles-Espinoza Lab, LIIGH UNAM.
###Date: May 7, 2023. 
###Modifications: Modified for one input file.
################################################################################################################
###############################################################################################################

use strict;
use warnings;
use Bio::EnsEMBL::Registry;
use Getopt::Long;

###############################################################################################################

#Parameters

my $InputFile = "./data/File.txt";
my $OutputFile = "./results/File_EnsemblDomains.txt";     

###############################################################################################################

#ENSEMBL Connection

my $registry = 'Bio::EnsEMBL::Registry';
$registry -> load_registry_from_db(
                        -host => 'useastdb.ensembl.org',
                        -user => 'anonymous' );
my $gene_adaptor = $registry -> get_adaptor( 'human', 'core', 'gene' );
my $tr_adaptor = $registry -> get_adaptor( 'human', 'core', 'transcript' );
my $slice_adaptor = $registry -> get_adaptor( 'Human', 'Core', 'Slice' );
my ( @coord_cds, @Files );

###############################################################################################################

#Open input and output files
	
open my $in, "<:encoding(utf8)", $InputFile or die "$InputFile: $!";
open(Output, ">", $OutputFile) or die $!;

################################################################################################################

#Reading each line from the input file and extracting information: For each fusion: A--B, we aim to extract all the domains for A and B 

while(my $line = <$in>){
	#print("File has been opened\n");
	#Parsing variables 
	my ($FusionID, $FusionPosition, $GeneName, $GeneID, $BrkPoint_St, $BrkPoint_End, $Strand, $TranscriptID) = split (/ /, $line);
	chop($TranscriptID);
	if($Strand eq "+"){
		$Strand = 1;
	}else{
		$Strand = -1;
	}	
	#print("$TranscriptID\n");
	my $transcript = $tr_adaptor  -> fetch_by_stable_id( $TranscriptID );
	#print(ref($transcript) . "\n");
	if(ref($transcript) eq "Bio::EnsEMBL::Transcript"){
        	my $trmapper = Bio::EnsEMBL::TranscriptMapper->new($transcript);
                my $Transcript_Biotype = $transcript -> biotype;
                if( $transcript -> biotype eq "protein_coding"){ #If the transcript is labeled as 'protein_coding', we download its domains
                	@coord_cds = $trmapper -> genomic2cds($BrkPoint_St, $BrkPoint_End, $Strand);
                
                        #Saving the transcript breaking point coordinate in CDS coordinates 
                        my $NewLine = "$FusionID\t$FusionPosition\t$GeneName\t" . $coord_cds[0] -> start . "\t" . $coord_cds[0] -> end . "\n";
                        my @domains = @{ $transcript -> translation -> get_all_DomainFeatures };
                        print Output $NewLine;
                        foreach my $domain ( @domains ){
                        	my $des = $domain -> hdescription();
                                my $NewLine = $transcript -> stable_id . "\t" . $domain -> display_id . "\t" . $domain -> start . "\t". $domain -> end . "\t" . $des . "\n";
                                print Output $NewLine;
                        }
			}
	}
}

###############################################################################################################

#Closing files

close $in;
close(Output);

###############################################################################################################
########################################### END OF THE SCRIPT #################################################
###############################################################################################################
