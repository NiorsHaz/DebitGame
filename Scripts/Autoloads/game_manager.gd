extends Node

var start_game = false
var action_fight = false

func activate_game():
	start_game = true

func activate_fight():
	action_fight = true

func game_over():
	action_fight = false
	get_tree().change_scene_to_file("res://Scenes/UI/Game_over.tscn")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("main_menu"):
		get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")
