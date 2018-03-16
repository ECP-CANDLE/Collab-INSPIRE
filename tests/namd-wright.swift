
// The output and input files of the simulation app varies from the type of
// `stage` that we are in.

app (file log) minimize(string mutation, string dir, int replica)
{
  // Can be polymorphic here
  "/lustre/atlas/proj-shared/chm126/namd.sh" "minimize" mutation dir replica log ;
}

app (file log) simulation(string op, string mutation, string dir, int replica)
{

  // Run the namd executable with core mapping options and the customised
  // input configuration file.
  //"./namd.sh" op mutation dir replica log; // stdout=@out
  "/lustre/atlas/proj-shared/chm126/namd.sh" op mutation dir replica log; // stdout=@out
}

string drug="axitinib";
string basedir=strcat("/lustre/atlas/proj-shared/chm126/esmacs/", drug);

number_of_replicas = 10; // 25;
string mutation_systems[] = ["wt", "e255k"];

foreach replica in [0:number_of_replicas-1] {
  foreach mutation in mutation_systems {

    file minlog<"%s/%s/replicas/rep%i/eq0.log"%(basedir, mutation, replica)>;
    file heatlog<"%s/%s/replicas/rep%i/eq1.log"%(basedir, mutation, replica)>;
    file eqlog<"%s/%s/replicas/rep%i/eq2.log"%(basedir, mutation, replica)>;
    file prodlog<"%s/%s/replicas/rep%i/sim1.log"%(basedir, mutation, replica)>;

    (minlog) = minimize(mutation, basedir, replica); 
    (heatlog) = simulation("heat", mutation, basedir, replica);
    (eqlog) = simulation("equilibrate", mutation, basedir, replica);
    (prodlog) = simulation("production", mutation, basedir, replica);

  }
}
