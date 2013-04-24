note
	description: "Soldiers."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SOLDIER

inherit
	ARMY_BEING

create
	make

feature -- Access
	type: STRING is "Soldier"

	creation_time: DOUBLE is 20.0
			-- Soldier training time

	maximum_movement_speed: DOUBLE is 1.0

	maximum_accuracy: DOUBLE is 0.4

end
