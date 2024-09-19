extends Node

var _audio_streams: Dictionary = {
	SoundEffect.JUMP: preload("res://tunes/jump.wav"),
	SoundEffect.BLIP: preload("res://tunes/menu-beep.wav"),
	SoundEffect.TAKE_DAMAGE: preload("res://tunes/damage-taken.wav"),
	SoundEffect.FLAMETHROWER: preload("res://tunes/flamethrower.wav"),
	SoundEffect.HEAVY_WEAPON: preload("res://tunes/heavy-hit.wav"),
	SoundEffect.LIGHT_WEAPON: preload("res://tunes/light-hit.wav")
}

var _audio_stream_players: Dictionary = {}

func _ready() -> void:
	for sfx in _audio_streams.keys():
		var asp = AudioStreamPlayer.new()
		asp.stream = _get_audio_stream(sfx)
		_audio_stream_players[sfx] = asp
		self.add_child(asp)

func _get_audio_stream(sfx: int) -> AudioStream:
	return _audio_streams[sfx]

func _get_audio_stream_player(sfx: int) -> AudioStreamPlayer:
	return _audio_stream_players[sfx]

func play(sfx: int) -> void:
	_get_audio_stream_player(sfx).play()

func stop(sfx: int) -> void:
	_get_audio_stream_player(sfx).stop()
