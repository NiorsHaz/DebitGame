extends CharacterBody2D

const SPEED = 20
var move=true
const bullet_enemy=preload("res://scene/bullet_enemy.tscn")

@onready var player =get_node("/root/Game/player")
@onready var bullet =get_node("/root/Game/bullet")
@onready var move_limite: Area2D = $move_limite
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var cible: Marker2D = $cible



func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	var player_in_range = move_limite.get_overlapping_bodies()
	cible.look_at(player.global_position)
		
	if not is_on_floor():
		velocity += get_gravity() * delta
	if move == true and is_on_floor():
		velocity= direction * SPEED
		
	if move == false:
		animated_sprite.play("idle")
	else:
		animated_sprite.play("walk") 

	if direction.x<0:
		animated_sprite.flip_h=false
	elif direction.x>0:
		animated_sprite.flip_h=true
	
	move_and_slide()
	
	
func _on_move_limite_body_entered(body: Node2D) -> void:
	if body == player:
		velocity.x=0
		move=false

func _on_move_limite_body_exited(body: Node2D) -> void:
	move=true
	
func enemy_fire():
	var bullet_instance=bullet_enemy.instantiate()
	get_tree().root.add_child(bullet_instance)
	bullet_instance.global_position=cible.global_position
	bullet_instance.rotation=cible.rotation

func _on_timer_timeout() -> void:
	enemy_fire()
