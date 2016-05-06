--[[
-Inputs are what the neural network sees
-Outputs are what buttons will be pressed
]]--
function copyGene(gene) --Copy a gene
	local gene_copy = newGene()
	gene_copy.into = gene.into
	gene_copy.out = gene.out
	gene_copy.weight = gene.weight
	gene_copy.enabled = gene.enabled
	gene_copy.innovation = gene.innovation   
	return gene_copy
end

function randomNeuron(genes, anti) --Select a random neuron
    local neuron_list = {}
    if not anti then
        for l=1,Inputs do
            neuron_list[l] = true
        end
	end
	for j=1,Outputs do
        neuron_list[MaxNodes+j] = true
	end
	for i=1,#genes do
		if (not anti) or genes[i].into > Inputs then
			neuron_list[genes[i].into] = true
		end
		if (not anti) or genes[i].out > Inputs then
			neuron_list[genes[i].out] = true
		end
    end 
	local count = 0
	for k,v in pairs(neuron_list) do
		count = count + 1
	end
	local rand = math.random(1, count)
	for k,v in pairs(neuron_list) do
		rand = rand-1
		if rand == 0 then
			return k
		end
	end   
	return 0
end

function pointMutate(genome)--Mutate a gene
  local step = genome.mutationRates["step"]
  for j=1,#genome.genes do
	local gene = genome.genes[j]
        if math.random() < PerturbChance then
            gene.weight = gene.weight + step *(math.random()*2-1)
        else
            gene.weight = math.random()*4-2
        end
    end
end

function containsLink(geneslist, link)--Check to see if the genes contains a link
	for s=1,#geneslist do
		local gene =  geneslist[s]
		if gene.into == link.into then
			if gene.out == link.out then
				return true
			end
		end
	end
end
 
function linkMutate(genome,bias)--Mutate a link
    local neurona = randomNeuron(genome.genes, false)
    local neuronb= randomNeuron(genome.genes, true)     
    local link = newgene()
    if neurona <= Inputs and neuronb <= Inputs then
        return
    end
    if neuronb <= Inputs then
        local temp = neurona
        neurona = neuronb
        neuronc =temp
    end
    link.out = neuronb
    if bias then
        link.into = Inputs
    end
    if  containsLink(genome.genes, link) then
        return
    end
	link.innovation = newInnovation()
    link.weight =math.random()*4-2
	table.insert(genome.genes, link)
end
 
function nodeMutate(genome)--Mutate a node
    if #genome.genes == 0 then
            return
    end
    genome.maxneuron = genome.maxneuron + 1
    local genea = genome.genes[math.random(1,#genome.genes)]
    if not genea.enabled then
            return
    end
    genea.enabled = false
    local geneb = copyGene(gene)
    geneb.out = genome.maxNeuron
    geneb.weight = 1.0
    geneb.innovation = newInnovation()
    geneb.enabled = true
	table.insert(genome.genes, geneb)
    local genec = copyGene(gene)
    genec.into = genome.maxNeuron
    genec.innovation = newInnovation()
    genec.enabled = true
    table.insert(genome.genes, genec)
end
 
function onOffMutate(genome, enable) --Toggle Mutation
	local options = {}
	for k,gene in pairs(genome.genes) do
		if gene.enabled == not enable then
			table.insert(options, gene)
		end
	end
	if #options== 0  then
		return
	end   
	local gene = options[math.random(1,#options)]
	gene.enabled = not gene.enabled
end
 
function mutate(genome) -- Mutate everything
    for mutation,rate in pairs(genome.mutationRates) do
		if math.random(1,2) == 1 then
            genome.mutationRates[mutation] = 0.95*rate
        else
            genome.mutationRates[mutation] = 1.05263*rate
        end
    end 
	if math.random() < genome.mutationRates["connections"] then
		pointMutate(genome)
	end      
    local mut = genome.mutationRates["link"]
    while mut > 0 do
		if math.random() < mut then
            linkMutate(genome, false)
        end
		mut = mut - 1
    end
	mut = genome.mutationRates["bias"]
    while mut > 0 do
        if math.random() < mut then
            linkMutate(genome, true)
        end
        mut = mut - 1
    end   
    mut = genome.mutationRates["node"]
    while mut > 0 do
		if math.random() < mut then
            nodeMutate(genome)
        end
        mut =  mut - 1
    end      
    mut = genome.mutationRates["enable"]
    while  mut > 0 do
		if math.random() < mut then
            onOffMutate(genome, true)
        end
        mut =  mut - 1
    end
    mut = genome.mutationRates["disable"]
    while mut > 0 do
        if math.random() < mut then
            onOffMutate(genome, false)
        end
        mut =  mut - 1
    end
end