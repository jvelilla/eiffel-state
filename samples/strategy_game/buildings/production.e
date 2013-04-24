note
	description: "Buildings that produce resources."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PRODUCTION

inherit
	BUILDING
	   	redefine
    		actions
    	end

feature -- Access

	actions: LIST [ACTION [TUPLE]] is
		do
			Result := create {LINKED_LIST [ACTION [TUPLE]]}.make
		end

feature -- Basic operations
	produce: RESOURCE is
			-- Produce resource
		deferred
		end

end
