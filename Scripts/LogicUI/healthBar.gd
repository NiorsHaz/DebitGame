extends TextureProgressBar

@export var player : Player
var health_state = 1

func _ready() -> void:
	player.hurt.connect(hurtBySomething)

func _process(delta: float) -> void:
	if GameManager.action_fight == true:
		self.visible = true
		if player.health>50:
			tint_progress = Color.CHARTREUSE
			$healthBar.play("full")
		if player.health<=50:
			tint_progress = Color.CORAL
			$healthBar.play("mid")
		if player.health <= 25:
			tint_progress = Color.CRIMSON
			$healthBar.play("critical")
		if player.health<=0:
			$healthBar.play("death")

func hurtBySomething(damage : int) -> void:
	value = (player.health + damage) * 100 / player.max_health
