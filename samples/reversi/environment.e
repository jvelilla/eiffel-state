indexing
	description: "Class which stores links to important managers"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ENVIRONMENT

feature -- Access
	gui_manager: GUI_MANAGER is
		once
			create Result.default_create
		end

	game_manager: GAME_MANAGER is
		once
			create Result.default_create
		end

	true_agent: BOOLEAN is
			-- Function which returns true always
		once
			Result := True
		end

	trivial_agent (arg: BOOLEAN): BOOLEAN is
			-- Returns input
		do
			Result := arg
		end

	opposite_agent (arg: BOOLEAN): BOOLEAN is
		do
			Result := not arg
		end

end
