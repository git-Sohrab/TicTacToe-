note
	description: "This is a class representing a play_again operation."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class PLAY inherit OPERATION redefine execute, undo, redo end

create make

feature -- creation
	make(mdl: ETF_MODEL; player: STRING; number: INTEGER)
	do
		model := mdl
		name := player
		cell := number
		prev_val := model.board.spaces.at (cell)
		prev_turn := model.turn
	end

feature -- attributes
	model: ETF_MODEL								-- an instance of model
	name: STRING									-- name of player running play command
	cell: INTEGER									-- the cell number for the board
	prev_val: STRING
	prev_turn: PLAYER

feature -- commands
	execute
	do
		-- incorrect name
		if model.player_X.name /~ name and model.player_O.name /~ name then
			-- before the game starts
			if model.game_state = false and not model.board.is_board_filled and not model.board.is_there_winner then
				model.set_output_status("no such player:  => start new game")
			-- after the game has ended
--			elseif model.game_state = false and model.board.is_board_filled or model.board.is_there_winner then
--				model.set_output_status("no such player:  => play again or start new game")
			-- during the game
			else
				model.set_output_status("no such player:  => " + model.turn.name + " plays next")
			end
		-- wrong turn during game
		elseif model.turn.name /~ name and model.game_state then
			model.set_output_status("not this player's turn: => " + model.turn.name + " plays next")
		-- cell not available
		elseif not model.board.is_space_empty (cell) and model.game_state then
			model.set_output_status("button already taken: => " + model.turn.name + " plays next")
		-- after game has ended
		elseif model.game_state = false and (model.board.is_board_filled or model.board.is_there_winner) then
			model.set_output_status("game is finished: => play again or start new game")
		else
			if model.turn = model.player_X then
				model.board.spaces.put (model.turn.symbol, cell)
				model.set_turn(model.player_O)
			elseif model.turn = model.player_O then
				model.board.spaces.put (model.turn.symbol, cell)
				model.set_turn(model.player_X)
			end
			model.update_score
			set_model_status
		end
	end

	undo
	do
		-- before game starts
		if model.game_state = false and not model.board.is_board_filled and not model.board.is_there_winner then
			model.set_output_status("ok:  => start new game")
		end
		if model.game_state = true then
			model.board.spaces.put (prev_val, cell)
			model.set_turn(prev_turn)
			set_model_status
		end
	end

	redo
	do
		-- before game starts
		if model.game_state = false and not model.board.is_board_filled and not model.board.is_there_winner then
			model.set_output_status("ok:  => start new game")
		end
		if model.game_state = true then execute end
	end

	set_model_status 							-- set the output status of model based on conditions of the game 
	do
		if model.board.is_there_winner then
			model.set_output_status("there is a winner: => play again or start new game")
		elseif model.board.is_board_filled then
			model.set_output_status("game ended in a tie: => play again or start new game")
		else
			model.set_output_status("ok: => " + model.turn.name + " plays next")
		end
	end
end


