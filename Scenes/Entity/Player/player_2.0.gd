class_name Player
extends CharacterBody2D

#signal hurt
signal death

const SPEED = 100.0
const JUMP_VELOCITY = -350.0
var health = 100
var max_health = 100
@onready var animated_sprite: AnimatedSprite2D = $Sprite2D

var gun: PackedScene = preload("res://Scenes/Entity/Entity/hand_gun.tscn")

func _ready() -> void:
	get_first_gun()

func _physics_process(delta: float) -> void:
	set_collision_mask_value(3, true)
	#if GameManager.action_fight == true:
	if health<=0:
		#animated_sprite.play("death")
		$gun.visible = false
		await animated_sprite.animation_finished
		death.emit()
		
		#game.get_tree().paused=true
	if not is_on_floor():
		if Input.is_action_pressed("down"):
			set_collision_mask_value(3, false)
		velocity += get_gravity() * delta
		#if health>50:
		#print("fall")
		animated_sprite.play("fall")
		#if health<=50:
			#animated_sprite.play("fall_mid")
		
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		if Input.is_action_pressed("down"):
			set_collision_mask_value(3, false)
		else:
			velocity.y = JUMP_VELOCITY
		#if velocity.y < 0 and !is_on_floor():
			#animated_sprite.play("jump")
		#if health<=50:
			#animated_sprite.play("jump_mid")
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	

	if  get_global_mouse_position().x > global_position.x :
		animated_sprite.flip_h=false
	else:
		animated_sprite.flip_h=true
	
	
	if direction == 0 and health>50:
		animated_sprite.play("idle")
	#elif direction == 0 and health<=50:
		#animated_sprite.play("idle_mid") 
	elif direction !=0 and health>50:
		animated_sprite.play("run")
	#elif direction !=0 and health<=50:
		#animated_sprite.play("run_mid")
	
	velocity.x = direction * SPEED
		
	#else:
	#velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
 
#func hurtByEnnemy(damage : int):
	#hurt.emit(5)

func get_first_gun():
	var first = gun.instantiate()
	first.global_position = $GunHandle.position
	add_child(first)
