extends Area2D

const SPEED = 500
@export var damage : int = 5
var ennemy : Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position +=transform.x * SPEED * delta


func _on_body_entered(body: Node2D) -> void:
	if "player" in body.get_groups():
		#print("player hit")
		queue_free()
		body.hurtByEnnemy(damage)
	elif "platform" in body.get_groups():
		pass
	elif "enemy" in body.get_groups():
		pass
	else:
		queue_free()


func _on_timer_timeout() -> void:
	queue_free()
