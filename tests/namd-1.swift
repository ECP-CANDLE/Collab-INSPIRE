
// The output and input files of the simulation app varies from the type of
// `stage` that we are in.

app (file coor, file vel_out, file xsc_out) minimize(string mutation)
{
  // Can be polymorphic here
  "./namd.sh" "minimize" mutation coor vel_out xsc_out ;
}

app (file coor_out, file vel_out, file xsc_out) simulation
// (file stage, file system, file vel_in, file xsc_in, file topology, file constraints)
(string op, file coor_in, file vel_in, file xsc_in)
{
  // Cd into the correct folder and copy/link all input files in there
  // How is this done?

  // Run the namd executable with core mapping options and the customised
  // input configuration file.
  "./namd.sh" op "+ppn" 15 "+pemap" "1-15" "+commap" 0 "stage"
    coor_in  vel_in  xsc_in
    coor_out vel_out xsc_out ; // stdout=@out
}

number_of_replicas = 3; // 25;
string mutation_systems[] = ["MUT1", "MUT2"];
// , "MUT3", "MUT4", "MUT5", "MUT6"];

foreach replica in [0:number_of_replicas-1] {
  foreach mutation in mutation_systems {

    file coor0<"coor-%i-%s-0.data"%(replica,mutation)>;
    file coor1<"coor-%i-%s-1.data"%(replica,mutation)>;
    file coor2<"coor-%i-%s-2.data"%(replica,mutation)>;
    file coor3<"coor-%i-%s-3.data"%(replica,mutation)>;
    file vel0<"vel-%i-%s-0.data"%(replica,mutation)>;
    file vel1<"vel-%i-%s-1.data"%(replica,mutation)>;
    file vel2<"vel-%i-%s-2.data"%(replica,mutation)>;
    file vel3<"vel-%i-%s-3.data"%(replica,mutation)>;
    file xsc0<"xsc-%i-%s-0.data"%(replica,mutation)>;
    file xsc1<"xsc-%i-%s-1.data"%(replica,mutation)>;
    file xsc2<"xsc-%i-%s-2.data"%(replica,mutation)>;
    file xsc3<"xsc-%i-%s-3.data"%(replica,mutation)>;

    (coor0, vel0, xsc0) = minimize(mutation); // arguments are empty here! is this okay? No.
    (coor1, vel1, xsc1) = simulation("heat",        coor0, vel0, xsc0);
    (coor2, vel2, xsc2) = simulation("equilibrate", coor1, vel1, xsc1);
    (coor3, vel3, xsc3) = simulation("production",  coor2, vel2, xsc2);
  }
}
