extends AnimationPlayer
@onready var color_rect = $CanvasLayer/ColorRect
@onready var drought_sound = $DroughtSound


func _enter_tree():
	Singleton.drought_node = self

func activate_drought():
	play("drought")
	color_rect.visible = true
	drought_sound.play()

func _on_animation_finished(_anim_name):
	color_rect.visible = false
