indexing
	description: "Game managers that let the winner of the previous game do the first turn and change the first player in case of draw."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WINNER_FIRST_MANAGER

inherit
	GAME_MANAGER
		redefine
			default_create
		end

feature -- Initialization
	default_create is
			-- Create a manager with first turn cross
		do
			state := First_turn_cross
		end

feature -- State dependent: basic operations
	start_new_game is
			-- Start a new game
		do
			if state = First_turn_cross then
				if current_game /= Void and then current_game.cross_won then
					create current_game.make_first_cross
					state := First_turn_circle
				elseif current_game /= Void and then current_game.circle_won then
					create current_game.make_first_circle
					state := First_turn_cross
				else
					create current_game.make_first_cross
					state := First_turn_circle
				end
			else
				if current_game /= Void and then current_game.cross_won then
					create current_game.make_first_cross
					state := First_turn_circle
				elseif current_game /= Void and then current_game.circle_won then
					create current_game.make_first_circle
					state := First_turn_cross
				else
					create current_game.make_first_circle
					state := First_turn_cross
				end
			end
		end
end
