extends GPUParticles2D
@onready var timer = $Timer
@onready var blizzard_sound = $BlizzardSound


func _enter_tree():
	Singleton.blizzard_node = self

func activate_blizzard():
	emitting = true
	timer.start()

func _on_timer_timeout():
	emitting = false
