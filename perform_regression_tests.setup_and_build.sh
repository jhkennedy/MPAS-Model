#!/bin/bash

#source ~/edison_module.sh
#source ~/setup_mpas_environment.gnu.20180808.sh

#module load netcdf-cxx

# script to run MPAS testing infrastructure

TRUSTED_REPO=/global/homes/m/mperego/piscees/mpas/MPAS-Model-Trusted
TESTING_REPO=/global/homes/m/mperego/piscees/mpas/MPAS-Model

TRUSTED_WORKDIR=/global/homes/m/mperego/piscees/mpas/MPAS-Testing/trustbranch
TESTING_WORKDIR=/global/homes/m/mperego/piscees/mpas/MPAS-Testing/testbranch

CONFIGTEMPLATE=/global/homes/m/mperego/piscees/mpas/MPAS-Model/general.config.landice.TEMPLATE.mp
# This file should have REPODIRECTORY as a replacement string for the path to the namelist, streams, and exe

CLEANCOMMAND='make clean'
BLDCOMMAND='make gnu-nersc -j 2 DEBUG=true ALBANY=true'
#BLDCOMMAND='make gfortran -j 2'

RUNCMD='srun --time=0:15:00 --nodes=1 --qos=debug --job-name=regressionsuite '

REGRESSION_SUITE=landice/regression_suites/combined_integration_test_suite.xml


# =====================


# Remember where we are
STARTLOCATION=`pwd`

# build and setup trusted ==========================

cd $TRUSTED_REPO
echo ""
echo "     ----- STARTING TRUSTED: `pwd` -----"
echo ""

#do_trusted_build=0
#if [ $do_trusted_build == 1 ]
#then        
#   echo "     ----- Building TRUSTED -----"
#   cd $TRUSTED_REPO
#   $CLEANCOMMAND
#   $BLDCOMMAND
#fi
#
do_trusted_setup=1
if [ $do_trusted_setup == 1 ]
then        
   echo "     ----- Setting up TRUSTED -----"
   cd $TRUSTED_REPO
   echo $PWD
   cd testing_and_setup/compass/
   sed "s#REPODIRECTORY#$TRUSTED_REPO#" $CONFIGTEMPLATE  > general.config.FOR_REGRESSION_TEST.TRUSTED
   ./manage_regression_suite.py -c -t $REGRESSION_SUITE -f general.config.FOR_REGRESSION_TEST.TRUSTED --work_dir $TRUSTED_WORKDIR -m runtime_definitions/srun.xml
   ./manage_regression_suite.py -s -t $REGRESSION_SUITE -f general.config.FOR_REGRESSION_TEST.TRUSTED --work_dir $TRUSTED_WORKDIR -m runtime_definitions/srun.xml
fi


# build and setup testing ==========================
cd $TESTING_REPO
echo
echo      ----- STARTING TESTING: `pwd` -----
echo

do_testing_build=0
if [ $do_testing_build == 1 ]
then        
   echo "     ----- Building TESTING -----"
   cd $TESTING_REPO
   $CLEANCOMMAND
   $BLDCOMMAND
fi

do_testing_setup=1
if [ $do_testing_setup == 1 ]
then        
   echo "     ----- Setting up TESTING -----"
   cd $TESTING_REPO
   echo $PWD
   cd testing_and_setup/compass/
   sed "s#REPODIRECTORY#$TESTING_REPO#" $CONFIGTEMPLATE  > general.config.FOR_REGRESSION_TEST.TESTING
   ./manage_regression_suite.py -c -t $REGRESSION_SUITE -f general.config.FOR_REGRESSION_TEST.TESTING -b $TRUSTED_WORKDIR --work_dir $TESTING_WORKDIR -m runtime_definitions/srun.xml
   ./manage_regression_suite.py -s -t $REGRESSION_SUITE -f general.config.FOR_REGRESSION_TEST.TESTING -b $TRUSTED_WORKDIR --work_dir $TESTING_WORKDIR -m runtime_definitions/srun.xml
fi


# RUN BOTH - on Edison, use batch script ==========================


do_trusted_run=0
if [ $do_trusted_run == 1 ]
then        
   cd $TRUSTED_WORKDIR
   echo
   echo      ----- RUN TRUSTED: `pwd` -----
   echo
   time $RUNCMD ./standard_integration_test_suite.py
   time $RUNCMD ./ho_integration_test_suite.py
fi   


do_testing_run=0
if [ $do_testing_run == 1 ]
then        
   cd $TESTING_WORKDIR
   echo
   echo      ----- RUN TESTING: `pwd` -----
   echo
   time $RUNCMD ./standard_integration_test_suite.py
   time $RUNCMD ./ho_integration_test_suite.py
fi

cd $STARTLOCATION
