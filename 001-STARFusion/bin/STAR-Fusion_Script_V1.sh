#############################################################################

#!/bin/bash

#############################################################################

#Parameters

BAM_File=$(echo './data/SampleBAM.bam')
Sorted_BAM=$(echo $BAM_File | sed -e 's/data/results/' | sed -e 's/\.bam/_SortedBAM\.bam/')
R1_fastq=$(echo './results/Sample_R1.fastq.gz')
R2_fastq=$(echo './results/Sample_R2.fastq.gz')
STAR_Fusion_OutputFolder=$(echo './results/STARFusion_Output')

#############################################################################

mkdir ./results

#############################################################################

#From BAM to FASTQ

samtools sort -n $BAM_File2 -o $Sorted_BAM
samtools fastq -@ 8 $Sorted_BAM \
	-1 $R1_fastq \
        -2 $R2_fastq

#############################################################################

#STAR-Fusion

singularity exec -e -B `pwd` -B /mnt/Adenina/drobles/jchion/LatinAmerican_Melanoma/FusionTranscripts/STAR_Fusion/genome_reference/GRCh38_gencode_v37_CTAT_lib_Mar012021.plug-n-play/ctat_genome_lib_build_dir \
        ./star-fusion.v1.11.1.simg \
        STAR-Fusion \
        --left_fq $R1_fastq \
        --right_fq $R2_fastq \
        --genome_lib_dir /mnt/Adenina/drobles/jchion/LatinAmerican_Melanoma/FusionTranscripts/STAR_Fusion/genome_reference/GRCh38_gencode_v37_CTAT_lib_Mar012021.plug-n-play/ctat_genome_lib_build_dir \
        -O $STAR_Fusion_OutputFolder \
        --FusionInspector validate \
        --examine_coding_effect \
        --denovo_reconstruct

