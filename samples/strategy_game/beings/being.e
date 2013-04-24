note
	description: "Living beings that can move."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	BEING

inherit
	UNIT
    	redefine
    		actions
    	end


feature -- Access
	maximum_movement_speed: DOUBLE is
		deferred
		end

	actions: LIST [ACTION [TUPLE]] is
		do
			Result := create {LINKED_LIST [ACTION [TUPLE]]}.make
			Result.extend (create {ACTION [TUPLE [POSITION]]}.make (agent move, "move") )
		end

feature -- State dependent: Access
	movement_speed: DOUBLE is
			-- Movement speed according to hp level
		do
			Result := maximum_movement_speed * sd_ability_reduction.item ([], health_state)
		end

feature -- Element change
	move (new_position: POSITION) is
			-- Time which is taken by changing `position' to `new_position'
		do
			position := new_position
		end
end
