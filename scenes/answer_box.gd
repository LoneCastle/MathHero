extends LineEdit

@onready var answer_box = %AnswerBox
@onready var AnswerBoxRegEx = RegEx.new()
var old_text = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AnswerBoxRegEx.compile("^[0-9]*$") #This sets up a regular expression that only includes whole numbers. Need to add a decimal behind the 9 if modifying the game to involve decimals or fractions.
	text_changed.connect(_on_text_changed) #This just makes it so that the _on_text_changed function will work

func _on_text_changed(new_text):
	if AnswerBoxRegEx.search(new_text): #Makes sure any input is a part of our regular expression and thus a whole number.
		old_text = str(new_text)
	else:
		answer_box.text = old_text #If anything that wasn't a number gets put in, it changes the text back to what it was before that key was pressed.
		answer_box.set_caret_column(answer_box.text.length())
