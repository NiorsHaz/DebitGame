extends Node2D

@onready var marker: Marker2D = $Marker2D
const ENEMY= preload("res://scene/enemy.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func spawn_mob():
	var enemy_instanciate= ENEMY.instantiate()
	get_tree().root.add_child(enemy_instanciate)
	enemy_instanciate.global_position=marker.global_position


func _on_timer_timeout() -> void:
	spawn_mob()
