note
	description: "Barracks that train soldiers."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BARRACK

inherit
	BUILDING

create {WORKER}
	make

feature -- Access
	type: STRING is "Barrack"

	creation_time: DOUBLE is 30.0

	actions: LIST [ACTION [TUPLE]] is
		do
			Result := create {LINKED_LIST [ACTION [TUPLE]]}.make
			Result.extend (create {ACTION [TUPLE]}.make (agent train_soldier, "train soldier"))
		end

	last_trained_soldier: SOLDIER

feature -- Basic operations
	train_soldier is
		do
			create last_trained_soldier.make (position, team_name)
			io.put_string (last_trained_soldier.out + " was trained%N")
		end

end
