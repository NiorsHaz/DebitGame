extends Node

# "alien killed : 5; vagues : 1"
func string_to_json(separator: String, text: String) -> Dictionary:
	var parts = text.split(separator)
	var data = {}
	for part in parts:
		part = part.strip_edges() # remove spaces
		var kv = part.split(":")
		if kv.size() == 2:
			var key = kv[0].strip_edges()
			var value = kv[1].strip_edges()
		# Try converting to number if possible
			if value.is_valid_int():
				value = int(value)
			elif value.is_valid_float():
				value = float(value)
			data[key] = value
		elif kv.size() < 2:
			data[kv[0].strip_edges()] = null
	return data

# player1 : { alien_killed: 5; vagues: 1}, player2 : { alien_killed: 35; vagues: 2}
func parse_custom_string(input_str: String) -> Dictionary:
	var result = {}
	# Split each entry by "},"
	var entries = input_str.split("},")
	for entry in entries:
		entry = entry.strip_edges()
	# Remove trailing brace if it exists
		if entry.ends_with("}"):
			entry = entry.substr(0, entry.length() - 1)
		# Split into name and its data
			var name_split = entry.split(":", false, 2) # max 2 splits
			if name_split.size() == 2:
				var player_name = name_split[0].strip_edges()
				var inner_data = name_split[1].strip_edges().trim_prefix("{").trim_suffix("}")

			# Parse key-value pairs inside {}
				var inner_dict = {}
				for part in inner_data.split(";"):
					part = part.strip_edges()
					var kv = part.split(":")
					if kv.size() == 2:
						var key = kv[0].strip_edges()
						var value = kv[1].strip_edges()
						if value.is_valid_int():
							value = int(value)
						elif value.is_valid_float():
							value = float(value)
							inner_dict[key] = value
			# Add to final dictionary
				result[player_name] = inner_dict
	return result
