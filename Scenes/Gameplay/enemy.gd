extends CharacterBody2D

signal dying

const SPEED = 20
var move=true
const bullet_enemy=preload("res://Scenes/Gameplay/bullet_enemy.tscn")

@onready var player =get_tree().get_first_node_in_group("player")

@onready var move_limite: Area2D = $move_limite
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var cible: Marker2D = $cible
@onready var hitflash: AnimationPlayer = $AnimationPlayer

var interval_shoot : float = 1.0

var is_alive: bool = true

func _ready() -> void:
	animated_sprite.material.set_shader_parameter("active", false)

func _physics_process(delta):
	if is_alive:
		if get_tree().get_first_node_in_group("player") && player.health > 0:
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
		else:
			$Timer.autostart = false
			$Timer.stop()
			self.queue_free()
			
	move_and_slide()
	
	
func _on_move_limite_body_entered(body: Node2D) -> void:
	if body == player:
		velocity.x=0
		move=false

func _on_move_limite_body_exited(body: Node2D) -> void:
	move=true
	
func enemy_fire():
	if is_alive:
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
	
func got_hit():
	hitflash.play("hit_flash")
	$Explosion.emitting = true
	is_alive = false

func _on_tree_exited() -> void:
	dying.emit()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hit_flash":
		self.queue_free()
