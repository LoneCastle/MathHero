extends Node2D


func _on_addition_pressed():
	get_tree().change_scene_to_file("res://scenes/Addition.tscn")



func _on_subtraction_pressed():
	get_tree().change_scene_to_file("res://scenes/Subtraction.tscn")


func _on_multiplication_pressed():
	get_tree().change_scene_to_file("res://scenes/Multiplication.tscn")


func _on_quit_pressed():
	get_tree().quit()
