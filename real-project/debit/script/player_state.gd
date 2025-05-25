extends Node
class_name PlayerState

var player

func enter_state(player_node):
	player=player_node
	
func exit_state():
	pass
	
func handle_input(_delta):
	if Input.is_action_just_pressed("ui_accept") and player.is_on_floor():
		player.change_state("jump")
	
	elif Input.get_axis("ui_left", "ui_right"):
		player.change_state("run")
		 
