extends Node

signal inventory_changed
signal item_added(item_id: String)
signal item_removed(item_id: String)

var items: Dictionary = {}


func add_item(item_id: String, amount: int = 1) -> void:
	if item_id.is_empty():
		return

	if items.has(item_id):
		items[item_id] += amount
	else:
		items[item_id] = amount

	item_added.emit(item_id)
	inventory_changed.emit()


func remove_item(item_id: String, amount: int = 1) -> bool:
	if not has_item(item_id, amount):
		return false

	items[item_id] -= amount

	if items[item_id] <= 0:
		items.erase(item_id)

	item_removed.emit(item_id)
	inventory_changed.emit()

	return true


func has_item(item_id: String, amount: int = 1) -> bool:
	if not items.has(item_id):
		return false

	return items[item_id] >= amount


func get_amount(item_id: String) -> int:
	if not items.has(item_id):
		return 0

	return items[item_id]


func clear() -> void:
	items.clear()
	inventory_changed.emit()
