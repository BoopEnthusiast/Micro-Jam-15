class_name Villager extends NPC

# Survival variables
var food = 100
var water = 100
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

func day_pass(hunger, thirst, cold):

		
	food -= hunger
	water -= thirst
	warmth -= cold
	
	if food < 20 and not is_hungry:
		is_hungry = true
		total_health -= 25
	else :
		is_hungry = false
		total_health += 25
	
	if water < 20 and not is_thirsty:
		is_thirsty = true
		total_health -= 25
	else :
		is_thirsty = false
		total_health += 25
	
	if warmth < 20  and not is_cold:
		is_cold = true
		total_health -= 25
	
	if total_health > 100 :
		total_health = 100
	
	if food <= 0 or water <= 0 or warmth <= 0 or health <= 0:
		death()
	
