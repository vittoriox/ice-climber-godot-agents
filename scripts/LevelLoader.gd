class_name LevelLoader
extends RefCounted

## Data-only loader. It validates the contract without inventing unknown values.

var level_data: Dictionary = {}
var errors: Array[String] = []

func load_level(path: String) -> bool:
	errors.clear()
	level_data.clear()
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		errors.append("No se pudo abrir: %s" % path)
		return false
	var parsed = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		errors.append("El nivel no contiene un objeto JSON raíz")
		return false
	level_data = parsed
	_validate_contract()
	return errors.is_empty()

func _validate_contract() -> void:
	for required in ["metadata", "dimensions", "aspect_ratio", "grid", "coordinate_system", "areas", "objects", "players"]:
		if not level_data.has(required):
			errors.append("Falta campo requerido: %s" % required)
	if level_data.get("metadata", {}).get("future_multiplayer_ready", false) != true:
		errors.append("El nivel no declara preparación multijugador futura")
	for object_data in level_data.get("objects", []):
		if not object_data.has("id") or not object_data.has("type"):
			errors.append("Objeto sin id/type")
		if object_data.get("x") == null or object_data.get("y") == null:
			continue
		if typeof(object_data.get("x")) not in [TYPE_INT, TYPE_FLOAT] or typeof(object_data.get("y")) not in [TYPE_INT, TYPE_FLOAT]:
			errors.append("Coordenada inválida en %s" % object_data.get("id", "?"))

func get_objects_with_known_coordinates() -> Array:
	var result: Array = []
	for object_data in level_data.get("objects", []):
		if object_data.get("x") != null and object_data.get("y") != null:
			result.append(object_data)
	return result
