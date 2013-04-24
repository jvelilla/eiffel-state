indexing
	description: "Managers that may start games, collect statistics, etc."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	GAME_MANAGER

feature -- Access
	current_game: GAME

feature -- Basic operations
	start_new_game is
			-- Start a new game
		deferred
		ensure
			current_game_exists: current_game /= Void
		end

end
