extends Label

const OUT_OF_RANGE_THRESHOLD_IN_PX = 90

@onready var _player: Player = $"../../../Player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = false
	_wait_for_toggle()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var customers = self.get_tree().get_nodes_in_group("Customers")
	if len(customers) == 0:
		self.visible = false
		return

	var customer_out_of_range = false
	for customer in customers:
		if _customer_exists_out_of_range(customer):
			customer_out_of_range = true
			break
	self.visible = customer_out_of_range

func _customer_exists_out_of_range(customer: Node2D) -> bool:
	return _player.global_position.x - customer.global_position.x > OUT_OF_RANGE_THRESHOLD_IN_PX

func _toggle() -> void:
	if len(self.text) == 0:
		self.text = "~"
	else:
		self.text = ""
	_wait_for_toggle()

func _wait_for_toggle() -> void:
	self.get_tree().create_timer(1.0).timeout.connect(_toggle)
