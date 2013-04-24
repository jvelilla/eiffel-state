note
	description: "Game map."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MAP

create
	create_random,
	choose_prepared

feature -- Initialization
	create_random (seed: INTEGER) is
			-- Creates random map using pseudo-random generator
		local
			i, j: INTEGER
			relief_generator: RANDOM
			cur_arr: ARRAY [POSITION]
			pos: POSITION
			cur_relief: INTEGER
		do
			create relief_generator.make
			cur_relief := seed
			create relief.make (0, {MAP_MANAGER}.width - 1)
			from
				i := 0
			until
				i >= {MAP_MANAGER}.width
			loop
				create cur_arr.make (0, {MAP_MANAGER}.height - 1)
				relief.put (cur_arr, i)
				from
					j := 0
				until
					j >= {MAP_MANAGER}.height
				loop
					cur_relief := relief_generator.next_random (cur_relief)
					create pos.make (i, j, cur_relief \\ {POSITION}.relief_types + 1)
					cur_arr.put (pos, j)
					j := j + 1
				end
				i := i + 1
			end
		end

	choose_prepared is
			-- Choose prepared map to play on
		local
			i, j: INTEGER
			cur_arr: ARRAY [POSITION]
			pos: POSITION
			cur_relief: INTEGER
		do
			create relief.make (0, {MAP_MANAGER}.width - 1)
			from
				i := 0
			until
				i >= {MAP_MANAGER}.width
			loop
				create cur_arr.make (0, {MAP_MANAGER}.height - 1)
				relief.put (cur_arr, i)
				from
					j := 0
				until
					j >= {MAP_MANAGER}.height
				loop
					cur_relief := (map1 @ (i + 1)).item (j + 1).code - ('0').code
					create pos.make (i, j, cur_relief)
					cur_arr.put (pos, j)
					j := j + 1
				end
				i := i + 1
			end
		end


feature {MAP_MANAGER} -- Implementation
	relief: ARRAY [ARRAY [POSITION]]

feature {NONE} -- Implementation
	map1: ARRAY [STRING] is
			-- Encoded map
		once
			Result := <<
				"11111111222222222222",
				"11111111122222222222",
				"11111111122222222222",
				"11111111112222222223",
				"11111111112222222333",
				"11111111113333333333",
				"11111111113333333333",
				"22222222222333333333",
				"22222222222333333333",
				"22222222222222222222",
				"22222222222222222222",
				"22222222222222222225",
				"22222222222222222255",
				"22222222222222225555",
				"22222244444444225555",
				"22222224444444225555",
				"22222224444442222555",
				"22222224444442222555",
				"22222224444442222225",
				"22222222222222222222"
			>>
		end

end
