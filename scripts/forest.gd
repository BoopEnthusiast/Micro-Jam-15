class_name Forest extends Resources


var trees = 5


func chop_tree():
	trees -= 1
	generate_resource(5)
