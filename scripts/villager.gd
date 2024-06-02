class_name Villager extends NPC

# Survival variables
var hunger = 100
var thirst = 100
var warmth = 100

var total_health = 100
var health = 100

var sickness = 0

# Booleans
var is_hungry = false
var is_thirsty = false
var is_cold = false

# functions
func death():
	pass

func get_sick(days) :
	var sick_chance = 400 - hunger - thirst - warmth - health
	if randi_range(0, 300) < sick_chance :
		sickness += 2
	
	sickness += days

func do_action() :
	pass

func day_pass(remove_hunger, remove_thirst, remove_warmth):

	# Update survival variables
	hunger -= remove_hunger
	thirst -= remove_thirst
	warmth -= remove_warmth
	
	# Check if villager is hungry, thirsty and cold
	if hunger < 20 and not is_hungry:
		is_hungry = true
		total_health -= 25
	else :
		is_hungry = false
		total_health += 25
	
	if thirst < 20 and not is_thirsty:
		is_thirsty = true
		total_health -= 25
	else :
		is_thirsty = false
		total_health += 25
	
	if warmth < 20  and not is_cold:
		is_cold = true
		total_health -= 25
	else :
		is_cold = false
		total_health += 25
	
	# Check if villager is sick
	if sickness > 0 :
		health -= 5
	else :
		health += 5
		get_sick(0)
	
	
	# Update villager survival variables
	if hunger > 100 :
		hunger = 100
	
	if thirst > 100 :
		thirst = 100
	
	if warmth > 100 :
		warmth = 100
	
	if total_health > 100 :
		total_health = 100
	
	if health > total_health :
		health = total_health
	
	
	# Kill villager if any survival variable are 0
	if hunger <= 0 or thirst <= 0 or warmth <= 0 or health <= 0:
		death()
		
		
	var smallest_resource
	var claimed_wood
	var claimed_food
	var claimed_water
	
	for resource: Resources in get_tree().get_nodes_in_group("resources"):
		if resource is Forest:
			claimed_wood = resource.claimed_resources
		if resource is Crops:
			claimed_food = resource.claimed_resources
		if resource is Stream:
			claimed_water = resource.claimed_resources
	
	
	if Singleton.food + claimed_food < Singleton.water + claimed_water:
		if Singleton.food + claimed_food < Singleton.wood + claimed_wood:
			#food is smallest
			smallest_resource = Crops
		else:
			#wood is smallest
			smallest_resource = Forest
	elif Singleton.water + claimed_water < Singleton.wood + claimed_wood:
		#water is smallest
		smallest_resource = Stream
	else:
		#wood is smallest
		smallest_resource = Forest
			
	for resource: Resources in get_tree().get_nodes_in_group("resources"):
		if typeof(resource) == typeof(smallest_resource): 
			if resource.resource_storage - resource.claimed_resources > 0:
				if resource.resource_storage - resource.claimed_resources < 5:
					resource.claimed_resources = resource.resource_storage
				else:
					resource.claimed_resources += 5
		
	

