class_name Crops extends Resources
@onready var collect_crops = $CollectCrops



var crops = 5


func _enter_tree():
	Singleton.crops = self


func harvest_crops():
	crops -= 1
	generate_resource(randi_range(4,6))
	collect_crops.play()
