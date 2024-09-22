extends Interactable2D

const _TIME_LIMIT: float = 30.0

@export var recipe_order: Enums.Recipe

@onready var _order_sprite: Sprite2D = $RecipeOrder
@onready var _fail_progress: AnimatedSprite2D = $FailProgress
@onready var _player: Player = $"../Player"

var _fail_timer: Timer

func on_interact_enter(player):
	super.on_interact_enter(player)
	return

func on_interact_exit(player):
	super.on_interact_exit(player)
	return

func interact(_player):
	if not _player.is_carrying_dish():
		print("i hunger for " + RecipeUtils.get_recipe_title(self.recipe_order) + ".")
		return
	if _player.get_dish() != self.recipe_order:
		print("this is not what i seek.")
		return
	_complete_order()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_order_sprite.texture = RecipeUtils.get_recipe_texture(recipe_order)
	_fail_progress.frame = 0
	_fail_timer = _create_timer(_TIME_LIMIT)
	_fail_timer.timeout.connect(_invoke_wrath)
	self.add_child(_fail_timer)
	_fail_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_fail_progress.frame = _get_progress_frame(_fail_timer, _fail_progress)

func _complete_order() -> void:
	_player.drop_dish()
	print("satiation.")
	self.queue_free()

func _create_timer(time: float) -> Timer:
	var timer = Timer.new()
	timer.wait_time = time
	timer.one_shot = true
	timer.process_callback = Timer.TIMER_PROCESS_PHYSICS
	return timer

func _get_progress_frame(timer: Timer, anim: AnimatedSprite2D) -> int:
	var progress_percentage: float = 1.0 - (timer.time_left / timer.wait_time)
	return floor(progress_percentage * _get_frame_count(anim))

func _get_frame_count(anim: AnimatedSprite2D) -> int:
	return anim.sprite_frames.get_frame_count("default")

# Invokes the wrath of the Ancients from deep within the Darkest Glade.
func _invoke_wrath() -> void:
	print("taste death.")
	_player.health.remove_health()
	self.queue_free()
