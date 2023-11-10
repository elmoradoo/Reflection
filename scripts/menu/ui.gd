extends Node


@onready var current_menu: MarginContainer = $MainMenu


func _ready():
	current_menu.show()

func change_menu(new_menu: MarginContainer):
	current_menu.hide()
	if new_menu:
		new_menu.show()
		current_menu = new_menu
