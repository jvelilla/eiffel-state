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
			build_sd_start_new_game
			state := First_turn_cross
		end

feature {NONE} -- Automaton
	build_sd_start_new_game is
			-- Build `sd_start_new_game'
		do
			create sd_start_new_game.make (2)
			sd_start_new_game.add_behavior (First_turn_cross,
				agent otherwise,
				agent do create current_game.make_first_cross end,
				First_turn_circle)
			sd_start_new_game.add_behavior (First_turn_circle,
				agent otherwise,
				agent do create current_game.make_first_circle end,
				First_turn_cross)
		end
end
