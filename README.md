# STARFusion_ENSEMBLAPIDomains
In-frame fusion transcripts detection and classififcation based on their domains

This pipeline contains 5 modules:
1. Detection of fusion transcripts using STAR-Fusion [1].
2. Extracting in-frame putative fusion-transcripts.
3. Sorting information from each transcript. 
4. Use the ENSEMBL Perl API [2] to identify the domains for each transcript detected in the fusions.
5. Classification of fusion transcripts based on the conservation of domaians in each transcript, considering the breaking point.

FOLDER STRUCTURE

Each module (folder) contains three sub-folders:
  -bin: Scripts used in the module.
  -data: Input files. The files available files in the repository are toy-files for representation. User can link each /results sub-folder from the previous module to the /data sub-folder from the current module through symbolic links ('ln' command in unix/bash).  
  -results:

References: 
1. Accuracy assessment of fusion transcript detection via read-mapping and de novo fusion transcript assembly-based methods. Haas, Brian J.; Dobin, Alexander; Li, Bo; Stransky, Nicolas; Pochet, Nathalie; Regev, Aviv; Genome Biology; 2019 https://genomebiology.biomedcentral.com/articles/10.1186/s13059-019-1842-9
2. Fiona Cunningham , James E. Allen, Jamie Allen, Jorge Alvarez-Jarreta, M. Ridwan Amode, Irina M. Armean , Olanrewaju Austine-Orimoloye, Andrey G. Azov, If Barnes, Ruth Bennett, Andrew Berry, Jyothish Bhai, Alexandra Bignell, Konstantinos Billis , Sanjay Boddu, Lucy Brooks, Mehrnaz Charkhchi, Carla Cummins , Luca Da Rin Fioretto, Claire Davidson, Kamalkumar Dodiya, Sarah Donaldson, Bilal El Houdaigui, Tamara El Naboulsi, Reham Fatima, Carlos Garcia Giron , Thiago Genez, Jose Gonzalez Martinez, Cristina Guijarro-Clarke, Arthur Gymer, Matthew Hardy, Zoe Hollis, Thibaut Hourlier , Toby Hunt, Thomas Juettemann , Vinay Kaikala, Mike Kay, Ilias Lavidas, Tuan Le, Diana Lemos, José Carlos Marugán, Shamika Mohanan, Aleena Mushtaq, Marc Naven, Denye N. Ogeh, Anne Parker, Andrew Parton, Malcolm Perry, Ivana Piliˇzota, Irina Prosovetskaia, Manoj Pandian Sakthivel, Ahamed Imran Abdul Salam, Bianca M. Schmitt, Helen Schuilenburg, Dan Sheppard, José G. Pérez-Silva, William Stark, Emily Steed, Kyösti Sutinen, Ranjit Sukumaran, Dulika Sumathipala, Marie-Marthe Suner, Michal Szpak, Anja Thormann, Francesca Floriana Tricomi, David Urbina-G ́omez, Andres Veidenberg, Thomas A. Walsh, Brandon Walts, Natalie Willhoft, Andrea Winterbottom, Elizabeth Wass, Marc Chakiachvili, Bethany Flint, Adam Frankish , Stefano Giorgetti, Leanne Haggerty, Sarah E. Hunt , Garth R. IIsley, Jane E. Loveland , Fergal J. Martin , Benjamin Moore, Jonathan M. Mudge, Matthieu Muffato, Emily Perry , Magali Ruffier , John Tate, David Thybert, Stephen J. Trevanion, Sarah Dyer, Peter W. Harrison , Kevin L. Howe , Andrew D. Yates , Daniel R. Zerbino and Paul Flicek. Ensembl 2022. Nucleic Acids Res. 2022, vol. 50(1):D988-D995 PubMed PMID: 34791404. doi:10.1093/nar/gkab1049
