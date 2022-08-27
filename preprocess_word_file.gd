tool
extends Node

# Helper script to filter an input file and remove unnecessary words from it.
# The input file should be a text file with each input word on a separate line.
# This script will import write all input words of defined min through max
# lengths into the output file.



func _ready() -> void:
	preprocess_word_file()


func preprocess_word_file() -> void:
	# Open file
	var file = File.new()
	file.open()
	# Read through words and write to output file
	var num_words: int = 0
	
	# Close files
	
	print("Done!")
	print("Wrote " + str(num_words) + " words.")
