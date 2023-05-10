#!/bin/bash
######################################################################################

#Input and output file names

EnsemblDomains_InputFile=$(echo './data/ENSEMBL_Domains.txt')
ConservedDomains_OutputFile=$(echo './results/ConservedDomains_OutputFile.txt')
BothDomais_OutputFile=$(echo './results/BothDomais_OutputFile.txt')
NoDomains_OutputFile=$(echo './results/NoDomains_OutputFile.txt')
LeftDomains_OutputFile=$(echo './results/LeftDomains_OutputFile.txt')
RightDomains_OutputFile=$(echo './results/RightDomains_OutputFile.txt')

######################################################################################

#Creating output folder

mkdir ./results

######################################################################################

#Classifying in-frame fusions based on domain conservation
        
python ./bin/FusionClassficator_V1.py --EnsemblDomains_InputFile $EnsemblDomains_InputFile \
	--ConservedDomains_OutputFile $ConservedDomains_OutputFile \
	--BothDomais_OutputFile $BothDomais_OutputFile \
	--NoDomains_OutputFile $NoDomains_OutputFile \
	--LeftDomains_OutputFile $LeftDomains_OutputFile \
	--RightDomains_OutputFile $RightDomains_OutputFile
