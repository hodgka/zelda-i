

function newgene()
	local gene = {}
	gene.link = {}
	gene.innovation_num = 0.0
	gene.mut_num = 0.0
	gene.enabled = true
	gene.frozen = false

	return gene
end

function newgenome(genomeid)
	local genome = {}
	genome.id = genomeid
	genome.traits = {}
	genome.nodes = {}
	genome.genes = {}
	genome.phenotype = {}	

	return genome
end


function newlink(linkid)
	local link = {}
	link.weight = 0.0

	--stores the ids of the input and output nodes
	link.in_node_id = 0
	link.out_node_id = 0

	link.isrecurrent = false
	link.time_delay = false
	--stores the id of the trait that this link deals with
	link.trait_id = linkid
	link.added_weight = 0.0
	link.params = {}	

	return link
end

function newtrait(traitid)
	local trait = {}
	trait.id = traitid
	trait.parameters = {}

	return trait
end

--number of changes to the network
function newinnovation(link,)
	local innovation = {}
	innovation.input_node_id = link.in_node_id
	innovation.output_node_id = link.output_node_id
	innovation.innovation_num1 = 0
	innovation.innovation_num2 = 0
	innovation.new_weight = 0
	innovation.new_trait_id = 0
	innovation.new_node_id = 0
	innovation.old_innovation_num =0
	innovation.recurrent_flag = false
end


function newnetwork(networkid)
	local network = {}
	network.num_nodes = 0
	network.num_links = 0
	network.node_list = {}
	network.genotype = {}
	network.input_nodes = {}
	network.output_nodes = {}
	network.id = networkid
	network.maxweight = 0
	network.adaptable = true

	return network
end


function newnode(nodeid)
	local node = {}
	node.activation_count = 0
	node.last_act = 0
	node.last_act2 = 0
	node.trait = {}
	node.override = false
	node.override_val = 0
	node.trait_id = nodeid
	node.frozen = false
	node.active_sum = 0.0
	node.activation = 0.0
	node.active_flag = true
	node.output = 0.0
	--list of weighted inputs from other nodes
	node.incoming = {}
	--list of links carrying this node's output
	node.outgoing = {}
	node.id = nodeid
	node.node_label = {}

	return node
end

function neworganism()
	local organism = {}
	organism.fitness = 0.0
	organism.orig_fitness = 0.0
	organism.error = 0.0

	--boolean that will be used depending on task
	organism.winner = false

	--net,genome,and species the org belongs to
	organism.network = {}
	organism.genome = {}
	organism.species = {}

	--number of expected offspring
	organism.exp_offspring = 0
	organism.generation = 0
	organism.eliminate = false
	organism.champion = false

	--number of offspring reserved for the best organism
	organism.num_top_champ_off = 0
	--marks if this organism is the best organism or the offspring
	organism.popul_champ = false
	organism.popul_champ_off = false

	organism.time_alive = 0.0
	organism.mut_struct_baby = false

	organism.modified = false


	return organism
end

function newpopulation()
	local population = {}
	population.organisms = {}
	population.species = {}
	population.innovations = {}
	population.cur_node_id = 0
	population.cur_innovation_num = 0
	population.last_species = 0

	population.mean_fitness = 0
	population.std_dev = 0
	population.var = 0

	population.winner_generation = 0
	population.max_fitness = 0
	population.max_last_changed = 0

	return population
end

function newspecies()
	local species = {}
	species.id = 0
	species.age = 0 
	species.ave_fitness = 0
	species.max_fitness = 0
	species.max_fitness_ever = 0
	species.exp_offspring = 0
	species.novel = false
	species.checked = false
	species.obliterate = false
	species.organisms = {}
	species.age_of_last_improvment = 0
	species.ave_est = 0.0

	return species
end


