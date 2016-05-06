 
function sigmoid(x)
        return 2/(1+math.exp(-4.9*x))-1
end
 
function newInnovation()
        pool.innovation = pool.innovation + 1
        return pool.innovation
end
 
function newPool()
        local pool = {}
        pool.species = {}
        pool.generation = 0
        pool.innovation = Outputs
        pool.currentSpecies = 1
        pool.currentGenome = 1
        pool.currentFrame = 0
        pool.maxFitness = 0
       
        return pool
end
 
function newSpecies()
        local species = {}
        species.topFitness = 0
        species.staleness = 0
        species.genomes = {}
        species.averageFitness = 0
       
        return species
end
 
function newGenome()
        local genome = {}
        genome.genes = {}
        genome.fitness = 0
        genome.adjustedFitness = 0
        genome.network = {}
        genome.maxneuron = 0
        genome.globalRank = 0
        genome.mutationRates = {}
        genome.mutationRates["connections"] = MutateConnectionsChance
        genome.mutationRates["link"] = LinkMutationChance
        genome.mutationRates["bias"] = BiasMutationChance
        genome.mutationRates["node"] = NodeMutationChance
        genome.mutationRates["enable"] = EnableMutationChance
        genome.mutationRates["disable"] = DisableMutationChance
        genome.mutationRates["step"] = StepSize
       
        return genome
end
 
function copyGenome(genome)
        local genome2 = newGenome()
        for g=1,#genome.genes do
                table.insert(genome2.genes, copyGene(genome.genes[g]))
        end
        genome2.maxneuron = genome.maxneuron
        genome2.mutationRates["connections"] = genome.mutationRates["connections"]
        genome2.mutationRates["link"] = genome.mutationRates["link"]
        genome2.mutationRates["bias"] = genome.mutationRates["bias"]
        genome2.mutationRates["node"] = genome.mutationRates["node"]
        genome2.mutationRates["enable"] = genome.mutationRates["enable"]
        genome2.mutationRates["disable"] = genome.mutationRates["disable"]
       
        return genome2
end
 
function basicGenome()
        local genome = newGenome()
        local innovation = 1
 
        genome.maxneuron = Inputs
        mutate(genome)
       
        return genome
end
 
function newGene()
        local gene = {}
        gene.into = 0
        gene.out = 0
        gene.weight = 0.0
        gene.enabled = true
        gene.innovation = 0
       
        return gene
end
 
function copyGene(gene)
        local gene2 = newGene()
        gene2.into = gene.into
        gene2.out = gene.out
        gene2.weight = gene.weight
        gene2.enabled = gene.enabled
        gene2.innovation = gene.innovation
       
        return gene2
end
 
function newNeuron()
        local neuron = {}
        neuron.incoming = {}
        neuron.value = 0.0
       
        return neuron
end
 
function generateNetwork(genome)
        local network = {}
        network.neurons = {}
       
        for i=1,Inputs do
                network.neurons[i] = newNeuron()
        end
       
        for o=1,Outputs do
                network.neurons[MaxNodes+o] = newNeuron()
        end
       
        table.sort(genome.genes, function (a,b)
                return (a.out < b.out)
        end)
        for i=1,#genome.genes do
                local gene = genome.genes[i]
                if gene.enabled then
                        if network.neurons[gene.out] == nil then
                                network.neurons[gene.out] = newNeuron()
                        end
                        local neuron = network.neurons[gene.out]
                        table.insert(neuron.incoming, gene)
                        if network.neurons[gene.into] == nil then
                                network.neurons[gene.into] = newNeuron()
                        end
                end
        end
       
        genome.network = network
end
 