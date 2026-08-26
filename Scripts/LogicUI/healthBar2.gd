extends TextureProgressBar

@onready var player : Player = $"../../../../.."
var health_state = 1

func _ready() -> void:
	max_value = player.max_health
	value = player.health
	player.hurt.connect(hurtBySomething)

func _process(delta: float) -> void:
	#if GameManager.action_fight == true:
		self.visible = true
		if value>50:
			tint_progress = Color.CHARTREUSE
			$healthBar.play("full")
		if value<=50:
			tint_progress = Color.CORAL
			$healthBar.play("mid")
		if value <= 25:
			tint_progress = Color.CRIMSON
			$healthBar.play("critical")
		if player.health<=0:
			pass
			$healthBar.play("death")

func hurtBySomething(_damage : int) -> void:
	value = player.health * 105 / player.max_health
