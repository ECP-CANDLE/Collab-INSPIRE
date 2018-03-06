
// The output and input files of the simulation app varies from the type of
// `stage` that we are in.

app (file coor, file vel, file xsc) simulation (file stage, file system, file vel, file xsc, file topology, file constraints)
{
  // Cd into the correct folder and copy/link all input files in there
  // How is this done?

  // Run the namd executable with core mapping options and the customised
  // input configuration file.
  "./namd.sh" "+ppn" 15 "+pemap" "1-15" "+commap" 0 stage ; // stdout=@out
}

number_of_replicas = 25;
string mutation_systems[] = ["MUT1", "MUT2", "MUT3", "MUT4", "MUT5", "MUT6"];


foreach replica in [0:number_of_replicas-1] {
  foreach mutation in mutation_systems {

    (coor, vel, xsc) = simulation("minimize", mutation); // arguments are empty here! is this okay?
    (coor, vel, xsc) = simulation("heat", coor, top, vel, xsc);
    (coor, vel, xsc) = simulation("equilibrate", coor, top, vel, xsc);
    simulation("production", coor, top, vel, xsc);

  }
}
