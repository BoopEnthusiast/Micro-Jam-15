class_name Crops extends Resources


var crops = 5


func harvest_crops():
	crops -= 1
	generate_resource(randi_range(4,6))
