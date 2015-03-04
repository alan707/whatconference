(function() {
  var FC = $.fullCalendar; // a reference to FullCalendar's root namespace

  // Dependencies
  var Grid = FC.Grid;

  FC.MonthGrid = MonthGrid = Grid.extend({
    monthsPerRow: 3,

	cellDates: null, // flat chronological array of each cell's dates
	dayToCellOffsets: null, // maps days offsets from grid's start date, to cell offsets
    
    constructor: function() {
      Grid.apply(this, arguments);

      this.cellDuration = moment.duration(1, 'month'); // for Grid system
    },

    renderDates: function() {
      var view = this.view;
      var rowCnt = this.rowCnt;
      var colCnt = this.colCnt;
      var cellCnt = rowCnt * colCnt;
      var html = '';
      var row;
      var i, cell;

      for (row = 0; row < rowCnt; row++) {
        html += this.monthRowHtml(row);
      }
      this.el.html(html);

      this.rowEls = this.el.find('.fc-row');
      this.monthEls = this.el.find('.fc-month');

      // trigger monthRender with each cell's element
      for (i = 0; i < cellCnt; i++) {
        cell = this.getCell(i);
        view.trigger('monthRender', null, cell.start, this.monthEls.eq(i));
      }
    },

	// Generates the HTML for a single row. `row` is the row number.
	monthRowHtml: function(row) {
      var view = this.view;
      var classes = [ 'fc-row', view.widgetContentClass ];

      return '' +
        '<div class="' + classes.join(' ') + '">' +
          '<div class="fc-bg">' +
            '<table>' +
              this.rowHtml('month', row) + // leverages RowRenderer. calls monthCellHtml()
            '</table>' +
          '</div>' +
          '<div class="fc-content-skeleton">' +
            '<table>' +
              '<thead>' +
                this.rowHtml('monthName', row) + // leverages RowRenderer. View will define render method
              '</thead>' +
            '</table>' +
          '</div>' +
        '</div>';
	},
    
	/* Cell System
	------------------------------------------------------------------------------------------------------------------*/

	// Initializes row/col information
	updateCells: function() {
      this.updateCellDates(); // populates cellDates and dayToCellOffsets
      
      this.colCnt = this.monthsPerRow;
      this.rowCnt = 12 / this.colCnt;
    },


	// Populates cellDates and dayToCellOffsets
    updateCellDates: function() {
      var view = this.view;
      var date = this.start.clone();
      var dates = [];
      var offset = -1;
      var offsets = [];

      while (date.isBefore(this.end)) { // loop each month from start to end
        offset++;
        offsets.push(offset);
        dates.push(date.clone());
        date.add(1, 'month');
      }

      this.cellDates = dates;
      this.dayToCellOffsets = offsets;
    },

	// Given a cell object, generates its start date. Returns a reference-free copy.
	computeCellDate: function(cell) {
		var colCnt = this.colCnt;
		var index = cell.row * colCnt + (this.isRTL ? colCnt - cell.col - 1 : cell.col);

		return this.cellDates[index].clone();
	},

	/* Dates
	------------------------------------------------------------------------------------------------------------------*/


	// Slices up a date range by row into an array of segments
	rangeToSegs: function(range) {
		var isRTL = this.isRTL;
		var rowCnt = this.rowCnt;
		var colCnt = this.colCnt;
		var segs = [];
		var first, last; // inclusive cell-offset range for given range
		var row;
		var rowFirst, rowLast; // inclusive cell-offset range for current row
		var isStart, isEnd;
		var segFirst, segLast; // inclusive cell-offset range for segment
		var seg;

		range = this.view.computeDayRange(range); // make whole-day range, considering nextDayThreshold
		first = this.dateToCellOffset(range.start);
		last = this.dateToCellOffset(range.end.subtract(1, 'days')); // offset of inclusive end date

		for (row = 0; row < rowCnt; row++) {
			rowFirst = row * colCnt;
			rowLast = rowFirst + colCnt - 1;

			// intersect segment's offset range with the row's
			segFirst = Math.max(rowFirst, first);
			segLast = Math.min(rowLast, last);

			// deal with in-between indices
			segFirst = Math.ceil(segFirst); // in-between starts round to next cell
			segLast = Math.floor(segLast); // in-between ends round to prev cell

			if (segFirst <= segLast) { // was there any intersection with the current row?

				// must be matching integers to be the segment's start/end
				isStart = segFirst === first;
				isEnd = segLast === last;

				// translate offsets to be relative to start-of-row
				segFirst -= rowFirst;
				segLast -= rowFirst;

				seg = { row: row, isStart: isStart, isEnd: isEnd };
				if (isRTL) {
					seg.leftCol = colCnt - segLast - 1;
					seg.rightCol = colCnt - segFirst - 1;
				}
				else {
					seg.leftCol = segFirst;
					seg.rightCol = segLast;
				}
				segs.push(seg);
			}
		}

		return segs;
	},


	// Given a date, returns its chronolocial cell-offset from the first cell of the grid.
	// If before the first offset, returns a negative number.
	// If after the last offset, returns an offset past the last cell offset.
	// Only works for *start* dates of cells. Will not work for exclusive end dates for cells.
	dateToCellOffset: function(date) {
		var offsets = this.dayToCellOffsets;
		var month = date.diff(this.start, 'months');

		if (month < 0) {
			return offsets[0] - 1;
		}
		else if (month >= offsets.length) {
			return offsets[offsets.length - 1] + 1;
		}
		else {
			return offsets[month];
		}
	},

  });
})();
