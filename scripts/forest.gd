class_name Forest extends Resources


var trees = 5


func chop_tree():
	trees -= 1
	generate_resource(randi_range(4,6))
