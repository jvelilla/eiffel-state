indexing
	description: "GUI manager."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GUI_MANAGER
inherit
	AUTOMATED
		redefine
			default_create
		end
	ENVIRONMENT
		undefine
			default_create
		end

create
	default_create

feature -- Access
	background: EV_COLOR is
		do
			create Result.make_with_rgb (0.2, 0.8, 0.2)
		end

	lighter_background: EV_COLOR is
			-- Color which is slightly lighter then background
		do
			create Result.make_with_rgb (0.25, 1, 0.25)
		end

	darker_background: EV_COLOR is
			-- Color which is slightly darker then background
		do
			create Result.make_with_rgb (0.15, 0.6, 0.15)
		end

	cell_size: INTEGER is
		do
			Result := field_size // game_manager.dimension
		end

	drawable_widget: EV_DRAWING_AREA

feature -- Status setting
	set_status (text: STRING)
		require
			text /= Void
		do
			first_window.set_status_bar_text (text)
		end

	show_message (msg: STRING) is
		require
			msg /= Void
		local
			dialog: EV_INFORMATION_DIALOG
		do
			create dialog.make_with_text (msg)
			dialog.show_modal_to_window (first_window)
		end

	show_first_window is
		do
			first_window.show
		end

	draw (arg1, arg2, arg3, arg4: INTEGER) is
			-- Draw field and all markers on it
		local
			i, j: INTEGER
			ch: CHARACTER
			font_for_text: EV_FONT
		do
			-- Background
			field_size := (first_window.width - right_shift).min (first_window.height - lower_shift) * 2 * game_manager.dimension // (2 * game_manager.dimension + 1)
			field_size := field_size // game_manager.dimension * game_manager.dimension -- To make size divisible by dimension

			drawable_widget.set_foreground_color (background)
			drawable_widget.fill_rectangle (0, 0, first_window.width, first_window.height)
			drawable_widget.set_foreground_color (create {EV_COLOR}.make_with_rgb (0, 0, 0))

			-- Grid
			from
				i := 0
			until
				i = game_manager.dimension + 1
			loop
				drawable_widget.draw_segment (i * cell_size, 0, i * cell_size, field_size)
				drawable_widget.draw_segment (0, i * cell_size, field_size, i * cell_size)
				i := i + 1
			end

			-- Rows and columns titles
			create font_for_text.default_create
			font_for_text.set_height (cell_size // 3)
			drawable_widget.set_font (font_for_text)
			from
				i := 1
			until
				i = game_manager.dimension + 1
			loop
				drawable_widget.draw_text_top_left (field_size + (cell_size // 2 - font_for_text.string_size (i.out).integer_item (1)) // 2,
						(game_manager.dimension - i) * cell_size + (cell_size - font_for_text.string_size (i.out).integer_item (2)) // 2, i.out)
				i := i + 1
			end

			from
				i := 0
				ch := 'A'
			until
				ch = 'A' + game_manager.dimension
			loop
				drawable_widget.draw_text_top_left (i * cell_size + (cell_size - font_for_text.string_size (ch.out).integer_item (1)) // 2,
						field_size + (cell_size // 2 - font_for_text.string_size (ch.out).integer_item (2)) // 2, ch.out)
				i := i + 1
				ch := ch + 1
			end

			-- Markers
			from
				i := 0
			until
				i = game_manager.markers.count
			loop
				from
					j := 0
				until
					j = game_manager.markers.item (i).count
				loop
					game_manager.markers.item (i).item (j).draw
					j := j + 1
				end
				i := i + 1
			end
		end

feature {NONE} -- Initialization
	default_create is
			-- Prepare the first window to be displayed.
		do
			create drawable_widget

			drawable_widget.pointer_button_press_actions.extend (agent widget_button_press)

			drawable_widget.expose_actions.extend (agent draw)

				-- create and initialize the first window.
			field_size := 400
			create first_window.make (field_size + cell_size // 2 + right_shift, field_size + cell_size // 2 + lower_shift, drawable_widget)
			first_window.resize_actions.extend (agent draw)
		end

feature {NONE} -- Implementation
	first_window: MAIN_WINDOW
			-- Main window.

	widget_button_press (x, y, button: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; screen_x, screen_y: INTEGER) is
			-- A pointer button press event has occurred on the test widget
		do
			game_manager.make_move (x // (field_size // game_manager.dimension), y // (field_size // game_manager.dimension))
		end

	field_size: INTEGER

	right_shift: INTEGER is 21
	lower_shift: INTEGER is 82

invariant
	drawable_widget /= Void
	first_window /= Void

end
