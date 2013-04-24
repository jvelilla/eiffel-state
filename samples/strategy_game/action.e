note
	description: "Actions can be completed by units in the game."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ACTION [ARGS -> TUPLE]

inherit
	ANY
		rename
			is_equal as any_is_equal
		redefine
			out
		select
			out
		end
	COMPARABLE
		rename
			out as comp_out
		select
			is_equal
		end

create
	make

feature -- Access
	out: STRING is
			-- String identifier
		do
			Result := type
		end

	hash_code: INTEGER is
			-- Hash code
		do
			Result := type.hash_code
		end

	infix "<" (other: ACTION [TUPLE]): BOOLEAN is
			-- Compares two actions
		local
			index: INTEGER
			counted: BOOLEAN
		do
			counted := False
			from
				index := 1
			until
				index > type.count or index > other.type.count
			loop
				if (not counted) then
					if (type.code (index) < other.type.code (index)) then
						Result := True
						counted := True
					elseif (type.code (index) > other.type.code (index)) then
						Result := False
						counted := True
					end
				end
				index := index + 1
			end
			if (not counted) then
				Result := type.count < other.type.count
			end
--			io.put_string (type)
--			if (Result) then
--				io.put_string ("<")
--			else
--				io.put_string (">=")
--			end
--			io.put_string (other.type)
--			io.put_new_line
--		do
--			Result := type < other.type
		end

feature -- Basic operations
	complete (target: ANY; args: ARGS) is
			-- Complete given action
		do
			proc.set_target (target)
			proc.call (args)
		end


feature -- Initialization
	make (p: PROCEDURE [ANY, ARGS]; action_type: STRING) is
			-- Create action with given name and behavior
		do
			proc := p
			type := action_type
		end


feature {ACTION} -- Implementation
	proc: PROCEDURE [ANY, ARGS]
	type: STRING

invariant
	--procedure_set: proc /= Void
	not_empty_type: not type.is_empty

end
