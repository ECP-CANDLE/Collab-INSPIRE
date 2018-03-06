
# This is how we load NAMD on Titan. These instruction are all coming from
# the Titan website. This might have to go in the bash submission script.

module load namd/2.12
export MPICH_PTL_SEND_CREDITS=-1
export MPICH_MAX_SHORT_MSG_SIZE=8000
export MPICH_PTL_UNEX_EVENTS=80000
export MPICH_UNEX_BUFFER_SIZE=100M

# In theory this is the only application that we need for now. Maybe
# one ore more analysis steps will follow. The Simulation application
# is basically a namd execution with a customised configuration file
# as input.

# The output and input files of the simulation app varies from the type of
# `stage` that we are in.

app (file coor, file vel, file xsc) simulation (file stage, file system, file vel, file xsc, file topology, file constraints)
{
  # Cd into the correct folder and copy/link all input files in there
  # How is this done?

  # Run the namd executable with core mapping options and the customised
  # input configuration file.
  bash namd2 +ppn 15 +pemap 1-15 +commap 0 stage.conf stdout=@out
}

number_of_replicas = 25
mutation_systems = ['MUT1', 'MUT2', 'MUT3', 'MUT4', 'MUT5', 'MUT6']


foreach replica in [0:number_of_replicas-1] {
  foreach mutation in mutation_systems {

    (coor, vel, xsc) = simulation('minimize', mutation) # arguments are empty here! is this okay?
    (coor, vel, xsc) = simulation('heat', coor, top, vel, xsc)
    (coor, vel, xsc) = simulation('equilibrate', coor, top, vel, xsc)
    simulation('production', coor, top, vel, xsc)

  }
}
