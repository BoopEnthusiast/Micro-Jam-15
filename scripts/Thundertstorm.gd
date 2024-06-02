extends GPUParticles2D
@onready var timer = $Timer
@onready var thunder = $Thunder
@onready var color_rect = $CanvasLayer/ColorRect


func _enter_tree():
	Singleton.thunderstorm_node = self

func activate_thunderstorm():
	emitting = true
	timer.start()
	thunder.play("thunderstorm")
	color_rect.visible = true

func _on_timer_timeout():
	emitting = false

func _on_thunder_animation_finished(anim_name):
	color_rect.visible = false
