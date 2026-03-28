extends Control

@onready var player: Player = $Scene/CharacterBody2D

func _ready() -> void:
	player.death.connect(game_over)
	GameManager.activate_fight()
	GameManager.activate_game()

func game_over():
	GameManager.game_over()
