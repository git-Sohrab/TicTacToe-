note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_REDO
inherit
	ETF_REDO_INTERFACE
		redefine redo end
create
	make
feature -- command
	redo
    	do
  			if model.game_state = false then
				if not model.board.is_board_filled and not model.board.is_there_winner then
					model.set_output_status ("ok:  => start new game")
				end
			else
				if model.is_redo_available then
					model.redo
				else
					model.set_output_status ("ok: => " + model.turn.name + " plays next")
				end
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
