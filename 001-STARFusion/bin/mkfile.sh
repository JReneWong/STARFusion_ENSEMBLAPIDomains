#!/bin/bash
######################################################################################

#Input and output file names

BAM_File=$(ls ./data | grep -e '.bam$')
BAM_File2=$(echo './data/'$BAM_File)

Sorted_BAM=$(echo $BAM_File | sed -e 's/\.bam/_SortedBAM\.bam/')
Sorted_BAM2=$(echo './results/'$Sorted_BAM)

R1_fastq=$(echo './data/R1.fastq.gz')
R2_fastq=$(echo './data/R2.fastq.gz')
STAR_Fusion_OutputFolder=$(echo ./results')

######################################################################################

#Creating output folder

mkdir ./results

######################################################################################

#From BAM to fastq (R1 and R2)
        
samtools sort -n $BAM_File2 -o $Sorted_BAM
samtools fastq -@ 8 $Sorted_BAM \
	-1 $R1_fastq \
        -2 $R2_fastq

######################################################################################

#Running STAR-Fusion with singularity

singularity exec -e -B `pwd` -B ../reference/genome_reference/GRCh38_gencode_v37_CTAT_lib_Mar012021.plug-n-play/ctat_genome_lib_build_dir \
        ./star-fusion.v1.11.1.simg \
        STAR-Fusion \
        --left_fq $R1_fastq \
        --right_fq $R2_fastq \
        --genome_lib_dir ../reference/genome_reference/GRCh38_gencode_v37_CTAT_lib_Mar012021.plug-n-play/ctat_genome_lib_build_dir \
        -O $STAR_Fusion_OutputFolder \
        --FusionInspector validate \
        --examine_coding_effect \
        --denovo_reconstruct

