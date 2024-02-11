#!/bin/bash

# load GROMACS module
module load apps/gromacs/16.6.2022/cuda/gnu
export OMPI_MCA_btl=^openib

# load GROMACS
exe="/home/apps/gromacs/gromacs-2022.2/installGPUIOMPI/bin/gmx_GPUIMPI"

## ------------------------------------


pdb=$(basename $(ls ../*.pdb))
pdb=$(echo "$pdb" | cut -d "." -f 1)

# bash variables
inp_pdb=$(readlink -f ../${pdb}.pdb)
refine_gro="${pdb}_refined.gro"
init_box="${pdb}_box.gro"
solv_box="${pdb}_solv.gro"
top="topol.top"


# topol.top posre.itp
# AMBER99SB-ILDN protein, nucleic AMBER94 (Lindorff-Larsen et al., Proteins 78, 1950-58, 2010)
$exe pdb2gmx -f $inp_pdb -water tip3p -ignh -o $refine_gro <<EOF
6
EOF


sleep 2
# configure the initial box, protein at the centre of the box, 1 nm distance from edge of 
# the simulation box
$exe editconf -f $refine_gro -c -d 1.0 -bt cubic -o $init_box

sleep 2
# solvate the box with water
$exe solvate -cp $init_box -cs spc216.gro -o $solv_box -p $top

rm -f \#*

