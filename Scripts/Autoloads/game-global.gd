extends Node

var score : int = 0
var last_vagues : int = 0

func score_up():
	score += 1
	
func set_vague(vagues):
	last_vagues = vagues
	#print_debug("vague up: ", last_vagues)

func save_score() -> void:
	var file_path = "user://game_data.dat"
	
	# Vérifie si le fichier existe
	if not FileAccess.file_exists(file_path):
		# Fichier inexistant, on crée et on écrit
		var file = FileAccess.open(file_path, FileAccess.WRITE)
		file.store_string("alien_killed: %d, vagues: %d" % [score, last_vagues])
		file.close()
	else:
		# Le fichier existe, on peut lire ou afficher les scores précédents
		var file = FileAccess.open(file_path, FileAccess.READ)
		#var content = file.get_as_text()
		file.close()
		
		#print("Score existant : ", content)

		# On peut aussi écraser ou ajouter si nécessaire
		var file_write = FileAccess.open(file_path, FileAccess.WRITE)
		file_write.store_string("alien_killed: %d, vagues: %d" % [score, last_vagues])
		file_write.close()
		
func _get_score():
	return score
func _get_vagues():
	return last_vagues
	
func reset_game():
	score = 0
	last_vagues = 0
