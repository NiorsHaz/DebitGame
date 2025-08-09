class_name Player
extends CharacterBody2D

signal hurt
signal death

@onready var alienship : Node = get_node("/root/Game/alienship")
const SPEED = 200.0
const JUMP_VELOCITY = -400.0
var health = 100
var max_health = 100
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	if GameManager.action_fight == true:
		if health<=0:
			animated_sprite.play("death")
			$gun.visible = false
			#save_score(alienship.alien_killed,13)
			await animated_sprite.animation_finished
			death.emit()
			return 
			#game.get_tree().paused=true
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
		var direction := Input.get_axis("left", "right")
		

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
 
func hurtByEnnemy(_damage):
	hurt.emit(5)
