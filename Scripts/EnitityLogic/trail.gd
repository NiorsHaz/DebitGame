class_name Trail_Instance
extends Line2D

const MAX_POINTS: int = 2000
@onready var curve : Curve2D = Curve2D.new()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	curve.add_point(get_parent().position)
	if curve.get_baked_points().size() > MAX_POINTS:
		curve.remove_point(0)
	points = curve.get_baked_points()

func stop() -> void:
	set_process(false)
	var tw : Tween = get_tree().create_tween()
	tw.tween_property(self, "modulate:a", 0.0, 3.0)
	await tw.finished
	queue_free()

static func create() -> Trail_Instance:
	var scn : PackedScene = preload("res://Scenes/Gameplay/Trail.tscn")
	return scn.instantiate()
