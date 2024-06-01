extends TextEdit


func _on_text_changed():
	if not text.begins_with(" "):
		text.insert(0, " ")


func _on_caret_changed():
	get_caret_column()
