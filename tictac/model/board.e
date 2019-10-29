note
	description: "A Board class representing the tictactoe board."
	author: "S Oryakhel"
	date: "$Date$"
	revision: "$Revision$"

class BOARD inherit ANY redefine out end

create
	make

feature
	make do create spaces.make_filled ("_", 1, 9) end

feature -- attributes
	spaces: ARRAY[STRING]					-- the board is represented by single dimensional array

feature -- queries

	-- does space contain a X
	is_space_X(cell: INTEGER): BOOLEAN do Result :=	 spaces.at (cell) ~ "X" end
	-- does space contain a O
	is_space_O(cell: INTEGER): BOOLEAN do Result :=	 spaces.at (cell) ~ "O" end

	is_space_empty(cell: INTEGER): BOOLEAN do Result := spaces.at (cell) ~ "_" end

	is_there_winner: BOOLEAN do Result := is_player_X_winner or else is_player_O_winner end

	is_player_X_winner: BOOLEAN
	do
		----------------------- if player_X won
		------------ rows
		if spaces[1] ~ "X" and spaces[2] ~ "X" and spaces[3] ~ "X"  then
			Result := true
		elseif spaces[4] ~ "X" and spaces[5] ~ "X" and spaces[6] ~ "X" then
			Result := true
		elseif spaces[7] ~ "X" and spaces[8] ~ "X" and spaces[9] ~ "X" then
			Result := true
		------------ columns
		elseif spaces[1] ~ "X" and spaces[4] ~ "X" and spaces[7] ~ "X" then
			Result := true
		elseif spaces[2] ~ "X" and spaces[5] ~ "X" and spaces[8] ~ "X" then
			Result := true
		elseif spaces[3] ~ "X" and spaces[6] ~ "X" and spaces[9] ~ "X" then
			Result := true
		------------ diagonals
		elseif spaces[1] ~ "X" and spaces[5] ~ "X" and spaces[9] ~ "X" then
			Result := true
		elseif spaces[3] ~ "X" and spaces[5] ~ "X" and spaces[7] ~ "X" then
			Result := true
		else
			Result := false
		end
	end

	is_player_O_winner: BOOLEAN
	do
		----------------------- if player_O won
		------------ rows
		if spaces[1] ~ "O" and spaces[2] ~ "O" and spaces[3] ~ "O"  then
			Result := true
		elseif spaces[4] ~ "O" and spaces[5] ~ "O" and spaces[6] ~ "O" then
			Result := true
		elseif spaces[7] ~ "O" and spaces[8] ~ "O" and spaces[9] ~ "O" then
			Result := true
		------------ columns
		elseif spaces[1] ~ "O" and spaces[4] ~ "O" and spaces[7] ~ "O" then
			Result := true
		elseif spaces[2] ~ "O" and spaces[5] ~ "O" and spaces[8] ~ "O" then
			Result := true
		elseif spaces[3] ~ "O" and spaces[6] ~ "O" and spaces[9] ~ "O" then
			Result := true
		------------ diagonals
		elseif spaces[1] ~ "O" and spaces[5] ~ "O" and spaces[9] ~ "O" then
			Result := true
		elseif spaces[3] ~ "O" and spaces[5] ~ "O" and spaces[7] ~ "O" then
			Result := true
		else
			Result := false
		end
	end

	-- iterate through the board and check if all the cells are taken
	is_board_filled: BOOLEAN
	local
		i: INTEGER
	do
		Result := true
		from i := 1 until i > 9 loop
			if spaces.at (i) ~ "_" then
				Result := false
			end
			i := i + 1
		end
	end

	out : STRING
		do
			create Result.make_from_string ("  ")
			Result.append (spaces[1]+spaces[2]+spaces[3])
			Result.append_character ('%N')
			Result.append ("  " + spaces[4]+spaces[5]+spaces[6])
			Result.append_character ('%N')
			Result.append ("  " + spaces[7]+spaces[8]+spaces[9])
		end
end
