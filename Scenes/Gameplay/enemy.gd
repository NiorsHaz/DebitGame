extends CharacterBody2D

signal dying

const SPEED : int = 20
const fire_charge_duration : int = 1
var move : bool = true
var knockback_velocity: Vector2 = Vector2.ZERO
@export var knockback_force: float = 25.0
@export var knockback_recovery: float = 8.0
var charge_tween: Tween
var release_tween: Tween
const bullet_enemy=preload("res://Scenes/Gameplay/bullet_enemy.tscn")

@onready var player =get_tree().get_first_node_in_group("player")

@onready var move_limite: Area2D = $move_limite
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var cible: Marker2D = $cible
@onready var hitflash: AnimationPlayer = $AnimationPlayer
@onready var glow: Sprite2D = $MuzzleGlow

var interval_shoot : float = 1.0

var is_alive: bool = true

func _ready() -> void:
	animated_sprite.material.set_shader_parameter("active", false)
	$Timer.one_shot = true
	$Timer.wait_time = shuffle()
	$Timer.start()

func _physics_process(delta):
	if is_alive:
		if get_tree().get_first_node_in_group("player") && player.health > 0:
			var direction = global_position.direction_to(player.global_position)
			var player_in_range = move_limite.get_overlapping_bodies()
			cible.look_at(player.global_position)

			if not is_on_floor():
				velocity += get_gravity() * delta
			if move == true and is_on_floor():
				velocity = direction * SPEED

			if move == false:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("walk")
			if direction.x < 0:
				animated_sprite.flip_h = false
				glow.position.x = -abs(glow.position.x)
				glow.scale.x = -abs(glow.scale.x)
			elif direction.x > 0:
				animated_sprite.flip_h = true
				glow.position.x = abs(glow.position.x)
				glow.scale.x = abs(glow.scale.x)
		else:
			$Timer.autostart = false
			$Timer.stop()
			self.queue_free()

	# apply and decay knockback regardless of alive state
	if knockback_velocity.length() > 1.0:
		velocity += knockback_velocity
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, knockback_recovery * knockback_force * delta)

	move_and_slide()
	
func _on_move_limite_body_entered(body: Node2D) -> void:
	if body == player:
		velocity.x=0
		move=false

func _on_move_limite_body_exited(body: Node2D) -> void:
	move=true
	
func enemy_fire():
	if not is_alive:
		return

	if charge_tween and charge_tween.is_valid():
		charge_tween.kill()
	if release_tween and release_tween.is_valid():
		release_tween.kill()

	glow.scale = Vector2.ZERO
	glow.modulate.a = 0.0
	glow.visible = true

	var charge_duration = 0.6  # or fire_charge_duration, a FIXED charge-up time, not tied to the shoot interval

	charge_tween = create_tween()
	charge_tween.set_parallel(true)
	charge_tween.tween_property(glow, "scale", Vector2.ONE * 1.5, charge_duration)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	charge_tween.tween_property(glow, "modulate:a", 1.0, charge_duration * 0.6)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	await get_tree().create_timer(charge_duration).timeout

	if not is_alive:
		return

	release_tween = create_tween()
	release_tween.tween_property(glow, "modulate:a", 0.0, 0.05)
	release_tween.tween_callback(func(): glow.visible = false)

	var bullet_instance = bullet_enemy.instantiate()
	get_tree().root.add_child(bullet_instance)
	bullet_instance.global_position = cible.global_position
	bullet_instance.rotation = cible.rotation

	# now that firing is fully done, schedule the NEXT shot
	$Timer.wait_time = shuffle()
	$Timer.start()
		

func _on_timer_timeout() -> void:
	enemy_fire()
	
func shuffle():
	var rand_num = RandomNumberGenerator.new()
	return rand_num.randf_range(1.0, 1.5)
	
func got_hit(dir: Vector2 = Vector2.ZERO) -> void:
	hitflash.play("hit_flash")
	$Explosion.emitting = true
	velocity = dir * -knockback_force
	is_alive = false

func _on_tree_exited() -> void:
	dying.emit()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hit_flash":
		await get_tree().create_timer(0.2).timeout
		self.queue_free()
