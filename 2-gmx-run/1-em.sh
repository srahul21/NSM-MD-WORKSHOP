#!/bin/bash

#SBATCH -J em					 # name of the job
#SBATCH --reservation=workshop   # reservation
#SBATCH -p gpu                   # name of the partition: available options "standard, standard-low, gpu, hm"
#SBATCH -n 1                     # no of processes or tasks
#SBATCH --cpus-per-task=4
#SBATCH --gres=gpu:1
#SBATCH -t 00:10:00              # walltime in HH:MM:SS, Max value 72:00:00 


# load GROMACS module
module load apps/gromacs/16.6.2022/cuda/gnu
export OMPI_MCA_btl=^openib

# load GROMACS
exe="/home/apps/gromacs/gromacs-2022.2/installGPUIOMPI/bin/gmx_GPUIMPI"
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

##-----------------------------------------------------------------------


inp_dir="1-gmx-input-files"
mdp_dir="mdp_files"
dir="em" 


mdp=$(readlink -f ../$mdp_dir/em.mdp)    # mdp file

init_geom=$(readlink -f ../$inp_dir/*_solv.gro)    # initial simulation box
top=$(readlink -f ../$inp_dir/topol.top)			  # topology file


# Energy Minimization run using Steepest descent algo
mkdir $dir ; pushd $dir
$exe grompp -f $mdp -c $init_geom -p $top -o em.tpr -maxwarn 1
$exe mdrun -ntomp $SLURM_CPUS_PER_TASK -v -deffnm em

if [[ -e "em.gro" ]]; then
	echo "Energy minimization is complete!"
	exit 0
fi

popd
