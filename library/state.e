note
	description: "Named control states."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STATE

inherit
	HASHABLE

create
	make

feature -- Initialization
	make (s: STRING)
			-- Create a state with name `s'
		require
			s_exists: s /= Void
			s_non_empty: not s.is_empty
		do
			name := s
		ensure
			name_set: name = s
		end

feature -- Access
	name: STRING
			-- Name

	hash_code: INTEGER 
			-- Hash code
		do
			Result := name.hash_code
		end
end
