mkdir ./results

awk '$22!= "." {print $0}' ./data/STARFusion_Output.txt > ./results/STARFusion_InFrameFusions.txt
