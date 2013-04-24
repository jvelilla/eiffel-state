note
	description: "Doctor can heal other beings."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DOCTOR

inherit
	BEING
	   	redefine
    		actions
    	end

create
	make

feature -- Access
	type: STRING is "Doctor"

	creation_time: DOUBLE is 3.0
			-- Hero training time

	maximum_movement_speed: DOUBLE is 2.0

	actions: LIST [ACTION [TUPLE]] is
		do
			Result := Precursor {BEING}
			Result.extend (create {ACTION [TUPLE [BEING]]}.make (agent heal, "heal"))
		end

feature -- Basic operations
	heal (b: BEING) is
			-- Heal some BEING
		do
			io.put_string (out + " is healing " + b.out + "%N")
			b.improve_health
		end

end
