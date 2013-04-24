indexing
	description: "Game managers that let players to take first turn interchangeably."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	INTERCHANGE_MANAGER

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
				create current_game.make_first_cross
				state := First_turn_circle
			else
				create current_game.make_first_circle
				state := First_turn_cross
			end
		end
end
