extends AudioStreamPlayer


var track1 = preload("res://UsedAssets/music/theme1_andrey_sitkov.ogg")
var track5 = preload("res://UsedAssets/music/theme5_andrey_sitkov.ogg")

var songs: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	songs.append(track1)
	songs.append(track5)
	play_next_song()


func play_next_song() -> void:
	var next_song = songs[randi() % 2]
	print("Next song is " + str(next_song))
	stream = next_song
	playing = true


func _on_Jukebox_finished() -> void:
	play_next_song()
