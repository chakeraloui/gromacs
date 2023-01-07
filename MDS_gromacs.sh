# script a partir d un tuto internet:
# Lysozyme PDB code 1AKI http://www.mdtutorials.com/gmx/lysozyme/01_pdb2gmx.html

# telecharcher  le fichier pdb (wget https://files.rcsb.org/download/1AKI.pdb) 

# Step One: Prepare the Topology
grep -v HOH 1AKI.pdb > 1AKI_clean.pdb # enlever l eau

#Creation of topology file 
gmx pdb2gmx -f 1AKI_clean.pdb -o 1AKI_processed.gro -water spce #Choisir OPLS (15)

# Step Three: Defining the Unit Cell & Adding Solvent
gmx editconf -f 1AKI_processed.gro -o 1AKI_newbox.gro -c -d 1.0 -bt cubic # d diatance sur les bord; bt box type
gmx solvate -cp 1AKI_newbox.gro -cs spc216.gro -o 1AKI_solv.gro -p topol.top
# Step Four: Adding Ions (wget http://www.mdtutorials.com/gmx/lysozyme/Files/ions.mdp)  
gmx grompp -f ions.mdp -c 1AKI_solv.gro -p topol.top -o ions.tpr
gmx genion -s ions.tpr -o 1AKI_solv_ions.gro -p topol.top -pname NA -nname CL -neutral #choisir group 13 "SOL"

# Step Five: Energy Minimization (wget http://www.mdtutorials.com/gmx/lysozyme/Files/minim.mdp) 
gmx grompp -f minim.mdp -c 1AKI_solv_ions.gro -p topol.top -o em.tpr
gmx mdrun -v -deffnm em
gmx energy -f em.edr -o potential.xvg
# At the prompt, type "10 0" to select Potential (10); zero (0) terminates input. 

# Step Six: Equilibration (wget http://www.mdtutorials.com/gmx/lysozyme/Files/nvt.mdp) 
gmx grompp -f nvt.mdp -c em.gro -r em.gro -p topol.top -o nvt.tpr
gmx mdrun -deffnm nvt -v
gmx energy -f nvt.edr -o temperature.xvg
# Type "16 0" at the prompt to select the temperature of the system and exit

# Step Seven: Equilibration 2 (wget http://www.mdtutorials.com/gmx/lysozyme/Files/npt.mdp) 
gmx grompp -f npt.mdp -c nvt.gro -r nvt.gro -t nvt.cpt -p topol.top -o npt.tpr
gmx mdrun -deffnm npt -v
gmx energy -f npt.edr -o pressure.xvg
# Type "18 0" at the prompt to select the pressure of the system and exit. ATTENSION AU NUM
gmx energy -f npt.edr -o density.xvg
# this time using energy and entering "24 0" at the prompt

# Step Eight: Production MD (wget http://www.mdtutorials.com/gmx/lysozyme/Files/md.mdp)
gmx grompp -f md.mdp -c npt.gro -t npt.cpt -p topol.top -o md_0_1.tpr
gmx mdrun -deffnm md_0_1 -nb gpu -v # utilise tous les gpu
# fini la simulation
#*******************************************************
#*******************************************************
#*******************************************************
# Step Nine: Analysis


#https://tutorials.gromacs.org/md-intro-tutorial.html à tester notebook jupyter



