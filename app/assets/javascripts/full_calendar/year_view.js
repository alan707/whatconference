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

	// Unrenders the content of the view
	destroy: function() {
		this.monthGrid.destroyDates();
		this.monthGrid.removeElement();
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
      this.setGridHeight(height, isAuto);
    },

	// Sets the height of just the MonthGrid component in this view
	setGridHeight: function(height, isAuto) {
		if (isAuto) {
			undistributeHeight(this.monthGrid.rowEls); // let the rows be their natural height with no expanding
		}
		else {
			distributeHeight(this.monthGrid.rowEls, height, true); // true = compensate for height-hogging rows
		}
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

  /* Utility functions copied from fullcalendar/util.js */

// Given a total available height to fill, have `els` (essentially child rows) expand to accomodate.
// By default, all elements that are shorter than the recommended height are expanded uniformly, not considering
// any other els that are already too tall. if `shouldRedistribute` is on, it considers these tall rows and 
// reduces the available height.
function distributeHeight(els, availableHeight, shouldRedistribute) {

	// *FLOORING NOTE*: we floor in certain places because zoom can give inaccurate floating-point dimensions,
	// and it is better to be shorter than taller, to avoid creating unnecessary scrollbars.

	var minOffset1 = Math.floor(availableHeight / els.length); // for non-last element
	var minOffset2 = Math.floor(availableHeight - minOffset1 * (els.length - 1)); // for last element *FLOORING NOTE*
	var flexEls = []; // elements that are allowed to expand. array of DOM nodes
	var flexOffsets = []; // amount of vertical space it takes up
	var flexHeights = []; // actual css height
	var usedHeight = 0;

	undistributeHeight(els); // give all elements their natural height

	// find elements that are below the recommended height (expandable).
	// important to query for heights in a single first pass (to avoid reflow oscillation).
	els.each(function(i, el) {
		var minOffset = i === els.length - 1 ? minOffset2 : minOffset1;
		var naturalOffset = $(el).outerHeight(true);

		if (naturalOffset < minOffset) {
			flexEls.push(el);
			flexOffsets.push(naturalOffset);
			flexHeights.push($(el).height());
		}
		else {
			// this element stretches past recommended height (non-expandable). mark the space as occupied.
			usedHeight += naturalOffset;
		}
	});

	// readjust the recommended height to only consider the height available to non-maxed-out rows.
	if (shouldRedistribute) {
		availableHeight -= usedHeight;
		minOffset1 = Math.floor(availableHeight / flexEls.length);
		minOffset2 = Math.floor(availableHeight - minOffset1 * (flexEls.length - 1)); // *FLOORING NOTE*
	}

	// assign heights to all expandable elements
	$(flexEls).each(function(i, el) {
		var minOffset = i === flexEls.length - 1 ? minOffset2 : minOffset1;
		var naturalOffset = flexOffsets[i];
		var naturalHeight = flexHeights[i];
		var newHeight = minOffset - (naturalOffset - naturalHeight); // subtract the margin/padding

		if (naturalOffset < minOffset) { // we check this again because redistribution might have changed things
			$(el).height(newHeight);
		}
	});
}


// Undoes distrubuteHeight, restoring all els to their natural height
function undistributeHeight(els) {
	els.height('');
}


  YearView.duration = { years: 1 };

})();
