extends Camera2D

@export var shakeStrength : float
@export var shakeFade : float

var rng = RandomNumberGenerator.new()
var current_strength : float = 0.0

func apply_shake():
	current_strength = shakeStrength 

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("fire"):
		apply_shake()
	
	if current_strength > 0:
		current_strength = lerpf(current_strength, 0, shakeFade * delta)
		print(current_strength)
		offset = randomOffset()
	else:
		offset = Vector2.ZERO

func randomOffset() -> Vector2:
	return Vector2(
		rng.randf_range(-current_strength, current_strength),
		rng.randf_range(-current_strength, current_strength)
	)
