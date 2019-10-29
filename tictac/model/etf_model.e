note
	description: "A default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MODEL

inherit ANY redefine out end

create {ETF_MODEL_ACCESS}
	make

feature {NONE} -- Initialization
	make
			-- Initialization for `Current'.
		do
			create s.make_empty
			i := 0

			create command_manager.make
			create player_X.make ("", "X")
			create player_O.make ("", "O")
			set_turn(player_X)
			create board.make
			starting_player := player_X

			create output_status.make_from_string ("ok:  => start new game")
		end

feature -- model attributes
	s : STRING
	i : INTEGER

	command_manager: OPERATION_MANAGER									-- mamanger of the commands/operations
	player_X: PLAYER													-- player X
	player_O: PLAYER													-- player O
	turn: PLAYER														-- turn of the player
	board: BOARD														-- game board
	output_status: STRING												-- output string
	game_state: BOOLEAN													-- game state is true for running and false for not.
	starting_player: PLAYER												-- starting player turn. If A starts first game, B starts next and vice versa.

feature -- model operations
	default_update
			-- Perform update to the model state.
		do
			i := i + 1
		end

	reset
			-- Reset model state.
		do
			make
		end
feature -- OPERATIONS
	-- new_game command
	new_game(player1: STRING; player2: STRING)
	do
		-- create an instance of the command and pass it on to the manager
		command_manager.execute_command (create {NEW_GAME}.make(current, player1, player2))
	end

	-- play() command
	play(name: STRING; cell: INTEGER)
	do
		-- create an instance of the command and pass it on to the manager
		command_manager.execute_command (create {PLAY}.make (current, name, cell))
		update_game_state
	end

	-- play_again command
	play_again
	do
		-- create an instance of the command and pass it on to the manager
		command_manager.execute_command (create {PLAY_AGAIN}.make (current))
	end

	--undo command
	undo do command_manager.undo end

	-- redo command
	redo do command_manager.redo end

feature -- model commands 

	set_output_status(op: STRING) do output_status := op end

	set_game_state(gs: BOOLEAN) do game_state := gs end

	set_turn(player:PLAYER) do turn := player end

	set_starting_player(sp: PLAYER) do starting_player := sp end

	clear_history do command_manager.clear_lists end

	update_game_state
	do
		if board.is_board_filled or else board.is_there_winner then
			set_game_state(false)
		end
	end

	update_score
	do
		if board.is_player_x_winner then
			player_X.update_score
		elseif board.is_player_o_winner then
			player_O.update_score
		end
	end

	reset_scores
	do
		player_X.reset_score
		player_O.reset_score
	end

feature -- queries
	is_undo_available: BOOLEAN do Result := command_manager.undo_list.count > 0 end
	is_redo_available: BOOLEAN do Result := command_manager.redo_list.count > 0 end

	out : STRING
		do
			create Result.make_from_string ("  ")
			Result.append (output_status)
			Result.append_character ('%N')
			Result.append (board.out)
			Result.append_character ('%N')
			Result.append (player_X.out)
			Result.append_character ('%N')
			Result.append (player_O.out)
		end
end




