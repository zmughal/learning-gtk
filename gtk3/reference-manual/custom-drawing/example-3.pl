#!/usr/bin/env perl
# ABSTRACT: Custom drawing example
#
# See <https://developer.gnome.org/gtk3/stable/ch01s05.html>

use Modern::Perl;
use feature 'signatures';
no warnings 'experimental::signatures';

use Glib qw(TRUE FALSE);
use Gtk3 -init;
use Cairo;

# Surface to store current scribbles
my $surface = undef;

sub clear_surface() {
	my $cr = Cairo::Context->create($surface);

	$cr->set_source_rgb(1, 1, 1);
	$cr->paint;
}

# Create a new surface of the appropriate size to store our scribbles
sub configure_event_cb($widget, $event) {
	if( defined $surface ) {
		$surface->destroy;
	}

	$surface = $widget->get_window->create_similar_surface(
	'color',
	$widget->get_allocated_width,
	$widget->get_allocated_height );

	# Initialize the surface to white
	clear_surface();

	# We've handled the configure event, no need for further processing.
	return TRUE;
}


# Redraw the screen from the surface. Note that the ::draw
# signal receives a ready-to-be-used cairo_t that is already
# clipped to only draw the exposed areas of the widget
sub draw_cb($widget, $cr) {
	$cr->set_source_surface( $surface, 0, 0);
	$cr->paint;

	return FALSE;
}

# Draw a rectangle on the surface at the given position
sub draw_brush ($widget, $x, $y) {
	my $cr;

	# Paint to the surface, where we store our state
	$cr = Cairo::Context->create($surface);

	$cr->rectangle( $x - 3, $y - 3, 6, 6);
	$cr->fill;

	# Now invalidate the affected region of the drawing area.
	$widget->queue_draw_area( $x - 3, $y - 3, 6, 6);
}

# Handle button press events by either drawing a rectangle
# or clearing the surface, depending on which button was pressed.
# The ::button-press signal handler receives a GdkEventButton
# struct which contains this information.
sub button_press_event_cb($widget, $event) {
	# paranoia check, in case we haven't gotten a configure event
	unless( defined $surface ) {
		return FALSE;
	}

	if( $event->button == Gtk3::Gdk::BUTTON_PRIMARY ) {
		draw_brush( $widget, $event->x, $event->y );
	} elsif( $event->button == Gtk3::Gdk::BUTTON_SECONDARY ) {
		clear_surface();
		$widget->queue_draw;
	}

	# We've handled the event, stop processing
	return TRUE;
}

# Handle motion events by continuing to draw if button 1 is
# still held down. The ::motion-notify signal handler receives
# a GdkEventMotion struct which contains this information.
sub motion_notify_event_cb($widget, $event) {
	# paranoia check, in case we haven't gotten a configure event
	unless( defined $surface ) {
		return FALSE;
	}

	if( $event->state & 'button1-mask' ) {
		draw_brush( $widget, $event->x, $event->y );
	}

	# We've handled it, stop processing
	return TRUE;
}

sub close_window(@) {
	Gtk3::main_quit;
}

sub activate() {
	my $window = Gtk3::Window->new;
	$window->set_title('Drawing Area');

	$window->signal_connect( destroy => \&close_window );

	$window->set_border_width(8);

	my $frame = Gtk3::Frame->new;
	$frame->set_shadow_type( 'in' );
	$window->add($frame);

	my $drawing_area = Gtk3::DrawingArea->new;
	# set a minimum size
	$drawing_area->set_size_request( 100, 100 );

	$frame->add( $drawing_area );

	# Signals used to handle the backing surface
	$drawing_area->signal_connect( draw => \&draw_cb );
	$drawing_area->signal_connect( 'configure-event' => \&configure_event_cb );

	# Event signals
	$drawing_area->signal_connect( 'motion-notify-event' => \&motion_notify_event_cb );
	$drawing_area->signal_connect( 'button-press-event' => \&button_press_event_cb );

	# Ask to receive events the drawing area doesn't normally
	# subscribe to. In particular, we need to ask for the
	# button press and motion notify events that want to handle.
	$drawing_area->set_events(
		  $drawing_area->get_events
		| [ qw/button-press-mask pointer-motion-mask/ ] );

	$window->show_all;
}

sub main {
	activate;

	Gtk3::main;

	return 0;
}

main;
