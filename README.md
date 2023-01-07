# Molecular Dynamics Simulation of protein using GROMACS
## Aim
Analyse the structural effect of missence genetic variants by comparing the wild type and the mutated protein

## Requirements
### Install gromacs (https://www.gromacs.org/Downloads) 
### Install Pymol (https://pymol.org/2/)
### Install UCSF Chimera (https://www.cgl.ucsf.edu/chimera/download.html)
### Install xmgrace (https://plasma-gate.weizmann.ac.il/Grace/)

### Prepare the pdb protein
Many information about the existing models may be found on Uniprot (https://www.uniprot.org/uniprotkb) 

Download the protein from pdb  if there is already a model (https://www.rcsb.org/) ; Cryo-EM, X-RAY Crystallography, NMR

Or modelize the protein using for example swiss model (https://swissmodel.expasy.org/)

Or use the alpha-fold model (https://alphafold.ebi.ac.uk/)

Some downloaded models contain missing residues particularly in the loops. They must be completed befor the simulation.

We can model the missing residues using Modeler for example (https://salilab.org/modeller/)

### Cleaning the input structure

Once you've had a look at the molecule, you are going to want to strip out all the atoms that do not belong to the protein (e.i crystal waters, ligands, etc). To delete those atoms (labelled "HETATM" in the PDB file) and eventually their connectivity, either use a plain text editor like vi, emacs (Linux/Mac), or Notepad (Windows). Do not use word processing software! Alternatively, you can use grep to delete these lines very easily:

grep -v HOH model.pdb |  > model1.pdb

grep -v HETATM model1.pdb > model2.pdb

grep -v CONECT model2.pdb > prot_clean.pdb







