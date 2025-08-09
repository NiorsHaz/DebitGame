extends Node2D

var balloon_scene = preload("res://Util/Dialogues/balloon.tscn")
@onready var ship = get_node("alienship")
@export var player : Player
@onready var end_scene : PackedScene = preload("res://Scenes/UI/Game_over.tscn")
@onready var audio = $BattleCry
func _ready() -> void:
	player.death.connect(game_over)
	var balloon : BaseGameDialogueBalloon = balloon_scene.instantiate()
	add_child(balloon)
	balloon.start(load("res://Util/Dialogues/nasi_dialogues.dialogue"), "start")

func _process(_delta) -> void:
	if GameManager.action_fight == true && audio.playing == false:
		audio.play()

func game_over():
	GameGlobal.save_score()
	GameManager.game_over()
	
