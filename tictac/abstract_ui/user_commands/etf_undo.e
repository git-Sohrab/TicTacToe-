note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_UNDO
inherit
	ETF_UNDO_INTERFACE
		redefine undo end
create
	make
feature -- command
	undo
    	do
			if model.game_state = false then
				if not model.board.is_board_filled and not model.board.is_there_winner then
					model.set_output_status ("ok:  => start new game")
				end
			else
				if model.is_undo_available then
					model.undo
				else
					model.set_output_status ("ok: => " + model.turn.name + " plays next")
				end
			end
			etf_cmd_container.on_change.notify ([Current])
    	end
end
