note
	description: "This is a class representing a play_again operation."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class PLAY_AGAIN inherit OPERATION redefine execute, undo, redo end

create make

feature -- creation
	make(mdl: ETF_MODEL)
	do
		model := mdl
		board := model.board
		prev_state := model.output_status
	end

feature -- attributes
	model: ETF_MODEL								-- an instance of model
	board: BOARD									-- an instance of board (model's board)
	prev_state: STRING								-- previous output string
feature -- commands
	execute
	do
		-- before the game starts
		if model.game_state = false and not model.board.is_board_filled and not model.board.is_there_winner then
			model.set_output_status("ok:  => start new game")
		-- after the game has ended
		elseif model.game_state = false and model.board.is_board_filled and not model.board.is_there_winner then
			-- swap turns. if A starts first game, B starts next
			if model.starting_player = model.player_X then
				model.set_starting_player(model.player_O)
				model.set_turn (model.player_O)
			else
				model.set_starting_player(model.player_X)
				model.set_turn (model.player_X)
			end
			model.set_output_status("ok: => " + model.turn.name + " plays next")
			board.make
			model.set_game_state(true)
		-- when a player wins the game
		elseif model.game_state = false and not model.board.is_board_filled and model.board.is_there_winner then
			-- swap turns. if A starts first game, B starts next
			if model.starting_player = model.player_X then
				model.set_starting_player(model.player_O)
				model.set_turn (model.player_O)
			else
				model.set_starting_player(model.player_X)
				model.set_turn (model.player_X)
			end
			model.set_output_status("ok: => " + model.turn.name + " plays next")
			board.make
			model.set_game_state(true)
		else
			model.set_output_status("finish this game first: => " + model.turn.name + " plays next")
		end
	end

	undo
	do
		if model.game_state = true and incorrect_input then
			model.set_output_status(prev_state)
		end
	end

	redo do execute end

feature -- queries
	incorrect_input: BOOLEAN
	do Result := model.output_status.has_substring ("finish this game") end
end
