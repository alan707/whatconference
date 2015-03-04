(function() {
  var FC = $.fullCalendar; // a reference to FullCalendar's root namespace

  // Dependencies
  var View = FC.View;
  var MonthGrid = FC.MonthGrid;

  FC.views.year = YearView = View.extend({ // make a subclass of View
    monthGrid: null, // the main subcomponent that does most of the heavy lifting

    initialize: function() {
      this.monthGrid = new MonthGrid(this);
      this.monthGrid.monthsPerRow
    },

    render: function() {
      this.el.html(this.renderHtml());
      this.monthGrid.setElement(this.el.find('.fc-month-grid'));
      this.monthGrid.renderDates();
    },

	// Builds the HTML skeleton for the view.
	// The month grid component will render inside of a container defined by this HTML.
	renderHtml: function() {
		return '' +
			'<table>' +
				'<tbody class="fc-body">' +
					'<tr>' +
						'<td class="' + this.widgetContentClass + '">' +
							'<div class="fc-month-grid-container">' +
								'<div class="fc-month-grid"/>' +
							'</div>' +
						'</td>' +
					'</tr>' +
				'</tbody>' +
			'</table>';
	},

	// Sets the display range and computes all necessary dates
	setRange: function(range) {
		View.prototype.setRange.call(this, range); // call the super-method
		this.monthGrid.setRange(range);
	},
    

    setHeight: function(height, isAuto) {
      // responsible for adjusting the pixel-height of the view. if isAuto is true, the
      // view may be its natural height, and `height` becomes merely a suggestion.
    },

    renderEvents: function(events) {
      this.monthGrid.renderEvents(events);
    },

    destroyEvents: function() {
      this.monthGrid.destroyEvents();
    },

    renderSelection: function(range) {
      this.monthGrid.renderSelection(range);
    },

    destroySelection: function() {
      this.monthGrid.destroySelection();
    }

  });

  YearView.duration = { years: 1 };

})();
