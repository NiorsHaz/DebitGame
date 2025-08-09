extends CharacterBody2D
class_name Ennemy

signal dying

const SPEED = 20
var move=true
const bullet_enemy=preload("res://Scenes/Gameplay/bullet_enemy.tscn")

@onready var player =get_node("/root/Game/player")
@onready var move_limite: Area2D = $move_limite
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var cible: Marker2D = $cible

var interval_shoot : float = 1.0



func _physics_process(delta: float):
	if get_node("/root/Game/player") && player.health > 0:
		var direction = global_position.direction_to(player.global_position)
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
	else:
		$Timer.autostart = false
		$Timer.stop()
		self.queue_free()
		
	move_and_slide()
	
	
func _on_move_limite_body_entered(body: Node2D) -> void:
	if body == player:
		velocity.x=0
		move=false

func _on_move_limite_body_exited(_body) -> void:
	move=true
	
func enemy_fire():
	var bullet_instance=bullet_enemy.instantiate()
	add_child(bullet_instance)
	bullet_instance.global_position=cible.global_position
	bullet_instance.rotation=cible.rotation
	$Timer.wait_time = shuffle()

func _on_timer_timeout() -> void:
	enemy_fire()
	
func shuffle():
	var rand_num = RandomNumberGenerator.new()
	return rand_num.randf_range(1.0, 1.5)
	

func _on_tree_exited() -> void:
	dying.emit()
