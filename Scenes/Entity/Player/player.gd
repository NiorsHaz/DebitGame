extends CharacterBody2D

var is_moving = false
var looking_at : float

@export var SPEED = 100

func _physics_process(_delta) -> void:
	var directionx : float
	var directiony : float
	if Input.is_anything_pressed() && Input.get_vector("left","right","up","down"):
		#print("Tokony ietsika")
		is_moving = true
		directionx = Input.get_axis("left","right")
		looking_at = directionx
		directiony = Input.get_axis("up","down")
	else:
		#print("Mijenona")
		is_moving = false
		directionx = 0.0
		directiony = 0.0
		move(directionx, directiony)
	
	if looking_at < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false

	if is_moving == true:
		$AnimatedSprite2D.play("Content-Running")
		move(directionx, directiony)
	else:
		$AnimatedSprite2D.play("Content-default")
	move_and_slide()
	
func move(directionx: float, directiony: float):
	velocity.x = directionx * SPEED
	velocity.y = directiony * SPEED
