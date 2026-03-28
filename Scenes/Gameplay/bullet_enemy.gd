extends Area2D

const SPEED = 500
@export var damage : int = 5
var ennemy : Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ennemy = get_parent()
	ennemy.dying.connect(ownerIsDead)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position +=transform.x * SPEED * delta


func _on_body_entered(body: Node2D) -> void:
	if body.name.to_lower() == "player":
		queue_free()
		body.health=body.health-damage
		body.hurtByEnnemy(damage)
	queue_free()


func _on_timer_timeout() -> void:
	queue_free()

func ownerIsDead():
	queue_free()
