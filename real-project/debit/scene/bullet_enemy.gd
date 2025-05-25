extends Area2D

const SPEED = 500

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position +=transform.x * SPEED * delta


func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		queue_free()
		body.health=body.health-5
	queue_free()


func _on_timer_timeout() -> void:
	queue_free()
