# This is a readme file to run molecular dynamics (MD) simulation in GROMACS

- Files in the directory:
-------------------------
1. PDB file --> 2jof.pdb
2. Directories:
  - 1-gmx-input-files       # contains script to generate input file 
  - mdp_files               # GROMACS mdp file
  - 2-gmx-run		           # contains scripts to run MD
3. Readme.md file

- Instructions:
--------------------------

1. check pdb file: use VMD to visualize
2. cd 1-gmx-input-files      		# enter the directory
3. ./generate-inp-files.sh 		  # execute the script

 This will generate the list of files:
  - 2jof_box.gro
  - 2jof_refined.gro
  - 2jof_solv.gro       # final simulation box    
  - posre.itp				    # protein position restraint file
  - topol.top				    # topology file of the system

4. cd ..				         
3. cd 2-gmx-run			   	# enter next directory
This contains four files: <br>
Execute the follwing scripts one by one. <br>
 - sbatch 1-em.sh         # Energy minimization
 - sbatch 2-eq1.sh				# Equilibration first stage
 - sbatch 3-eq2.sh				# Equilibration second stage
 - sbatch 4-prod.sh				# Production run


- Running GROMACS tutorial on local mechine:
-----------------------------
- delete all **SBATCH** commands
- delete **module load** command
- delete the **export** command
- change this path **/home/apps/gromacs/gromacs-2022.2/installGPUIOMPI/bin/gmx_GPUIMPI** to your GROMACS executable path

