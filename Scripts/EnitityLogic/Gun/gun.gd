class_name Gun
extends Node2D

signal gain_point

@onready var vodybe: Marker2D = $Vodybe
#@onready var shooterInterval = $ShootInterval
@onready var reload_audio = $ReloadGun
@onready var player = get_parent()
const  BULLET = preload("res://Scenes/Gameplay/bullet.tscn")

var can_shoot: bool = true
var reloading: bool = false

@export var fire_rate: float
@export var fire_damage: int

func _ready() -> void:
	player.death.connect(cannotShoot)
	reload_audio.autoplay = false

func _process(delta: float) -> void:
	#if GameManager.action_fight == true:
		var  mouse_position = get_global_mouse_position()
		look_at(mouse_position)
		
		rotation_degrees=wrap(rotation_degrees,0,360)
		if rotation_degrees >90 and rotation_degrees <270 :
			scale.y = -1
		else:
			scale.y =1
		
		if Input.is_action_pressed("fire") && can_shoot and not reloading:
			shoot()
		
	
#func _on_shoot_interval_timeout() -> void:
	#shooterInterval.stop()
	#reload_audio.play()
	
func shoot():
	$GunShot.play()
	can_shoot = false
	reloading = true
	
	var bullet_instance = BULLET.instantiate()
	get_tree().root.add_child(bullet_instance)
	bullet_instance.ennemy_killed.connect(gain_score)
	bullet_instance.global_position = vodybe.global_position
	bullet_instance.rotation = rotation
	#shooterInterval.start()
	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true
	reloading = false
	


func _on_reload_gun_finished() -> void:
	#reload_audio.stop()
	can_shoot = true
	reloading = false

func cannotShoot():
	can_shoot = false

func gain_score():
	print()
	gain_point.emit()
