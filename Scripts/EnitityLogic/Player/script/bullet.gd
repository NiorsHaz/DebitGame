extends Area2D

@onready var alienship : Node = get_node("/root/Game/alienship")
var kill : int = 0
const SPEED : int = 1500
@onready var alien_timer: Timer = $AlienTimer
var current_trail : Trail_Instance

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	make_trail()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.x * SPEED * delta
	#make_trail()


func _on_timer_timeout() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.name=="decor":
		queue_free()
	else:
		alienship.alien_killed=alienship.alien_killed+1
		body.queue_free()
		print(alienship.alien_killed)
		queue_free()

func make_trail() -> void:
	if current_trail:
		current_trail.stop()
	current_trail = Trail_Instance.create()
	current_trail.position = position
	add_child(current_trail)
