#!/bin/bash -e
# Dr Chaker Aloui, analysing molecular dynamics simulation with gromacs 
tput bold
echo -e "Chaker ALOUI \n"
echo -e "Analysing gromacs MDS ...\n"

#usage ./Analyse_gromacs_MDS.sh AAAA (le nom de la prot sant .pdb AAAA.pdb)

#Step-1: Bringing Protein in the center of box 
printf "Protein\nSystem\n" |  gmx trjconv -s $1\_md_0_1.tpr -f $1\_md_0_1.xtc -o $1\_md_0_1_noPBC.xtc -pbc mol -center
# Select 1 ("Protein") as the group to be centered and 0 ("System") for output.

#Note: Please be careful about the input file names spelling.
#You need to provide two files names here, one is .tpr file while the second one is .xtc file.
#Once this command is successfully executed, now you can perform RMSD, RMSF and other analysis 
#Step-2: Calculation of RMSD 
printf "Backbone\nBackbone\n" | gmx rms -s $1\_md_0_1.tpr -f $1\_md_0_1_noPBC.xtc -o $1\_rmsd.xvg -tu ns
#Choose 4 ("Backbone") for both the least-squares fit and the group for RMSD calculation.

#If we wish to calculate RMSD relative to the crystal structure, we could issue the following:
printf "Backbone\nBackbone\n" | gmx rms -s em.tpr -f $1\_md_0_1_noPBC.xtc -o $1\_rmsd_xtal.xvg -tu ns

#Step-3: Calculation of RMSF 
printf "Backbone\n" | gmx rmsf -s $1\_md_0_1.tpr -f $1\_md_0_1_noPBC.xtc -o $1\_rmsf.xvg -res
#select Backbone 

#Step-4: Calculation of Radius of Gyration 
printf "Protein\n" | gmx gyrate -s $1\_md_0_1.tpr -f $1\_md_0_1_noPBC.xtc -o $1\_gyrate.xvg -tu ns 
#Choose group 1 (Protein) for analysis.

#Step-5: Calculation of Total Number of Hydrogen bonds 
printf "Protein\nProtein\n" | gmx hbond -s $1\_md_0_1.tpr -f $1\_md_0_1_noPBC.xtc -num $1\_hydrogen-bonds.xvg
# choose Protein, then Protein

#Step-6: Calculation of Total Solvent Accessible Surface Area 
printf "Protein\n" | gmx sasa -s $1\_md_0_1.tpr -f $1\_md_0_1_noPBC.xtc -o $1\_sasa.xvg -tu ns 
# choose Protein

#visualiser le tout
xmgrace $1\_rmsd.xvg
xmgrace $1\_rmsf.xvg #visualiser avec xmgrace
xmgrace $1\_gyrate.xvg
xmgrace $1\_hydrogen-bonds.xvg
xmgrace $1\_sasa.xvg

# les graphiques peuvent etre fait avec cet outil en ligne : https://bioinfoxpert.de/gromancer-the-md-wizard/?fbclid=IwAR0qNq9c8ITHQLHfK4s4VAREdBzeSq9xq4m_jg2fU1rkRtf719cdOk580Zg_aem_AUGjOrhKz_yJUv0piVBwUTd5NqqWrKAefW7z108YbZ3jPWkpc_9_WLuQtrxE9hne7MtlVYgZg3c3b9cgLz3dSWFK 
# Pour faire des ACP sur les trajectoires
# http://zhenglz.blogspot.com/2019/01/a-step-by-step-tutorial-to-perform-pca.html 
