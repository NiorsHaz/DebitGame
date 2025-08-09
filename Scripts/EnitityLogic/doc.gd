extends Node2D



@onready var label = $InteractibleLabel
var balloon_scene = preload("res://Util/Dialogues/balloon.tscn")
var can_interact:bool = false
var already_talked:bool = true

func _on_interactible_area_body_entered(body: Node2D) -> void:
	if body.name.to_lower() == "player":
		can_interact = true
		label.visible = true
		print("Player is on")


func _on_interactible_area_body_exited(body: Node2D) -> void:
	if body.name.to_lower() == "player":
		can_interact = false
		label.visible = false
		print("Player is off")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact") && can_interact == true:
		label.visible = false
		can_interact = false
		var balloon : BaseGameDialogueBalloon = balloon_scene.instantiate()
		get_tree().current_scene.add_child(balloon)
		balloon.start(load("res://Util/Dialogues/docs_dialogues.dialogue"), "start")
