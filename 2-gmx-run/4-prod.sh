#!/bin/bash

#SBATCH -J Prod                   # name of the job
#SBATCH --reservation=workshop   # reservation
#SBATCH -p gpu                   # name of the partition: available options "standard, standard-low, gpu, hm"
#SBATCH -n 1                     # no of processes or tasks
#SBATCH --cpus-per-task=4
#SBATCH --gres=gpu:1
#SBATCH -t 00:30:00              # walltime in HH:MM:SS, Max value 72:00:00 


# load GROMACS module
module load apps/gromacs/16.6.2022/cuda/gnu
export OMPI_MCA_btl=^openib

# load GROMACS
exe="/home/apps/gromacs/gromacs-2022.2/installGPUIOMPI/bin/gmx_GPUIMPI"
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

## -----------------------------------------------------------------------


inp_dir="1-gmx-input-files"
mdp_dir="mdp_files"
prev_dir="eq2"
dir="prod" 

mdp=$(readlink -f ../$mdp_dir/production.mdp)  # mdp file

top=$(readlink -f ../$inp_dir/topol.top)			  # topology file


# NVT Equilibration run
mkdir $dir ; pushd $dir
$exe grompp -f $mdp -c ../$prev_dir/npt.gro -p $top -o prod.tpr -maxwarn 1
$exe mdrun -ntomp $SLURM_CPUS_PER_TASK -v -deffnm prod

if [[ -e "prod.gro" ]]; then
    echo "NPT Equilibration is complete!"
fi


## generate PBC corrected xtc file of protein
$exe trjconv -f prod.xtc -s prod.tpr -pbc mol -center <<EOF
Protein
Protein
EOF

$exe trjconv -f trajout.xtc -s prod.tpr -fit rot+trans <<EOF
Protein
Protein
EOF

## generate single frame gro file
$exe trjconv -f prod.xtc -s prod.tpr -o trajout.gro -dump 10 <<EOF
Protein
EOF

rm -f \#*


popd

