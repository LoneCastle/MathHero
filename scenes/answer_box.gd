extends LineEdit

@onready var answer_box = %AnswerBox
@onready var AnswerBoxRegEx = RegEx.new()
var old_text = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AnswerBoxRegEx.compile("^[0-9.]*$")
	text_changed.connect(_on_text_changed)

func _on_text_changed(new_text):
	if AnswerBoxRegEx.search(new_text):
		old_text = str(new_text)
	else:
		answer_box.text = old_text
		answer_box.set_caret_column(answer_box.text.length())
