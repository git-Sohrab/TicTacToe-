note
	description: "A Player class."
	author: "S Oryakhel"
	date: "$Date$"
	revision: "$Revision$"

class PLAYER inherit ANY redefine out end

create make

feature
	make(player_name: STRING; sym: STRING)
	do
		set_name(player_name)
		set_symbol(sym)
	end

feature -- attributes
	name: STRING												-- name of a player
	symbol: STRING												-- symbol of a player (X or O)
	score: INTEGER												-- score of a player

feature -- commands
	set_name(n: STRING) do name := n end
	set_symbol(sym: STRING) do symbol := sym end
	update_score do score := score + 1 end
	reset_score do score := 0 end

feature -- queries
	out : STRING
		do
			create Result.make_from_string ("  ")
			Result.append (score.out + ":" + " score for ")
			Result.append_character ('%"')
			Result.append (name)
			Result.append_character ('%"')
			Result.append (" (as " + symbol+ ")")
		end
end
