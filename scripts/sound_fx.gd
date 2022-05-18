extends AudioStreamPlayer
onready var default_sound = load("res://sound/sound_fx/water_splesh.wav")
var new_stream_player = AudioStreamPlayer.new()
var stream_player_array = []

func play_sound(sound_name):
	#create new stream player and add it to the scene
	var new_stream_player = AudioStreamPlayer.new()
	add_child(new_stream_player)
	
	#load the matching audio path
	var sound_to_play = get_sound_data(sound_name)
	
	#create new stream player instance to host the sound, then play the sound
	new_stream_player.stream = sound_to_play
	new_stream_player.bus = "SoundFx"
	new_stream_player.play(0.0)
	
	#add the stream player instance to array for future removal
	stream_player_array.append([sound_name, new_stream_player])
	
	#delete node once the sample finishes playing
	yield(new_stream_player, "finished")
	stop_sound(sound_name)
	
func stop_sound(sound_name):
	var stream_player_to_stop
	
	#search the stream player array for the given sound, then stop playing the sound, and delete the stream player instance
	for i in len(stream_player_array):
		if(stream_player_array[i][0] == sound_name):
			stream_player_to_stop = stream_player_array[i][1]
			stream_player_to_stop.stop()
			stream_player_to_stop.queue_free()
			stream_player_array.remove(i)
			break

func stop_all_sound():
	for i in len(stream_player_array):
		var stream_player_to_delete = stream_player_array[i][1]
		stream_player_to_delete.stop()
		stream_player_to_delete.queue_free()
		stream_player_array.remove(i)
		break

#default mode is return the sound, mode == "index" returns the index of the stream_player in stream_player_array
func get_sound_data(sound_name):
	var sound_to_play
	
	#set sound_to_play to the desired sound effect, and stream_player_array_index to the correct index
	match sound_name:
		"splash1":
			sound_to_play = load("res://sound/sound_fx/water_splesh.wav")
		"splash2":
			sound_to_play = load("res://sound/sound_fx/water_kaspoosh.wav")
		"splash3":
			sound_to_play = load("res://sound/sound_fx/watersploosh.wav")
		"splash_bobber_bad":
			sound_to_play = load("res://sound/sound_fx/bobberhittingwater.wav")
			
		"line1":
			sound_to_play = load("res://sound/sound_fx/linepull1.wav")
		"line2":
			sound_to_play = load("res://sound/sound_fx/linepull2.wav")
		"line3":
			sound_to_play = load("res://sound/sound_fx/linepull3.wav")
		"line_continuous":
			sound_to_play = load("res://sound/sound_fx/continuous_linepull.wav")
			
		"boat_start":
			sound_to_play = load("res://sound/sound_fx/boatstartup.wav")
		"boat_continuous":
			sound_to_play = load("res://sound/sound_fx/boatcontinuous.wav")
		"boat_end":
			sound_to_play = load("res://sound/sound_fx/boatend.wav")
			
		"select":
			sound_to_play = load("res://sound/sound_fx/selectnoise.wav")
		"page_flip":
			sound_to_play = load("res://sound/sound_fx/page_flip.wav")
			
		"atmosphere_coastal":
			sound_to_play = load("res://sound/sound_fx/coastal_atmosphere.wav")
		"atmosphere_rain":
			sound_to_play = load("res://sound/sound_fx/rainatmosphere.wav")
			
		#set sound_to_play to default sound when sound_name isn't correlated with a path
		_:
			sound_to_play = default_sound
			
	return sound_to_play
