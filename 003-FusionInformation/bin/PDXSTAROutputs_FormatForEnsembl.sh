#!/bin/bash
mkdir ./results

File=$(echo "../../../STARFusion_FilteringOutput/results/"$i"_FrameFusions.tsv")
OutputFile=$(echo "./results/FusionGenesInfo.txt")
Tmp_Output=$(echo "./results/FusionGenesInfo_Tmp.txt")
touch $Tmp_Output

File = $(echo ./data/File.txt)
FirstLine=$(echo "TRUE")
while read -r line
do
	if [ "$FirstLine" == "FALSE" ]; then
		
		#Saving left transcript information		

                LeftGene_GeneName=$(echo $line | cut -d" " -f7 | cut -d"^" -f1)
                LeftGene_GeneID=$(echo $line | cut -d" " -f7 | cut -d"^" -f2 | cut -d"." -f1)
                LeftGene_BrkPointStart=$(echo $line | cut -d" " -f8 | cut -d":" -f2)
                LeftGene_BrkPointEnd=$LeftGene_BrkPointStart
                LeftGene_Strand=$(echo $line | cut -d" " -f8 | cut -d":" -f3)
                LeftGene_TranscriptID=$(echo $line | cut -d" " -f18 | cut -d"." -f1)

		#Saving right transcript information
	
                RightGene_GeneName=$(echo $line | cut -d" " -f9 | cut -d"^" -f1)
                RightGene_GeneID=$(echo $line | cut -d" " -f9 | cut -d"^" -f2 | cut -d"." -f1)
                RightGene_BrkPointStart=$(echo $line | cut -d" " -f10 | cut -d":" -f2)
                RightGene_BrkPointEnd=$RightGene_BrkPointStart
                RightGene_Strand=$(echo $line | cut -d" " -f10 | cut -d":" -f3)
                RightGene_TranscriptID=$(echo $line | cut -d" " -f20 | cut -d"." -f1)

		#Create a fusion-id to connect the information

                Fusion=$(echo $line | cut -d" " -f1)
                Fusion_Identifier=$(echo $Fusion":"$LeftGene_TranscriptID":"$LeftGene_BrkPointStart":"$LeftGene_Strand":"$RightGene_TranscriptID":"$RightGene_BrkPointStart":"$RightGene_Strand)

		#Writeing information

                NewLine1=$(echo -e $Fusion_Identifier'\tLeft\t'$LeftGene_GeneName'\t'$LeftGene_GeneID'\t'$LeftGene_BrkPointStart'\t'$LeftGene_BrkPointEnd'\t'$LeftGene_Strand'\t'$LeftGene_TranscriptID'\n')
                NewLine2=$(echo -e $Fusion_Identifier'\tRight\t'$RightGene_GeneName'\t'$RightGene_GeneID'\t'$RightGene_BrkPointStart'\t'$RightGene_BrkPointEnd'\t'$RightGene_Strand'\t'$RightGene_TranscriptID'\n')
                echo $NewLine1 >> $Tmp_Output
                echo $NewLine2 >> $Tmp_Output
        fi
        FirstLine=$(echo "FALSE")
done < $File

#Removing duplicated transcripts 

sort -u $Tmp_Output > $OutputFile
rm $Tmp_Output
