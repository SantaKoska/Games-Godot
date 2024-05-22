extends Control

# Variables to hold game state
var player_score = 0
var computer_score = 0
var player_wickets = 0
var computer_wickets = 0
var is_player_turn = true
var game_over = false
var player_batting = true  # True if the player is batting, false if the computer is batting

const MAX_WICKETS = 2

# UI Elements
@onready var player_choice_label = $PlayerChoiceLabel
@onready var computer_choice_label = $ComputerChoiceLabel
@onready var player_score_label = $PlayerScoreLabel
@onready var computer_score_label = $ComputerScoreLabel
@onready var result_label = $ResultLabel

# Function to handle player's move
func player_move(player_choice: int) -> void:
	if game_over or not is_player_turn:
		return

	print("Player's choice:", player_choice)

	# Update UI with player's choice
	player_choice_label.text = "Player Choice: %d" % player_choice

	var computer_choice = randi() % 6 + 1  # Computer randomly chooses a number between 1 and 6

	if player_batting:
		if player_choice == computer_choice:
			result_label.text = "Wicket!"
			player_wickets += 1
			if player_wickets == MAX_WICKETS:
				player_batting = false
				reset_for_computer_batting()
		else:
			player_score += player_choice
			player_score_label.text = "Player Score: %d" % player_score
			result_label.text = "Player is batting..."
	else:
		if player_choice == computer_choice:
			result_label.text = "Wicket!"
			computer_wickets += 1
			if computer_wickets == MAX_WICKETS:
				game_over = true
				show_game_over("Player wins!")
		else:
			computer_score += computer_choice
			computer_score_label.text = "Computer Score: %d" % computer_score
			result_label.text = "Computer is batting..."

		if computer_score > player_score:
			game_over = true
			show_game_over("Computer wins!")

	if not game_over:
		is_player_turn = false
		await get_tree().create_timer(1.0).timeout
		computer_move(computer_choice)

# Function to handle computer's move
func computer_move(player_choice: int) -> void:
	if game_over or is_player_turn:
		return

	print("Computer's choice:", player_choice)

	var computer_choice = randi() % 6 + 1

	# Update UI with computer's choice
	computer_choice_label.text = "Computer Choice: %d" % computer_choice

	if not player_batting:
		if player_choice == computer_choice:
			result_label.text = "Wicket!"
			computer_wickets += 1
			if computer_wickets == MAX_WICKETS:
				game_over = true
				show_game_over("Player wins!")
		else:
			computer_score += computer_choice
			computer_score_label.text = "Computer Score: %d" % computer_score
			result_label.text = "Computer is batting..."

		if computer_score > player_score:
			game_over = true
			show_game_over("Computer wins!")
	else:
		if player_choice == computer_choice:
			result_label.text = "Wicket!"
			player_wickets += 1
			if player_wickets == MAX_WICKETS:
				player_batting = false
				reset_for_computer_batting()
		else:
			player_score += player_choice
			player_score_label.text = "Player Score: %d" % player_score
			result_label.text = "Player is batting..."

	if not game_over:
		is_player_turn = true

# Function to reset game for computer batting
func reset_for_computer_batting() -> void:
	is_player_turn = false
	player_batting = false
	player_wickets = 0
	result_label.text = "Computer's turn to bat!"
	if not game_over:
		await get_tree().create_timer(1.0).timeout
		computer_move(0) # Passing 0 as player's choice for computer's move

# Function to display game over message
func show_game_over(message: String) -> void:
	# Show the game over message
	result_label.text = message
	print(message)

# Function to reset the game
func reset_game() -> void:
	player_score = 0
	computer_score = 0
	player_wickets = 0
	computer_wickets = 0
	game_over = false
	is_player_turn = randi() % 2 == 0  # Randomly decide who starts
	player_batting = is_player_turn
	# Update UI to reflect reset state
	player_score_label.text = "Player Score: 0"
	computer_score_label.text = "Computer Score: 0"
	player_choice_label.text = "Player Choice: "
	computer_choice_label.text = "Computer Choice: "
	result_label.text = "Waiting for first turn..."
	if not is_player_turn:
		await get_tree().create_timer(1.0).timeout
		computer_move(0) # Passing 0 as player's choice for computer's move

# Button press functions
func _on_button_1_pressed() -> void:
	player_move(1)

func _on_button_2_pressed() -> void:
	player_move(2)

func _on_button_3_pressed() -> void:
	player_move(3)

func _on_button_4_pressed() -> void:
	player_move(4)

func _on_button_5_pressed() -> void:
	player_move(5)

func _on_button_6_pressed() -> void:
	player_move(6)

func _on_reset_button_pressed() -> void:
	reset_game()
