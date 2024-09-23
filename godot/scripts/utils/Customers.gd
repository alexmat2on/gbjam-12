extends Node2D

enum Distance {
	CLOSE,
	MEDIUM,
	FAR
}

# time between placement of orders
const _ORDER_INTERVAL_INCREMENT: float = 10.0

var _zombie_steak_customer = preload("res://scenes/customers/zombie_steak_customer.tscn")
var _zombie_stew_customer = preload("res://scenes/customers/zombie_stew_customer.tscn")
var _bone_chips_customer = preload("res://scenes/customers/bone_chips_customer.tscn")
var _customer_scenes = [
	_zombie_steak_customer,
	_zombie_stew_customer,
	_bone_chips_customer
]

var _spawns_for_day = {
	0: { "easy": 2 },
	1: { "easy": 2, "medium": 2 },
	2: { "easy": 2, "medium": 2, "hard": 2 },
	3: { "easy": 2, "medium": 2, "hard": 2, "insane": 2 }
}

var _easy_spawns = [Vector2(346, 46), Vector2(603, 46)]
var _medium_spawns = [Vector2(262, 46), Vector2(694, 46)]
var _hard_spawns = [Vector2(160, 14), Vector2(771, 30)]
var _insane_spawns = [Vector2(29, 126), Vector2(896, -18)]

func _get_easy_spawns() -> Array:
	return _easy_spawns.duplicate()

func _get_medium_spawns() -> Array:
	return _medium_spawns.duplicate()

func _get_hard_spawns() -> Array:
	return _hard_spawns.duplicate()

func _get_insane_spawns() -> Array:
	return _insane_spawns.duplicate()

func _get_spawn_positions() -> Array:
	var positions: Array = []
	var spawn_data = _spawns_for_day[GlobalState.get_day()]
	for difficulty in spawn_data:
		var spawns: Array
		var count = spawn_data[difficulty]
		if difficulty == "easy":
			spawns = _get_easy_spawns()
		elif difficulty == "medium":
			spawns = _get_medium_spawns()
		elif difficulty == "hard":
			spawns = _get_hard_spawns()
		elif difficulty == "insane":
			spawns = _get_insane_spawns()
		for i in range(count):
			var ri = randi_range(0, len(spawns) - 1)
			positions.append(spawns.pop_at(ri))
	return positions

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in self.get_children():
		child.queue_free()

	if not GlobalState.is_serve_mode():
		GlobalState.set_orders(0)
		return

	var order_interval: float = 1.0
	var spawn_positions = _get_spawn_positions()
	for spawn_position in spawn_positions:
		var new_customer = _get_random_customer()
		new_customer.add_to_group("Customers")
		new_customer.position = spawn_position
		self.get_tree().create_timer(order_interval).timeout.connect(self.add_child.bind(new_customer))
		order_interval += _ORDER_INTERVAL_INCREMENT

	GlobalState.set_orders(len(spawn_positions))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _get_random_customer() -> Node2D:
	var ri = randi_range(0, len(_customer_scenes) - 1)
	return _customer_scenes[ri].instantiate()

func _add_customer(customer: Node2D) -> void:
	self.add_child(customer)
