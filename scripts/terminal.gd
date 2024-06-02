extends TextEdit


# Constants
const GHOST_DIRECTORY = "ghosts"
const VILLAGER_DIRECTORY = "villagers"
const GHOST_FILE_EXTENSION = ".gs"
const VILLAGER_FILE_EXTENSION = ".vl"

## Variables
# Caret variables
var last_caret_column: int

# Command variables
var command_list = ["help - print this", "ls - list files and directories", "pwd - print current directory", "cd <dir name> - change directory", "cat <file name> - print file contents"]
var current_directory: String = ""

@onready var log_node = $"../TextBackground/LogContainer/Log"

func _ready():
	grab_focus()


func _unhandled_input(event):
	if has_selection():
		select(0, clamp(get_selection_from_column(), 1, 17,), 0, get_selection_to_column())


func _on_text_changed():
	# Add spacing
	if not text.begins_with(" "):
		text = " " + text
	
	# Remove spacing if there's no other text
	if len(text) <= 1:
		text = " "
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
	while len(text) > 16:
		text = text.erase(get_caret_column() - 1)
		set_caret_column(last_caret_column)
	
	# Store caret position
	last_caret_column = get_caret_column()


func _on_caret_changed():
	# Don't let user move caret behind spacing
	if get_caret_column() < 1:
		set_caret_column(1)
	
	if has_selection():
		select(0, clamp(get_selection_from_column(), 1, 17,), 0, get_selection_to_column())
	
	# Store caret position
	last_caret_column = get_caret_column()


func entered_command() -> void:
	var command = text.to_lower().strip_edges()
	if command == "help":
		print_help()
	
	if command == "ls":
		if current_directory == GHOST_DIRECTORY:
			for ghost in Singleton.ghosts:
				log_node.add_log(ghost.npc_name + GHOST_FILE_EXTENSION)
		elif current_directory == VILLAGER_DIRECTORY:
			for villager in Singleton.villagers:
				log_node.add_log(villager.npc_name + VILLAGER_FILE_EXTENSION)
		else:
			log_node.add_log(GHOST_DIRECTORY)
			log_node.add_log(VILLAGER_DIRECTORY)
	
	elif command == "pwd":
		log_node.add_log("/" + current_directory)
	
	elif command.begins_with("cd "):
		command = command.lstrip("cd ")
		if len(command) == 0:
			log_node.log_error("cd requires name of directory. list directories and files with ls, use .. to go down a directory")
		else:
			if command == GHOST_DIRECTORY or command == "/" + GHOST_DIRECTORY:
				current_directory = GHOST_DIRECTORY
			elif command == VILLAGER_DIRECTORY or command == "/" + VILLAGER_DIRECTORY:
				current_directory = VILLAGER_DIRECTORY
			elif command == ".." or command == "/":
				current_directory = ""
			else:
				log_node.log_error("did not recognize directory. list directories and files with ls, use .. to go down a directory")
	
	elif command.begins_with("cd"):
		log_node.log_error("cd requires name of directory. list directories and files with ls, use .. to go down a directory")
	
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
