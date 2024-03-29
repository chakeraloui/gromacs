#!/bin/bash -e
# a creer dossier config et dossier data
# Dr Chaker Aloui, molecular dynamics simulation, gromacs 
tput bold
echo -e "Chaker ALOUI \n"
echo -e "Running gromacs MDS ...\n"

# usage : ./MDS_gromacs.sh AAAA (la proteine sous forme AAAA.pdb doit être dans le repertoire de travail).

#configPath="./configs"
#dataPath="./data" # mettre les models pdb ici
#prot2simulate="./data/model.pdb" # a changer a chaque fois
#outPutDir="simulation_date" # à modifier à chaque analyse
#mkdir $outPutDir

############TOPOLOGY##########################
##1##pdb2gmx to generate topolgy, restrain and processed pdb file used to generate a file that can be used by GROMACS

#RepairPDB:It is highly recommended to repair your structures before you do any modelling with FoldX. RepairPDB identify those residues which have bad torsion angles, or VanderWaals' clashes, or total energy, and repairs them. The minimal configuration file for RepairPDB is:

#It can be run from the command line:
#echo "Downloading $1.pdb "
#wget http://files.rcsb.org/download/$1.pdb

echo " "
FoldX --command=RepairPDB --pdb=$1.pdb # ça donne un fichier AAAA_Repair.pdb

# script a partir d un tuto internet:
# Lysozyme PDB code 1AKI http://www.mdtutorials.com/gmx/lysozyme/01_pdb2gmx.html

# telecharcher  le fichier pdb (wget https://files.rcsb.org/download/1AKI.pdb) 
# Preparer les fichiers de parametres rep configs/
#wget http://www.mdtutorials.com/gmx/lysozyme/Files/ions.mdp
#wget http://www.mdtutorials.com/gmx/lysozyme/Files/minim.mdp
#wget http://www.mdtutorials.com/gmx/lysozyme/Files/nvt.mdp
#wget http://www.mdtutorials.com/gmx/lysozyme/Files/npt.mdp
#wget http://www.mdtutorials.com/gmx/lysozyme/Files/md.mdp

# Step One: Prepare the Topology
grep -v HETATM $1\_Repair.pdb | grep -v CONECT > $1\_clean.pdb # enlever l eau, les ligands et autres

#Creation of topology file 
printf "15 0\n" | gmx pdb2gmx -f $1\_clean.pdb -o $1\_processed.gro -water spce #Choisir OPLS (15)

# Step Three: Defining the Unit Cell & Adding Solvent
gmx editconf -f $1\_processed.gro -o $1\_newbox.gro -c -d 1.0 -bt cubic # d diatance sur les bord; bt box type
gmx solvate -cp $1\_newbox.gro -cs spc216.gro -o $1\_solv.gro -p topol.top
# Step Four: Adding Ions (wget http://www.mdtutorials.com/gmx/lysozyme/Files/ions.mdp)  
gmx grompp -f ions.mdp -c $1\_solv.gro -p topol.top -o ions.tpr
printf "13 0\n" | gmx genion -s ions.tpr -o $1\_solv_ions.gro -p topol.top -pname NA -nname CL -neutral #choisir group 13 "SOL"

# Step Five: Energy Minimization (wget http://www.mdtutorials.com/gmx/lysozyme/Files/minim.mdp) 
gmx grompp -f minim.mdp -c $1\_solv_ions.gro -p topol.top -o em.tpr
gmx mdrun -v -deffnm em # attention
printf "10 0\n" | gmx energy -f em.edr -o potential.xvg
# At the prompt, type "10 0" to select Potential (10); zero (0) terminates input. 

# Step Six: Equilibration (wget http://www.mdtutorials.com/gmx/lysozyme/Files/nvt.mdp) 
gmx grompp -f nvt.mdp -c em.gro -r em.gro -p topol.top -o nvt.tpr
gmx mdrun -deffnm nvt -v
printf "16 0\n" | gmx energy -f nvt.edr -o temperature.xvg
# Type "16 0" at the prompt to select the temperature of the system and exit

# Step Seven: Equilibration 2 (wget http://www.mdtutorials.com/gmx/lysozyme/Files/npt.mdp) 
gmx grompp -f npt.mdp -c nvt.gro -r nvt.gro -t nvt.cpt -p topol.top -o npt.tpr
gmx mdrun -deffnm npt -v
printf "18 0\n" | gmx energy -f npt.edr -o pressure.xvg
# Type "18 0" at the prompt to select the pressure of the system and exit. ATTENSION AU NUM
printf "24 0\n" | gmx energy -f npt.edr -o density.xvg
# this time using energy and entering "24 0" at the prompt

# Step Eight: Production MD (wget http://www.mdtutorials.com/gmx/lysozyme/Files/md.mdp)
gmx grompp -f md.mdp -c npt.gro -t npt.cpt -p topol.top -o $1\_md_0_1.tpr
gmx mdrun -deffnm $1\_md_0_1 -nb gpu -v # utilise tous les gpu


# fin de la simulation
echo -e "Fin de la simulation \n"
#*******************************************************
#*******************************************************
#*******************************************************
# Step Nine: Analysis


#https://tutorials.gromacs.org/md-intro-tutorial.html à tester notebook jupyter
# xmgrace potential.xvg


