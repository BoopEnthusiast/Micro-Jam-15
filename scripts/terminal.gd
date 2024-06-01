extends TextEdit


var last_caret_column: int

@onready var log_node = $"../TextBackground/LogContainer/Log"


func _on_text_changed():
	# Add spacing
	if not text.begins_with(" "):
		text = " " + text
	
	# Remove spacing if there's no other text
	if len(text) <= 1:
		text = ""
		return
	
	# Move caret when they add text from empty
	if len(text) == 2:
		set_caret_column(2)
	
	# User says to input
	if text.contains("\n"):
		text = ""
		log_node.add_log(text)
	
	# Store caret position
	last_caret_column = get_caret_column()

func _on_caret_changed():
	# Don't let user move caret behind spacing
	if get_caret_column() < 1:
		set_caret_column(1)
	
	# Store caret position
	last_caret_column = get_caret_column()
