#!/bin/bash
#--------------------------------------------------------------------------------------------------#
# ATS-2 Environment setups
#--------------------------------------------------------------------------------------------------#

export VENDOR_DIR=/usr/gapps/jayenne/vendors

# Sanity Check (Cray machines have very fragile module systems!)
if [[ -d $ParMETIS_ROOT_DIR ]]; then
  echo "ERROR: This script should be run from a clean environment."
  echo "       Try running 'rmdracoenv'."
  exit 1
fi

# symlinks will be generated for each machine that point to the correct
# installation directory.
if [[ `df | grep -c rz_gapps` -gt 0 ]]; then
  export siblings="rzansel"
else
  export siblings="sierra"
fi

# The following toolchains will be used when releasing code
environments="gcc831env xl20200819env"

# Extra cmake options
export CONFIG_BASE+=" -DCMAKE_VERBOSE_MAKEFILE=ON"
export JSM_JSRUN_NO_WARN_OVERSUBSCRIBE=1
export MAKE_COMMAND="lexec -q make"
export CTEST_COMMAND="lexec -q ctest"

# job launch options
#case $siblings in
#  rzansel) job_launch_options="-q pdebug" ;;
#  sierra) job_launch_options="-q pbatch" ;;
#  *) die "*FATAL ERROR* (ats2-env.sh) I only know how to set job_launch_options for rzansel and sierra." ;;
#esac
#export job_launch_options

# Special setup for ATS-2: replace the 'latest' symlink
(cd /usr/gapps/jayenne; if [[ -L draco-latest ]]; then rm draco-latest; fi; ln -s $source_prefix draco-latest)

#--------------------------------------------------------------------------------------------------#
# Specify environments (modules)
#--------------------------------------------------------------------------------------------------#

if ! [[ $ddir ]] ;then
  echo "FATAL ERROR: Expected ddir to be set in the environment. (ats2-env.sh)"
  exit 1
fi

case $ddir in

  #--------------------------------------------------------------------------------------------------#
  draco-7_7*|draco-7_8*)
    function gcc831env()
    {
      run "module purge"
      run "module use /usr/gapps/user_contrib/spack.20200402/share/spack/lmod/linux-rhel7-ppc64le/Core"
      run "module use --append /usr/gapps/jayenne/Modules"
      unset CMAKE_PREFIX_PATH
      unset CPATH
      unset LD_LIBRARY_PATH
      unset LIBRARY_PATH
      run "module load draco/gcc831-cuda-11.0.2"
      run "module list"
      export JSM_JSRUN_NO_WARN_OVERSUBSCRIBE=1
      CXX=`which g++`
      CC=`which gcc`
      FC=`which gfortran`
      unset MPI_ROOT
    }
    function xl20200819env()
    {
      run "module purge"
      run "module use /usr/gapps/user_contrib/spack.20200402/share/spack/lmod/linux-rhel7-ppc64le/Core"
      run "module use --append /usr/gapps/jayenne/Modules"
      unset CMAKE_PREFIX_PATH
      unset CPATH
      unset LD_LIBRARY_PATH
      unset LIBRARY_PATH
      run "module load draco/xl2020.08.19-cuda-11.0.2"
      run "module list"
      export JSM_JSRUN_NO_WARN_OVERSUBSCRIBE=1
      unset MPI_ROOT
    }
    ;;

  *)
    die "ats2-env.sh:: did not set any build environments, ddir = $ddir."
    ;;

  #--------------------------------------------------------------------------------------------------#
esac

#--------------------------------------------------------------------------------------------------#
# Sanity check
#--------------------------------------------------------------------------------------------------#

for env in $environments; do
  if [[ `fn_exists $env` -gt 0 ]]; then
    if [[ $verbose ]]; then echo "export -f $env"; fi
    export -f $env
  else
    die "Requested environment $env is not defined."
  fi
done


##---------------------------------------------------------------------------##
## End
##---------------------------------------------------------------------------##
