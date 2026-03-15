extends CanvasLayer

enum CardChoice {
	ROCK = 1,
	PAPER = 2,
	SCISSOR = 3
}

enum Result {
	DRAW,
	WIN,
	LOSE
}

var rock_texture = load("res://art/rock-hand.png")
var paper_texture = load("res://art/paper-hand.png")
var scissor_texture = load("res://art/scissors-hand.png")

var player_choice
var computer_choice
var computer_choice_index = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	$Screen/ResetButton.visible = false
	
	var rockHandSprite = $ButtonPanel/RockCard/HandSprite
	rockHandSprite.texture = rock_texture
	var paperHandSprite = $ButtonPanel/PaperCard/HandSprite
	paperHandSprite.texture = paper_texture
	var scissorHandSprite = $ButtonPanel/ScissorCard/HandSprite
	scissorHandSprite.texture = scissor_texture

func _set_texture_from_choice(sprite: Sprite2D, card: CardChoice) -> void:
	if card == CardChoice.ROCK:
		sprite.texture = rock_texture
	if card == CardChoice.PAPER:
		sprite.texture = paper_texture
	if card == CardChoice.SCISSOR:
		sprite.texture = scissor_texture

func _determine_winner(player_choice: CardChoice, computer_choice: CardChoice) -> Result:
	if player_choice == computer_choice:
		return Result.DRAW
		
	var result = (player_choice - computer_choice + 3) % 3
	return Result.WIN if result == 1 else Result.LOSE
	
func _change_HUD(outcome: Result):
	var label = $Screen/VersusLabel
	if outcome == Result.DRAW:
		label.text = "DRAW!"
	if outcome == Result.LOSE:
		label.text = "YOU LOSE!"
	if outcome == Result.WIN:
		label.text = "YOU WON!"
	$Screen/ResetButton.visible = true
	
func _on_rock_card_clicked() -> void:
	if player_choice:
		return
	player_choice = CardChoice.ROCK
	_set_texture_from_choice($Screen/PlayerChoiceCard/HandSprite, player_choice)
	var outcome = _determine_winner(player_choice, computer_choice)
	_change_HUD(outcome)

func _on_paper_card_clicked() -> void:
	if player_choice:
		return
	player_choice = CardChoice.PAPER
	_set_texture_from_choice($Screen/PlayerChoiceCard/HandSprite, player_choice)
	var outcome = _determine_winner(player_choice, computer_choice)
	_change_HUD(outcome)
	
func _on_scissor_card_clicked() -> void:
	if player_choice:
		return
	player_choice = CardChoice.SCISSOR
	_set_texture_from_choice($Screen/PlayerChoiceCard/HandSprite, player_choice)
	var outcome = _determine_winner(player_choice, computer_choice)
	_change_HUD(outcome)
	
func _on_computer_timer_timeout() -> void:
	if player_choice:
		return
	computer_choice = [CardChoice.ROCK, CardChoice.PAPER, CardChoice.SCISSOR][computer_choice_index]
	_set_texture_from_choice($Screen/ComputerCard/HandSprite, computer_choice)
	computer_choice_index = 0 if computer_choice_index == 2 else computer_choice_index + 1


func _on_reset_button_pressed() -> void:
	player_choice = null
	computer_choice = null
	$Screen/PlayerChoiceCard/HandSprite.texture = null
	$Screen/ResetButton.visible = false
	$Screen/VersusLabel.text = "VS"
	
