# Gromacs interactive command line on a linux OS
# Molecular Dynamics Simulation of protein
## Aim
Analyse the structural effect of missence genetic variants by comparing the wild type and the mutated protein

## Dependencies
### Install gromacs
https://www.gromacs.org/Downloads 
### Install Pymol (https://pymol.org/2/)
### Install UCSF Chimera (https://www.cgl.ucsf.edu/chimera/download.html)

### Prepare the pdb protein
Many information about the existing models may be found on Uniprot (https://www.uniprot.org/uniprotkb) 
Download the protein from pdb  if there is already a model (https://www.rcsb.org/) ; Cryo-EM, X-RAY Crystallography, NMR
Or modelize the protein using for example swiss model (https://swissmodel.expasy.org/)
Or use the alpha-fold model (https://alphafold.ebi.ac.uk/)

Some downloaded models contain missing residues particularly in the loops. They must be completed befor the simulation.
We can model the missing residues using Modeler for example (https://salilab.org/modeller/)


