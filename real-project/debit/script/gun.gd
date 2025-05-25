extends Node2D

@onready var vodybe: Marker2D = $Vodybe
const  BULLET = preload("res://scene/bullet.tscn")

func _process(delta: float) -> void:
	var  mouse_position=get_global_mouse_position()
	look_at(mouse_position)
	
	rotation_degrees=wrap(rotation_degrees,0,360)
	if rotation_degrees >90 and rotation_degrees <270 :
		scale.y = -1
	else:
		scale.y =1
	
	if Input.is_action_just_pressed("fire"):
		var bullet_instance= BULLET.instantiate()
		get_tree().root.add_child(bullet_instance)
		bullet_instance.global_position= vodybe.global_position
		bullet_instance.rotation=rotation
		
