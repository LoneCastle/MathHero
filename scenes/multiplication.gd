extends Node2D

@export var remaining: int 
@onready var problem_box = $ProblemBox
@onready var answer_box = %AnswerBox
@onready var submit = $Submit
@onready var game_over = $GameOver
@onready var scoreboard = $Scoreboard
@onready var play_again = $PlayAgain
@onready var main_menu = $MainMenu
@onready var yay = $yay
@onready var woohoo = $woohoo
@onready var awman = $awman
@onready var ohno = $ohno
@onready var player = $Player
@onready var ani_timer = $AniTimer

var num1: int
var num2: int
var score: int = 0
var attempts: int = 3
var zerolimit: int
var zerocounter: int = 0

func _newproblem():
	if remaining > 0:
		remaining = remaining - 1
		num1 = randi_range(0,9)
		num2 = randi_range(0,9)
		if num1 == 0 and num2 == 0:
			remaining = remaining + 1
			_newproblem()
		if num1 == 0 or num2 == 0:
			zerocounter = zerocounter + 1
			if zerocounter >= zerolimit:
				remaining = remaining + 1
				_newproblem()
		problem_box.text = str(num1) + "\nx" + str(num2)
		attempts = 3
		answer_box.text = ""
	else:
		_gameover()

func _ready():
	score = 0
	game_over.visible = false
	play_again.disabled = true
	play_again.visible = false
	main_menu.disabled = true
	main_menu.visible = false
	zerocounter = 0
	zerolimit = 3
	_newproblem()
	scoreboard.text = "Score: " + str(score)
	
func _solver():
	if int(answer_box.text) == num1 * num2:
		score = score + 25 + (25 * attempts)
		scoreboard.text = "Score: " + str(score)
		if randi_range(0,1) == 1:
			yay.play()
		else:
			woohoo.play()
		ani_timer.start(1)
		player.play("correct")
		_newproblem()
	else:
		attempts = attempts - 1
		if randi_range(0,1) == 1:
			awman.play()
		else:
			ohno.play()
		if attempts < 1:
			_newproblem()

func _on_submit_pressed():
	_solver()


func _on_answer_box_text_submitted(_new_text):
	_solver()

func _gameover():
	problem_box.visible = false
	submit.visible = false
	answer_box.visible = false
	scoreboard.visible = false
	game_over.text = "Congratulations!\nYour score is " + str(score)
	game_over.visible = true
	play_again.disabled = false
	play_again.visible = true
	main_menu.disabled = false
	main_menu.visible = true


func _on_play_again_pressed():
	get_tree().reload_current_scene()


func _on_ani_timer_timeout():
	player.play("default")


func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
