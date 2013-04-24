note
	description: "Summary description for {ENVIRONMENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ENVIRONMENT

inherit
	ANY
		rename
			default_create as env_create
		end

feature -- Access
	gui_manager: GUI_MANAGER is
		once
			create Result.default_create
		end

	map_manager: MAP_MANAGER is
		once
			create Result.default_create
		end

	unit_manager: UNIT_MANAGER is
		once
			create Result.default_create
		end

	true_agent: BOOLEAN is
			-- Function which returns true always
		once
			Result := True
		end

	unit_id_counter: INTEGER
			-- Counter for units IDs

end
