# GeneticAlgorithm
<p>Genetic Algorithm Framework</p>
<p>This is a simple framework to use generic algoritm search for an optimal solution to an arbitrary problem</p> 
<p>The framework is built on three simple structs: Individual: that keeps the genome, or parameter values, of a particular setting, Population that comprise of all the current individuals and also contain the methods of selection, and the last struct Parameter that contains the information of the min and max values that a parameter can attain as well as the resolution at with the parameter is resolved in, in terms of bits. </p>
<p>To start the search for an optimum one needs to initialize a population using the Population initializer. The initializer need the number of individuals of the population, an array of Parameter(s) that defines the model, a probability for cross-over, a probability for mutation and finally a GeneticAlgoritmDelegate. The GeneticAlgoritmDelegate need to include a method called costFunction that for a given array of parameter values (in Double) returns a cost value that can determine the probabilities for cross-overs. After initialized, one needs to iterate towards an optimal solution using the mutating function "advanceGeneration" on the population.</p> 
<p>Progress of the iterations can be monitored through inspecting the vars best of type Individual and bestValues that is an array of values of the Parameters of the model. </p>
