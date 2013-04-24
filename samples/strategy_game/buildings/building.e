note
	description: "Deferred class for all buildings."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	BUILDING

inherit
	UNIT
		rename
			is_healthy as is_repaired,
			improve_health as repair
		end

end
