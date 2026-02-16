extends Node
class_name ApiManager

@export var config: ApiConfig
@onready var http: HTTPRequest = HTTPRequest.new()

var _pending_resolver: Callable = Callable()

func _ready() -> void:
	add_child(http)
	http.request_completed.connect(_on_request_completed)


# ===================================================
# PUBLIC ASYNC METHODS
# ===================================================

func api_get(endpoint: String, headers: Array = []) -> Variant:
	return await _make_request(endpoint, HTTPClient.METHOD_GET, null, headers)


func api_post(endpoint: String, data: Dictionary, headers: Array = []) -> Variant:
	return await _make_request(endpoint, HTTPClient.METHOD_POST, data, headers)


func api_put(endpoint: String, data: Dictionary, headers: Array = []) -> Variant:
	return await _make_request(endpoint, HTTPClient.METHOD_PUT, data, headers)


func api_patch(endpoint: String, data: Dictionary, headers: Array = []) -> Variant:
	return await _make_request(endpoint, HTTPClient.METHOD_PATCH, data, headers)


func api_delete(endpoint: String, headers: Array = []) -> Variant:
	return await _make_request(endpoint, HTTPClient.METHOD_DELETE, null, headers)


# ===================================================
# CORE REQUEST FUNCTION
# ===================================================

func _make_request(endpoint: String, method: int, data: Variant = null, headers: Array = []) -> Variant:
	
	var url = config.api_url + endpoint
	
	var final_headers = headers.duplicate()
	
	# Add token automatically
	if config.api_token != "":
		final_headers.append("Authorization: Bearer " + config.api_token)
		final_headers.append("apikey: " + config.api_token)
	
	var body := ""
	
	if data != null:
		body = JSON.stringify(data)
		final_headers.append("Content-Type: application/json")
	
	var err = http.request(url, final_headers, method, body)
	
	if err != OK:
		push_error("HTTP Request Error: %s" % err)
		return null
	
	# Wait until request_completed signal fires
	return await self.request_completed_signal


# Custom signal used to return result
signal request_completed_signal(data)


# ===================================================
# RESPONSE HANDLER
# ===================================================

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	
	if result != HTTPRequest.RESULT_SUCCESS:
		request_completed_signal.emit(null)
		return
	
	var response_text = body.get_string_from_utf8()
	
	var json = JSON.new()
	var parse_result = json.parse(response_text)
	
	if parse_result == OK:
		request_completed_signal.emit(json.data)
	else:
		request_completed_signal.emit(response_text)
