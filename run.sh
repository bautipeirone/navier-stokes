#!/bin/bash

#SBATCH --job-name=test
#SBATCH --mail-type=ALL
#SBATCH --mail-user=juan.b.figueredo01@gmail.com

#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1

srun bash -C ./a.out
