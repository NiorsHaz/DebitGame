extends Node2D

@onready var marker: Marker2D = $Marker2D
@export var limit = 5
@export var alien_killed=0
@export var min_x := 400.0
@export var max_x := 700.0
const ENEMY= preload("res://Scenes/Gameplay/enemy.tscn")
@onready var alien_timer: Timer = $AlienTimer
@onready var vague_number: Label = $CanvasLayer/GameManager/HBoxContainer/vagueNumber
@onready var alien_kill: Label = $CanvasLayer/GameManager/HBoxContainer/AlienKilled
@onready var current_position = self.global_position

var count = 0
var vague = 0
var is_moving: bool = false
var target_position: Vector2
var wait_time : float = 1.0

var move_speed = 100.0 # Pixels per second
var rng = RandomNumberGenerator.new()

func _ready():
	target_position = global_position
	rng.randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func spawn_mob():
	var enemy = ENEMY.instantiate()
	get_tree().root.add_child(enemy)
	enemy.global_position = marker.global_position
	
	count += 1
	
	# Set a new horizontal target position, with clamping
	var offset = rng.randf_range(-150, 150)
	var new_x = clamp(global_position.x + offset, min_x, max_x)
	target_position = Vector2(new_x, global_position.y)

func _process(delta: float) -> void:
	if GameManager.action_fight == false: is_moving = true
	else: 
		is_moving = false
		if alien_killed >= limit:
			limit += 5
			vague += 1
			alien_timer.wait_time = 2.0
			alien_timer.paused = false
			count = 0 # Reset spawn count for the new wave
			GameGlobal.set_vague(vague)
			
			if alien_killed % 10 == 0 and alien_killed != 0:
				wait_time = max(0.2, wait_time - 0.1)
		
		# Smooth movement toward target_position
		if global_position.distance_to(target_position) > 1.0:
			is_moving = true
			global_position = global_position.move_toward(target_position, move_speed * delta)
		else:
			is_moving = false
		
		# Update UI
		vague_number.text = "Vague : " + str(vague)
		alien_kill.text = "Alien killed : " + str(alien_killed)

func _on_timer_timeout() -> void:
	if not is_moving:
		spawn_mob()

		if count==limit:
			alien_timer.paused=true
		alien_timer.wait_time= wait_time

func shuffle():
	var num_rand = RandomNumberGenerator.new()
	return num_rand.randf_range(-10, 10)
