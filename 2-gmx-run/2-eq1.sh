#!/bin/bash

#SBATCH -J Eq-1                   # name of the job
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

##-------------------------------------------------------------------------


inp_dir="1-gmx-input-files"
mdp_dir="mdp_files"
prev_dir="em"
dir="eq1" 

mdp=$(readlink -f ../$mdp_dir/equilibration_1-nvt.mdp)  # mdp file

top=$(readlink -f ../$inp_dir/topol.top)			  # topology file


# NPT Equilibration run
mkdir $dir ; pushd $dir
$exe grompp -f $mdp -c ../$prev_dir/em.gro -r ../$prev_dir/em.gro -p $top -o nvt.tpr -maxwarn 1
$exe mdrun -ntomp $SLURM_CPUS_PER_TASK -v -deffnm nvt

if [[ -e "nvt.gro" ]]; then
    echo "NVT Equilibration is complete!"
    exit 0
fi

popd
