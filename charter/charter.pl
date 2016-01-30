#!/usr/bin/env perl

use strict;
use warnings;

use Gtk3 -init;
use Glib 'TRUE', 'FALSE';
use Moo;

use constant UI_FILE => "charter.glade";

has builder => ( is => 'lazy', clearer => 1 );

sub _build_builder {
	Gtk3::Builder->new ();
}

sub cb_draw_chart {
	my ($widget, $cr) = @_;
	# $widget is Gtk::Widget
	# $cr is cairo_t

	# Paint whole area in green color
	$cr->set_source_rgb(0, 1, 0);
	$cr->paint;

	return TRUE;
}

sub gtk_main_quit {
	exit 0;
}

sub main {
	my $self = __PACKAGE__->new;

	$self->builder->add_from_file( UI_FILE );
	$self->builder->connect_signals;

	my $window = $self->builder->get_object('main_window');
	$self->clear_builder;

	$window->show_all;

	Gtk3::main;
}

main;
