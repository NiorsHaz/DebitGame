extends Node2D

@onready var vodybe: Marker2D = $Vodybe
@onready var shooterInterval = $ShootInterval
@onready var reload_audio = $ReloadGun
@onready var player : Player = get_parent()
const  BULLET = preload("res://Scenes/Gameplay/bullet.tscn")

var can_shoot: bool = true
var reloading: bool = false

func _ready() -> void:
	player.death.connect(cannotShoot)
	reload_audio.autoplay = false

func _process(_delta) -> void:
	if GameManager.action_fight == true:
		var  mouse_position=get_global_mouse_position()
		look_at(mouse_position)
		
		rotation_degrees=wrap(rotation_degrees,0,360)
		if rotation_degrees >90 and rotation_degrees <270 :
			scale.y = -1
		else:
			scale.y =1
		
		if Input.is_action_just_pressed("fire") && can_shoot and not reloading:
			shoot()
		
	
func _on_shoot_interval_timeout() -> void:
	shooterInterval.stop()
	reload_audio.play()
	
func shoot():
	$GunShot.play()
	can_shoot = false
	reloading = true
	
	shooterInterval.start()
	
	var bullet_instance = BULLET.instantiate()
	get_tree().root.add_child(bullet_instance)
	bullet_instance.global_position = vodybe.global_position
	bullet_instance.rotation = rotation


func _on_reload_gun_finished() -> void:
	#reload_audio.stop()
	can_shoot = true
	reloading = false

func cannotShoot():
	can_shoot = false
