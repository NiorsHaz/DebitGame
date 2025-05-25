extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -400.0
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var health=100
@onready var texture_progress: TextureProgressBar = $TextureProgressBar
@onready var health_bar: AnimatedSprite2D = $TextureProgressBar/healthBar
@onready var game: Node2D = $".."


func _physics_process(delta: float) -> void:
	
	if health>50:
		health_bar.play("full")
	if health<=50:
		health_bar.play("mid")
	if health<=0:
		health_bar.play("death")
		animated_sprite.play("death")
		game.get_tree().paused=true
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		if health>50:
			animated_sprite.play("fall")
		if health<=50:
			animated_sprite.play("fall_mid")
		
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		if health>50:
			animated_sprite.play("jump")
		if health<=50:
			animated_sprite.play("jump_mid")
		velocity.y = JUMP_VELOCITY
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	

	if  get_global_mouse_position().x > global_position.x :
		animated_sprite.flip_h=false
	else:
		animated_sprite.flip_h=true
	
	
	if direction == 0 and health>50:
		animated_sprite.play("idle")
	elif direction == 0 and health<=50:
		animated_sprite.play("idle_mid") 
	elif direction !=0 and health>50:
		animated_sprite.play("run")
	elif direction !=0 and health<=50:
		animated_sprite.play("run_mid")
	
	if direction:
		velocity.x = direction * SPEED
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
 
