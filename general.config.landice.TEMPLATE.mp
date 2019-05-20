# This file is the landice core's configuration file. It is specific to the landice
# core, and a specific machine. Each machine will configure this file
# differently, but it can be used to point on version of the testing
# infrastructure at a different version of the model.


# The namelists section describes required namelist templates that are used to
# generate specific namelist files. In the landice core, there is only a 'forward'
# mode template, which typically would point to the namelist.landice generated in
# default_inputs after a successful build of the model.
[namelists]
forward = REPODIRECTORY/default_inputs/namelist.landice


# The streams section describes required streams file templates that are used to
# generate specific streams files. In the landice core, there is only a 'forward'
# mode template, which generally points to the streams.landice generated in
# default_inputs after a successful build of the model.
[streams]
forward = REPODIRECTORY/default_inputs/streams.landice

# The executables section defines paths to required executables. These
# executables are provided for use by specific test cases.
# Full paths should be provided in order to access the executables from
# anywhere on the machine.
[executables]

model = REPODIRECTORY/landice_model
mesh_converter =  /global/homes/m/mperego/piscees/mpas/MPAS-Tools/mesh_tools/mesh_conversion_tools/MpasMeshConverter.x
cell_culler = /global/homes/m/mperego/piscees/mpas/MPAS-Tools/mesh_tools/mesh_conversion_tools/MpasCellCuller.x
metis = /opt/cray/pe/tpsl/18.06.1/GNU/7.1/haswell/bin/gpmetis
grid_to_li_grid =  /global/homes/m/mperego/piscees/mpas/MPAS-Tools/landice/mesh_tools_li/create_landice_grid_from_generic_MPAS_grid.py
periodic_hex = /global/homes/m/mperego/piscees/mpas/MPAS-Tools/mesh_tools/periodic_hex/periodic_grid

# The paths section describes paths that are used within the landice core test
# cases.
[paths]
# The mesh_database and the initial_condition_database are locations where
# meshes / initial conditions might be found on a specific machine. They can be
# the same directory, or different directory. Additionally, if they are empty
# some test cases might download data into them, which will then be reused if
# the test case is run again later.

#mesh_database = /global/homes/m/mperego/piscees/mpas/MPAS-Model/testing_and_setup/compass/mesh_database
mesh_database = NOT_CURRENTLY_USED
initial_condition_database = NOT_CURRENTLY_USED
