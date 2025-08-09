extends Control

@onready var score : int = GameGlobal._get_score()
@onready var vague : int = GameGlobal._get_vagues()

@onready var label_score : Label = $"CanvasLayer/Panel/VBoxContainer/ScoreBoard/Alien killed"
@onready var label_vague : Label = $CanvasLayer/Panel/VBoxContainer/ScoreBoard/Vagues

func _ready() -> void:
	label_score.text = label_score.text + " " + str(score)
	label_vague.text = label_vague.text + " " + str(vague)

func _on_button_pressed() -> void:
	GameGlobal.reset_game()
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")


func _on_restart_pressed() -> void:
	GameGlobal.reset_game()
	get_tree().change_scene_to_file("res://Scenes/Gameplay/game.tscn")
