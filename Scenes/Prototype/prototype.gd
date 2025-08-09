extends Node2D

func _process(_delta) -> void:
	if GameManager.start_game == true && $StartGame2.visible == false:
		$StartGame2.activate_me()
		
