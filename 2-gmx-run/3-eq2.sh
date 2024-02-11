#!/bin/bash

#SBATCH -J Eq-2                   # name of the job
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

## -----------------------------------------------------------------------


inp_dir="1-gmx-input-files"
mdp_dir="mdp_files"
prev_dir="eq1"
dir="eq2" 

mdp=$(readlink -f ../$mdp_dir/equilibration_2-npt.mdp)  # mdp file

top=$(readlink -f ../$inp_dir/topol.top)			  # topology file


# NVT Equilibration run
mkdir $dir ; pushd $dir
$exe grompp -f $mdp -c ../$prev_dir/nvt.gro -r ../$prev_dir/nvt.gro -p $top -o npt.tpr -maxwarn 1
$exe mdrun -ntomp $SLURM_CPUS_PER_TASK -v -deffnm npt

if [[ -e "npt.gro" ]]; then
    echo "NPT Equilibration is complete!"
    exit 0
fi

popd
