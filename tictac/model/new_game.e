note
	description: "This is a class representing a new_game() operation."
	author: "S Oryakhel"
	date: "$Date$"
	revision: "$Revision$"

class NEW_GAME inherit OPERATION redefine execute, undo, redo end

create make

feature -- creation
	make(mdl: ETF_MODEL; playerX: STRING; playerO: STRING)
	do
		model := mdl
		player1 := playerX
		player2 := playerO
		prev_state := model.output_status
	end

feature -- attributes
	model: ETF_MODEL								-- an instance of model
	player1: STRING									-- player X
	player2: STRING									-- player O
	prev_state: STRING								-- model's previous output string
feature -- commands
	execute
	do
		-- error check if the inputted names are identical
		if player1 ~ player2 then
			-- before the game starts or after it has ended
			if model.game_state = false then
				-- before the game starts
				if not model.board.is_there_winner and not model.board.is_board_filled then
					model.set_output_status ("names of players must be different:  => start new game")
				-- when a game has ended
				elseif model.board.is_there_winner or model.board.is_board_filled then
				 model.set_output_status ("names of players must be different: => play again or start new game")
				end
			-- during the game 				
			else
				model.set_output_status ("names of players must be different: => " + model.turn.name + " plays next")
			end
		-- error check if the inputted names are not valid
		elseif not player1.at (1).is_alpha or not player2.at (1).is_alpha then
			-- before the game starts or after it has ended
			if  model.game_state = false  then
				-- before the game starts
				if not model.board.is_board_filled and not model.board.is_there_winner then
					model.set_output_status ("name must start with A-Z or a-z:  => start new game")
				-- when a game has ended
				elseif model.board.is_board_filled or model.board.is_there_winner then
					model.set_output_status ("name must start with A-Z or a-z: => play again or start new game")
				end
			-- during the game 				
			else
				model.set_output_status ("name must start with A-Z or a-z: => " + model.turn.name + " plays next")
			end
		else
			model.clear_history								-- clear the undo-redo lists
			model.player_X.make (player1, "X")				-- re-create the players
			model.player_O.make (player2, "O")
			model.set_turn(model.player_X)					-- reset the turn
			model.board.make								-- make the board
			model.reset_scores								-- reset the score
			model.set_output_status ("ok: => " + model.turn.name + " plays next")
			model.set_game_state(true)						-- set game_state to true (game is running)
		end
	end

	undo
	do
		if model.game_state = false then					-- set prev output, before a game starts or after it has ended
			model.set_output_status(prev_state)
		elseif model.game_state and incorrect_input then	-- for incorrect input during the game (running)
			model.set_output_status(prev_state)
		else
			model.set_output_status ("ok: => " + model.turn.name + " plays next")
		end
	end

	redo do execute end

feature -- attributes
	incorrect_input: BOOLEAN
	do
		Result := model.output_status.has_substring ("names of players must be different")
			or model.output_status.has_substring ("name must start with A-Z or a-z")
	end
end
