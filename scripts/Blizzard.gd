extends GPUParticles2D
@onready var timer = $Timer


func _enter_tree():
	Singleton.blizzard_node = self

func activate_blizzard():
	emitting = true
	timer.start()

func _on_timer_timeout():
	emitting = false
