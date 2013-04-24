note
	description: "Resources that can be collected and traded"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	RESOURCE

feature -- Access

	creation_time: DOUBLE is
			-- Time required to produce resource
		deferred
		end

	type: STRING is
			-- Type of resource
		deferred
		end

end
