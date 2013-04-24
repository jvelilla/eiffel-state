note
	description: "Raw lumber after tree has been cut"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FELLED_TREE

inherit
	RESOURCE

feature -- Access
	creation_time: DOUBLE is 1.0

	type: STRING is "felled tree"

end
