########Commands to Analyze the Molecular Dynamics Simulation Data########
#Step-1: Bringing Protein in the center of box 
gmx trjconv -s md_0_1.tpr -f md_0_1.xtc -o md_0_1_noPBC.xtc -pbc mol -center
# Select 1 ("Protein") as the group to be centered and 0 ("System") for output.

#Note: Please be careful about the input file names spelling.
#You need to provide two files names here, one is .tpr file while the second one is .xtc file.
#Once this command is successfully executed, now you can perform RMSD, RMSF and other analysis 
#Step-2: Calculation of RMSD 
gmx rms -s md_0_1.tpr -f md_0_1_noPBC.xtc -o rmsd.xvg -tu ns
#Choose 4 ("Backbone") for both the least-squares fit and the group for RMSD calculation.

#If we wish to calculate RMSD relative to the crystal structure, we could issue the following:
gmx rms -s em.tpr -f md_0_1_noPBC.xtc -o rmsd_xtal.xvg -tu ns

#Step-3: Calculation of RMSF 
gmx rmsf -s md_0_1.tpr -f md_0_1_noPBC.xtc -o rmsf.xvg -res
#select Backbone 

#Step-4: Calculation of Radius of Gyration 
gmx gyrate -s md_0_1.tpr -f md_0_1_noPBC.xtc -o gyrate.xvg
#Choose group 1 (Protein) for analysis.

#Step-5: Calculation of Total Number of Hydrogen bonds 
gmx hbond -s md_0_1.tpr -f md_0_1_noPBC.xtc -num hydrogen-bonds.xvg
# choose Protein, then Protein

#Step-6: Calculation of Total Solvent Accessible Surface Area 
gmx sasa -s md_0_1.tpr -f md_0_1_noPBC.xtc -o area.xvg -tu ns 
# choose Protein

#visualiser le tout
xmgrace rmsd.xvg
xmgrace rmsf.xvg #visualiser avec xmgrace
xmgrace gyrate.xvg
xmgrace hydrogen-bonds.xvg
xmgrace area.xvg


# Pour faire des ACP sur les trajectoires
# http://zhenglz.blogspot.com/2019/01/a-step-by-step-tutorial-to-perform-pca.html 
