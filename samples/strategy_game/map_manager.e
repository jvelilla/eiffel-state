note
	description: "This class manages map and positions on it."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MAP_MANAGER

inherit
	ENVIRONMENT

create
	default_create

feature -- Access
	Cell_size: INTEGER
			-- Size of every relief cell

	width: INTEGER is 20
		-- Width of `current_game_map'

	height: INTEGER is 20
		-- Height of `current_game_map'

	maps_number: INTEGER is
		do
			Result := maps.count
		end

	position_at (x, y: INTEGER): POSITION is
			-- `POSITION' object, which corresponds to (x, y) point in the window
		do
			Result := position (x // Cell_size, y // Cell_size)
		end


	position (x, y: INTEGER): POSITION is
			-- Returns `POSITION' object, which contains (x, y) relief
		require
			coordinates_in_bounds: x >= 0 and x < width and y >= 0 and y < height
		do
			Result := current_game_map.relief @ x @ y
		ensure
			Result /= Void
		end

	position_of_relief (relief_type: INTEGER): POSITION is
			-- Returns first position with `relief_type' relief
		local
			i, j: INTEGER
			p: POSITION
		do
			from
				i := 0
				j := 0
			until
				i >= width or Result /= Void
			loop
				p := position (i, j)
				if (p.relief_name(relief_type).is_equal (p.relief)) then
					Result := p
				end
				j := j + 1
				if (j >= height) then
					j := 0
					i := i + 1
				end
			end
		end

	cell_center_coordinates (p: POSITION): ARRAY [INTEGER]
			-- x and y coordinates of center of given `p'
		do
			Result := <<p.x * Cell_size + Cell_size // 2, p.y * Cell_size + Cell_size // 2>>
		end

feature -- Basic operations
	draw_map_rect_part (x, y: INTEGER_INTERVAL) is
			-- Draws rectangle part of the map in the window using `drawable'
		local
			i, j: INTEGER
		do
			from
				i := x.lower
				j := y.lower
			until
				i = x.upper + 1
			loop
				draw_cell (i, j)
				j := j + 1
				if (j = y.upper + 1) then
					j := y.lower
					i := i + 1
				end
			end
		end

	draw_cell_at_position (p: POSITION) is
		do
			draw_cell (p.x, p.y)
		end


	draw_cell (x, y: INTEGER) is
			-- Draws one given cell
		local
			color: EV_COLOR
		do
			color := position (x, y).color
			gui_manager.drawable_widget.set_foreground_color (color)
			gui_manager.drawable_widget.fill_rectangle (x * Cell_size, y * Cell_size, Cell_size, Cell_size)
		end


	draw_map is
			-- Draws the whole map
		do
			draw_map_rect_part (create {INTEGER_INTERVAL}.make (0, width - 1), create {INTEGER_INTERVAL}.make (0, height - 1))
		end

	set_game_map (index: INTEGER) is
			-- Choose game map by index
		require
			proper_index: index >= 1 and index <= maps_number
		do
			current_game_map := maps @ index
		ensure
			current_game_map /= Void
		end


feature {NONE} -- Initialization
	default_create is
			-- Initialize map relief
		do
			Cell_size := 30
			create maps.make (1, 3)
			maps.put (create {MAP}.create_random (1), 1)
			maps.put (create {MAP}.create_random (2), 2)
			maps.put (create {MAP}.choose_prepared, 3)
		end

feature {NONE} -- Implementation
	maps: ARRAY[MAP]
		-- Maps which can be used in game

	current_game_map: MAP
		-- Map for current game
end
