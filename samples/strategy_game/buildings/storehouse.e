note
	description: "Resources are stored in storehouse."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STOREHOUSE

inherit
	BUILDING
		redefine
			make
		end

create
	make

feature -- Access
	amount: INTEGER is
			-- Resources amount in the storehouse
		do
			Result := resources.count
		end

	type: STRING is "Storehouse"

	creation_time: DOUBLE is 10.0

	actions: LIST [ACTION [TUPLE]] is
		do
			Result := create {LINKED_LIST [ACTION [TUPLE]]}.make
		end

feature -- Basic operations
	deliver (resource: RESOURCE) is
			-- Store delivered resource
		do
			resources.extend (resource)
		end


feature -- Initialization
	make (p: POSITION; team: STRING) is
			-- Creates empty storehouse
		do
			Precursor {BUILDING} (p, team)
			resources := create {LINKED_LIST [RESOURCE]}.make
		end

feature {NONE} -- Implementation
	resources: LIST [RESOURCE]

invariant
	resources_set: resources /= Void

end
