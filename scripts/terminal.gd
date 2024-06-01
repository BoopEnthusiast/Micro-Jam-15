extends TextEdit


var last_caret_column: int


func _on_text_changed():
	if not text.begins_with(" "):
		text = " " + text
	
	if len(text) <= 1:
		text = ""
		return
	
	if len(text) == 2:
		set_caret_column(2)
	
	if text.contains("\n"):
		text = text.replace("\n", "")
		set_caret_column(last_caret_column)
	
	last_caret_column = get_caret_column()

func _on_caret_changed():
	if get_caret_column() < 1:
		set_caret_column(1)
	
	last_caret_column = get_caret_column()
