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

var num1: float #need these to be floats this time to eliminate rounding
var num2: float
var ans: String #it would normally make more since to set this as a float too, but we need it to be a string for is_vaid_int() to work on it.
var score: int = 0
var attempts: int = 3
var onelimit: int
var onecounter: int

func _newproblem():
	if remaining > 0: #Counter to see how long left in the round
		remaining = remaining - 1
		num1 = randi_range(2,100) #increase the range to make problems harder. We're using this mostly like flash cards for the basic facts.
		num2 = randi_range(1,9)
		ans = str(num1/num2)
		if ans.is_valid_int(): #checking to see if the numbers are evenly divisible
			if num2 == 1:
				onecounter = onecounter + 1
				if onecounter <= onelimit: #Every number is divisible by one, if we don't do this there will be a lot of problems dividing by one.
					problem_box.text = str(num1) + "\n/" + str(num2)
					attempts = 3
					answer_box.text = "" #clear the answer box
				else:
					remaining = remaining + 1
					_newproblem()
			else:
				problem_box.text = str(num1) + "\n/" + str(num2)
				attempts = 3
				answer_box.text = "" #clear
		else: 
			remaining = remaining + 1
			_newproblem()
	else:
		_gameover()

func _ready():
	score = 0
	onecounter = 0
	onelimit = 3
	game_over.visible = false #Hiding and disabling the Game Over features.
	play_again.disabled = true
	play_again.visible = false
	main_menu.disabled = true
	main_menu.visible = false
	_newproblem()
	scoreboard.text = "Score: " + str(score)
	
func _solver():
	if answer_box.text == str(num1/num2): 
		score = score + 25 + (25 * attempts) #This gives a perfect score of 100, or 75 on the second try, 50 on the third.
		scoreboard.text = "Score: " + str(score)
		if randi_range(0,1) == 1:#Randomly play one of the success sounds
			yay.play()
		else:
			woohoo.play()
		ani_timer.start(1) #Using the timer to stop the success animation
		player.play("correct")
		_newproblem()
	else:
		attempts = attempts - 1
		if randi_range(0,1) == 1:#Randomly play one of the failure sounds
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
	#Hiding game assets and showing game over ones
	problem_box.visible = false
	submit.visible = false
	answer_box.visible = false
	scoreboard.visible = false
	player.visible = false
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
