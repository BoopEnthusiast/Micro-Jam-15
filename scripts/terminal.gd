extends TextEdit


var last_caret_column: int

@onready var log_node = $"../TextBackground/LogContainer/Log"


var command_list = ["help - print this", "ls - list files", "cat <name> - print file contents"]


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
		text = text.erase(0)
		text = text.replace("\n", "")
		log_node.add_log(text)
		entered_command()
		text = ""
	
	# Limit text length
	if len(text) > 16:
		text = text.erase(get_caret_column() - 1)
		set_caret_column(last_caret_column)
	
	# Store caret position
	last_caret_column = get_caret_column()


func _on_caret_changed():
	# Don't let user move caret behind spacing
	if get_caret_column() < 1:
		set_caret_column(1)
	
	# Store caret position
	last_caret_column = get_caret_column()


func entered_command() -> void:
	var command = text.to_lower().strip_edges()
	if command == "help":
		print_help()
	elif command.begins_with("chop "):
		command = command.lstrip("chop ")
	elif command.begins_with("chop"):
		log_node.log_error("chop requires more arguments")
	else:
		log_node.log_error("Could not parse command")


func print_help() -> void:
	log_node.add_bb_log("[color=#ff82bd]Available commands:")
	for command in command_list:
		log_node.add_log(command)
