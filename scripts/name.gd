class_name NameLabel extends Label


func _on_npc_ready_done():
	text = get_parent().npc_name


func _on_mouse_entered():
	visible = true


func _on_mouse_exited():
	visible = false
