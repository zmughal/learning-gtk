#!/usr/bin/env perl
# ABSTRACT: A model/view-based GooCanvas2

use Gtk3 qw(-init);
use Glib qw(TRUE FALSE);
use Modern::Perl;

sub _include_goocanvas {
	Glib::Object::Introspection->setup(
		basename => 'GooCanvas',
		version => '2.0',
		package => 'GooCanvas2', );
}

# This handles button presses in item views. We simply output a message to
# the console.
sub on_rect_button_press {
	my ($view, $target, $event, $data) = @_;

	say "rect item received button press event";
	return TRUE;
}

# This is our handler for the "delete-event" signal of the window, which
# is emitted when the 'x' close button is clicked. We just exit here.
sub on_delete_event {
	my ($window, $event, $data) = @_;

	exit(0);
}

sub main {
	_include_goocanvas();

	# Create the window and widgets.
	my $window = Gtk3::Window->new('toplevel');
	$window->set_default_size(640, 600);
	$window->show;
	$window->signal_connect( delete_event => \&on_delete_event );

	my $scrolled_win = Gtk3::ScrolledWindow->new;
	$scrolled_win->set_shadow_type( 'in' );
	$scrolled_win->show;
	$window->add($scrolled_win);

	my $canvas = GooCanvas2::Canvas->new;
	$canvas->set_size_request(600, 450);
	$canvas->set_bounds(0, 0, 1000, 1000);
	$canvas->show;
	$scrolled_win->add( $canvas );

	my $root = GooCanvas2::CanvasGroupModel->new;

	# Add a few simple items.
	my $rect_model = GooCanvas2::CanvasRectModel->new(
		parent => $root,
		x => 100,
		y => 100,
		width => 400,
		height => 400,
		"line-width", 10.0,
		"radius-x", 20.0,
		"radius-y", 10.0,
		"stroke-color", "yellow",
		"fill-color", "red",
		);

	my $text_model = GooCanvas2::CanvasTextModel->new(
		parent => $root,
		text => "Hello World",
		x => 300, y => 300, width => -1,
		anchor => 'center',
		"font", "Sans 24");
	$text_model->rotate(45, 300, 300);

	$canvas->set_root_item_model($root);

	# Connect a signal handler for the rectangle item.
	my $rect_item = $canvas->get_item($rect_model);
	$rect_item->signal_connect( 'button_press_event' => \&on_rect_button_press );

	# Pass control to the GTK+ main event loop.
	Gtk3::main();

	return 0;
}

main;
