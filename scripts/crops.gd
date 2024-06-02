class_name Crops extends Resources
@onready var collect_crops = $CollectCrops



var crops = 5


func _enter_tree():
	Singleton.crops = self

func grow_crops():
	crops += 1

func harvest_crops():
	crops -= 1
	generate_resource(randi_range(4,6))
	collect_crops.play()
