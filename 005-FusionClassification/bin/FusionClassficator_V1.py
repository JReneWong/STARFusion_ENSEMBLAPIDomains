#############################################################################
#############################################################################
############# FUSION CLASSIFICATION BASED ON TRANSCRIPT DOMAINS #############
#############################################################################
#############################################################################

# AUTHOR: Jesus Rene Chion Wong Ramirez
# DATE: May 7, 2023
# VERSION: 1.0
# LABORATORY: LIIGH UNAM, Robles-Espinoza Lab
# DESCRIPTION: Classifying in-frame fusion transcripts detected by STAR-Fusion,
#              based on the conservation of transcripts domains.

#############################################################################

#Libraries

import argparse
import re

#############################################################################

#Parameters

parser = argparse.ArgumentParser()

parser.add_argument('--EnsemblDomains_InputFile', type=str, required=True)
parser.add_argument('--ConservedDomains_OutputFile', type=str, required=True)
parser.add_argument('--BothDomais_OutputFile', type=str, required=True)
parser.add_argument('--NoDomains_OutputFile', type=str, required=True)
parser.add_argument('--LeftDomains_OutputFile', type=str, required=True)
parser.add_argument('--RightDomains_OutputFile', type=str, required=True)

args = parser.parse_args()

EnsemblDomains_InputFile = args.EnsemblDomains_InputFile
ConservedDomains_OutputFile = args.ConservedDomains_OutputFile
BothDomais_OutputFile = args.BothDomais_OutputFile
NoDomains_OutputFile = args.NoDomains_OutputFile
LeftDomains_OutputFile = args.LeftDomains_OutputFile
RightDomains_OutputFile = args.RightDomains_OutputFile

#############################################################################

#New class: Domain. Saving Domain attributes: Name, start, end and description

class Domain:
  def __init__(self, name, start, end, description):
    self.name = name
    self.start = start
    self.end = end
    self.description = description

#############################################################################

#Reading in-house ENSEMBL-API output file: The file contains the fusion-transcript
#information and its domains. 
#Ex.
#CDC42BPA--ZNF670:ENST00000366767:227254064:-:ENST00000366503:247039537:-        Left    CDC42BPA        270     270
#ENST00000366767 PS50003 988     1107    PH_DOMAIN
#CDC42BPA--ZNF670:ENST00000366767:227254064:-:ENST00000366503:247039537:-        Right   ZNF670  4       4
#ENST00000366503 PS50805 4       90      KRAB
 
#Saving domain information for each transcript reported in a fusion.
#Saving fusion breakpoint in CDS coordinates.

Fusions_Dictionary = {}
FusionsBrkPoints_Dictionary = {}

with open(EnsemblDomains_InputFile, "r") as Domains_File:
  for line in Domains_File:
    line = line.split() 
    if not(":" in line[0]): #If the line is a domain info. Ex: ENST00000237654 SSF47954        19      142     Cyclin-like 
      DomainName = line[1]
      DomainStart = int(line[2])
      DomainEnd = int(line[3])
      DomainDescription = line[4]
      #Creating domain object
      DomainX = Domain(DomainName, DomainStart, DomainEnd, DomainDescription)
      
      #Adding domain to the vector of its transcript: Left or Right
      Fusions_Dictionary[LstFusionID_Detected][LstFusionPosition_Detected].append(DomainX)

    else: #If the line is a Fusion ID. Ex: CCNI--LRRC1:ENST00000237654:77048449:-:ENST00000370888:53922635:+       Left    CCNI    904     904
      FusionID = line[0] #Ex. CCNI--LRRC1:ENST00000237654:77048449:-:ENST00000370888:53922635:+
      FusionPosition = line[1] #Ex. Left
      BrkPoint_CDS = int(line[3])

      if not(FusionID in Fusions_Dictionary.keys()):
        Fusions_Dictionary[FusionID] = {}
        FusionsBrkPoints_Dictionary[FusionID] = {}
      if(FusionPosition == "Left"):
        Fusions_Dictionary[FusionID]["Left"]=[]
        FusionsBrkPoints_Dictionary[FusionID]["Left"] = BrkPoint_CDS
      else:
        Fusions_Dictionary[FusionID]["Right"]=[]
        FusionsBrkPoints_Dictionary[FusionID]["Right"] = BrkPoint_CDS

      LstFusionID_Detected = FusionID
      LstFusionPosition_Detected = FusionPosition

#############################################################################

#Opening output files

ConservedDomains_OF = open(ConservedDomains_OutputFile, 'w')
BothDomais_OF = open(BothDomais_OutputFile, 'w')
NoDomains_OF = open(NoDomains_OutputFile, 'w')
LeftDomains_OF = open(LeftDomains_OutputFile, 'w')
RightDomains_OF = open(RightDomains_OutputFile, 'w')

#############################################################################

#Getting Fusion types based on domains
#Determinating if at least one domain remains in the transcript (left or right)

for Fusion in Fusions_Dictionary.keys():
  LeftDomainDetected = False
  RightDomainDetected = False
  if("Left" in FusionsBrkPoints_Dictionary[Fusion].keys()):
    FusionLeftBrkPoint = FusionsBrkPoints_Dictionary[Fusion]["Left"]
    for Domain_N in Fusions_Dictionary[Fusion]["Left"]: #Detecting complete domains in left transcript
      if(Domain_N.end <= FusionLeftBrkPoint):
        LeftDomainDetected = True
        ConservedDomains_OF.write(Fusion+"\t"+"LEFT"+"\t"+Domain_N.name+"\n")
  if("Right" in FusionsBrkPoints_Dictionary[Fusion].keys()):  
    FusionRightBrkPoint = FusionsBrkPoints_Dictionary[Fusion]["Right"]
    for Domain_N in Fusions_Dictionary[Fusion]["Right"]: #Detecting complete domains in right transcript
      if(Domain_N.start >= FusionRightBrkPoint):
        RightDomainDetected = True
        ConservedDomains_OF.write(Fusion+"\t"+"RIGHT"+"\t"+Domain_N.name+"\n")

#Classifying Fusions

  if(LeftDomainDetected == False and RightDomainDetected == False):
    NoDomains_OF.write("Fusion:"+Fusion+"NO_DOMAINS"+"\n") 
  elif(LeftDomainDetected == True and RightDomainDetected == False):
    LeftDomains_OF.write("Fusion:"+Fusion+"LEFT_DOMAIN"+"\n")
  elif(LeftDomainDetected == False and RightDomainDetected == True):
    RightDomains_OF.write("Fusion:"+Fusion+"RIGHT_DOMAIN"+"\n")
  elif(LeftDomainDetected == True and RightDomainDetected == True):
    BothDomais_OF.write("Fusion:"+Fusion+"BOTH_DOMAINS"+"\n")

#############################################################################

#Closing output files

BothDomais_OF.close()
NoDomains_OF.close()
LeftDomains_OF.close()
RightDomains_OF.close()
ConservedDomains_OF.close()

#############################################################################
############################# END OF THE SCRIPT #############################
#############################################################################
