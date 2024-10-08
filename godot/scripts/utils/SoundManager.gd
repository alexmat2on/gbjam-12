extends Node

var _audio_streams: Dictionary = {
	Enums.SoundEffect.JUMP: preload("res://audio/sfx/jump.wav"),
	Enums.SoundEffect.BLIP: preload("res://audio/sfx/menu-beep.wav"),
	Enums.SoundEffect.TAKE_DAMAGE: preload("res://audio/sfx/damage-taken.wav"),
	Enums.SoundEffect.FLAMETHROWER: preload("res://audio/sfx/flamethrower.wav"),
	Enums.SoundEffect.HEAVY_WEAPON: preload("res://audio/sfx/heavy-hit.wav"),
	Enums.SoundEffect.LIGHT_WEAPON: preload("res://audio/sfx/light-hit.wav")
}

var _audio_stream_players: Dictionary = {}

func _ready() -> void:
	for sfx in _audio_streams.keys():
		var asp = AudioStreamPlayer.new()
		asp.stream = _get_audio_stream(sfx)
		_audio_stream_players[sfx] = asp
		self.add_child(asp)

func _get_audio_stream(sfx: Enums.SoundEffect) -> AudioStream:
	return _audio_streams[sfx]

func _get_audio_stream_player(sfx: Enums.SoundEffect) -> AudioStreamPlayer:
	return _audio_stream_players[sfx]

func play(sfx: Enums.SoundEffect) -> void:
	_get_audio_stream_player(sfx).play()

func stop(sfx: Enums.SoundEffect) -> void:
	_get_audio_stream_player(sfx).stop()
