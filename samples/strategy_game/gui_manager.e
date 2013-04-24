note
	description: "GUI manager react to user's actions."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GUI_MANAGER

inherit
	AUTOMATED
		rename
			state as user_state
		redefine
			default_create
		select
			default_create
		end
	ENVIRONMENT

create
	default_create

feature -- Access
	drawable_widget: EV_DRAWING_AREA

	show_window is
			-- Shows main window on the screen and draws map and units on it
		do
			main_window.show
			draw_all (0, 0, 0, 0)
		end

feature {NONE} -- Initialization
	default_create is
			-- Initialize `main_window'
		local
			map_index: INTEGER
		do
			create drawable_widget
			drawable_widget.pointer_button_press_actions.extend (agent widget_button_press)
			drawable_widget.pointer_motion_actions.extend (agent widget_motion)
			drawable_widget.pointer_button_release_actions.extend (agent widget_button_release)
			drawable_widget.expose_actions.extend (agent draw_all)

			map_index := (create {TIME}.make_now).compact_time \\ map_manager.maps_number + 1
			io.put_string ("Map with number " + map_index.out + " was selected%N")
			map_manager.set_game_map (map_index)

			create main_window.make (
				map_manager.width * map_manager.Cell_size + horizontal_border_thickness,
				map_manager.height * map_manager.Cell_size + vertical_border_thickness,
				drawable_widget
			)

			user_state := Watching
		end

feature {NONE} -- Implementation

	draw_all (arg1, arg2, arg3, arg4: INTEGER) is
			-- Draws map and units on it, 4 arguments are for function `expose_actions'
		do
			map_manager.draw_map
			draw_units
			draw
		end

	draw_units is
			-- Draws all units using `drawable_widget'
			-- Implemented by iteration over units list `LINKED_LIST [UNITS]'
		do
			from
				unit_manager.all_units.start
			until
				unit_manager.all_units.after
			loop
				unit_manager.all_units.item.draw
				unit_manager.all_units.forth
			end
		end

	draw is
			-- Draws selecting rectangle and units under it
		local
			x, y: INTEGER_INTERVAL
			press, cur: POSITION
				-- Absolute mouse press and current positions
		do
			sd_delete_selecting_frame.call ([], user_state)

			if (user_state = Started_selecting_units or user_state = Selecting_units) then
				press := map_manager.position_at (mouse_press_x, mouse_press_y)
				cur := map_manager.position_at (mouse_x, mouse_y)
				create x.make (press.x.min (cur.x), press.x.max (cur.x))
				create y.make (press.y.min (cur.y), press.y.max (cur.y))
				selected_units := unit_manager.select_units (x, y)

				drawable_widget.set_xor_mode
				draw_choosing_frame (mouse_x, mouse_y)
			end
		end

	delete_selecting_frame is
			-- Delete previously drawn selecting frame
		do
			if (user_state = Selecting_units or user_state = Finished_selecting_units) then
				draw_choosing_frame (prev_mouse_x, prev_mouse_y)
				drawable_widget.set_copy_mode
			end
		end


	draw_choosing_frame (mx, my: INTEGER) is
			-- Draw frame when user is selecting units.
			-- mx = mouse coordinate x
			-- my = mouse coordinate y
		do
			drawable_widget.set_foreground_color (create {EV_COLOR}.make_with_rgb (1, 1, 1))
			drawable_widget.draw_rectangle (
				mouse_press_x.min (mx),
				mouse_press_y.min (my),
				(mouse_press_x - mx).abs,
				(mouse_press_y - my).abs
			)
		end


	main_window: MAIN_WINDOW

	horizontal_border_thickness: INTEGER is 11
	vertical_border_thickness: INTEGER is 33
			-- Borders' thickness which are used in setting window dimension
			-- TODO: delete this code and try to set native width and height

	widget_button_press (x, y, button: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; screen_x, screen_y: INTEGER) is
			-- A pointer button press event has occurred on the test widget
		local
			being: BEING
			moved: BOOLEAN
		do
--			io.put_integer (button)
			if (button = 1) then
				user_state := Started_selecting_units
				save_mouse_coordinates (x, y)
				mouse_press_x := x
				mouse_press_y := y
				draw
				user_state := Selecting_units
			elseif (button = 3 and not selected_units.is_empty) then
				moved := False
				from
					selected_units.start
				until
					selected_units.after
				loop
					being ?= selected_units.item
					if (being /= Void and map_manager.position_at (x, y).passable) then
						being.move (map_manager.position_at (x, y))
						moved := True
					end
					selected_units.forth
				end
				if (moved) then
					draw_all (0, 0, 0, 0)
				end
				user_state := Watching
			end
		end

	widget_motion (x, y: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; screen_x, screen_y: INTEGER) is
			-- A pointer button press event has occurred on the test widget
		do
			if (user_state = Selecting_units) then
				save_mouse_coordinates (x, y)
				draw
			end
		end

	widget_button_release (x, y, button: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; screen_x, screen_y: INTEGER) is
			-- A pointer button release event has occurred on the test widget
		local
			actions: LINEAR [STRING]
		do
			if (user_state = Selecting_units) then
				user_state := Finished_selecting_units
				save_mouse_coordinates (x, y)
				draw
				user_state := Choosing_action
				from
					actions := unit_manager.available_actions (selected_units)
					actions.start
				until
					actions.after
				loop
					io.put_string (actions.item)
					io.put_new_line
					actions.forth
				end
--				user_state := Watching
			end
		end

	save_mouse_coordinates (x, y: INTEGER) is
		do
			prev_mouse_x := mouse_x
			mouse_x := x
			prev_mouse_y := mouse_y
			mouse_y := y
		end

	mouse_press_x: INTEGER
	mouse_press_y: INTEGER
	mouse_x: INTEGER
	mouse_y: INTEGER
	prev_mouse_x: INTEGER
	prev_mouse_y: INTEGER

	selected_units: LINEAR [UNIT]

feature {NONE} -- Implementation: States
	Watching: STATE is once create Result.make ("Watching") end
	Started_selecting_units: STATE is once create Result.make ("Started_selecting_units") end
	Selecting_units: STATE is once create Result.make ("Selecting_units") end
	Finished_selecting_units: STATE is once create Result.make ("Finished_selecting_units") end
	Choosing_action : STATE is once create Result.make ("Choosing action") end

	sd_delete_selecting_frame: STATE_DEPENDENT_PROCEDURE [TUPLE] is
			-- Deletes selecting frame if `user_state' is either `Selecting_units' or `Finished_selecting_units'
		do
			create Result.make (5)
			Result.add_behavior (Watching, agent true_agent, agent do_nothing, Watching)
			Result.add_behavior (Started_selecting_units, agent true_agent, agent do_nothing, Started_selecting_units)
			Result.add_behavior (Selecting_units, agent true_agent, agent delete_selecting_frame, Selecting_units)
			Result.add_behavior (Finished_selecting_units, agent true_agent, agent delete_selecting_frame, Finished_selecting_units)
			Result.add_behavior (Choosing_action, agent true_agent, agent do_nothing, Choosing_action)
		end

invariant
	main_window /= Void
end
