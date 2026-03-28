extends Camera2D

@export var shakeStrength : float
@export var shakeFade : float

var rng = RandomNumberGenerator.new()
var current_strength : float = 0.0
var can_shake : bool = true

func apply_shake():
	can_shake = false
	current_strength = shakeStrength
	await get_tree().create_timer(1.5).timeout
	can_shake = true 

func _process(delta: float) -> void:
	if Input.is_action_pressed("fire") and can_shake:
		apply_shake()
	
	if current_strength > 0:
		current_strength = lerpf(current_strength, 0, shakeFade * delta)
		#print(current_strength)
		offset = randomOffset()
	else:
		offset = Vector2.ZERO

func randomOffset() -> Vector2:
	return Vector2(
		rng.randf_range(-current_strength, current_strength),
		rng.randf_range(-current_strength, current_strength)
	)
