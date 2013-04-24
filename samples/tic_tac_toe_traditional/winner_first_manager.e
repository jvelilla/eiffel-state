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
		end

feature -- basic operations
	start_new_game is
			-- Start a new game
		do
			if current_game /= Void then
				if current_game.circle_won then
					create current_game.make_first_circle
				elseif current_game.cross_won then
					create current_game.make_first_cross
				else
					create current_game.make_first_cross
				end
			else
				create current_game.make_first_cross
			end
		end
end
