#include "support.h"

G_MODULE_EXPORT gboolean
cb_draw_chart( GtkWidget *widget,
                 cairo_t *cr)
{
	/* Paint whole area in green color */
	cairo_set_source_rgb( cr, 0, 1, 0 );
	cairo_paint( cr );

	/* Return TRUE, since we handled this event */
	return( TRUE );
}
