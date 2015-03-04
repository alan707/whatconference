(function() {
  var FC = $.fullCalendar; // a reference to FullCalendar's root namespace

  // Dependencies
  var Grid = FC.Grid;
  var cssToStr = FC.cssToStr;
  var htmlEscape = FC.htmlEscape;
  var compareSegs = FC.compareSegs;

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

	// Renders the HTML for a single-month background cell
	monthCellHtml: function(cell) {
		var view = this.view;
		var date = cell.start;
		var classes = this.getMonthClasses(date);

		classes.unshift('fc-month', view.widgetContentClass);

		return '<td class="' + classes.join(' ') + '"' +
			' data-date="' + date.format('YYYY-MM-DD') + '"' + // if date has a time, won't format it
			'></td>';
	},

	// Computes HTML classNames for a single-month cell
	getMonthClasses: function(date) {
		var view = this.view;
		var today = view.calendar.getNow().stripTime();
		var classes = [];

		if (date.isSame(today, 'month')) {
			classes.push(
				'fc-today',
				view.highlightStateClass
			);
		}
		else if (date < today) {
			classes.push('fc-past');
		}
		else {
			classes.push('fc-future');
		}

		return classes;
	},
    
	// Generates the HTML for the <td>s of the "month name" row in the content skeleton.
    monthNameCellHtml: function(cell) {
		var date = cell.start;
		var classes;

		classes = this.getMonthClasses(date);
		classes.unshift('fc-month-name');

		return '' +
			'<th class="' + classes.join(' ') + '" data-date="' + date.format() + '">' +
				date.format(this.colHeadFormat) +
			'</th>';
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

	/* Options
	------------------------------------------------------------------------------------------------------------------*/

	// Computes a default column header formatting string if `colFormat` is not explicitly defined
	computeColHeadFormat: function() {
      return 'MMMM'; // "January"
	},
  });


  MonthGrid.mixin({

    rowStructs: null, // an array of objects, each holding information about a row's foreground event-rendering


    // Renders the given foreground event segments onto the grid
    renderFgSegs: function(segs) {
      var rowStructs;

      // render an `.el` on each seg
      // returns a subset of the segs. segs that were actually rendered
      segs = this.renderFgSegEls(segs);

      rowStructs = this.rowStructs = this.renderSegRows(segs);

      // append to each row's content skeleton
      this.rowEls.each(function(i, rowNode) {
        $(rowNode).find('.fc-content-skeleton > table').append(
          rowStructs[i].tbodyEl
        );
      });

      return segs; // return only the segs that were actually rendered
    },


    // Unrenders all currently rendered foreground event segments
    destroyFgSegs: function() {
      var rowStructs = this.rowStructs || [];
      var rowStruct;

      while ((rowStruct = rowStructs.pop())) {
        rowStruct.tbodyEl.remove();
      }

      this.rowStructs = null;
    },


    // Uses the given events array to generate <tbody> elements that should be appended to each row's content skeleton.
    // Returns an array of rowStruct objects (see the bottom of `renderSegRow`).
    // PRECONDITION: each segment shoud already have a rendered and assigned `.el`
    renderSegRows: function(segs) {
      var rowStructs = [];
      var segRows;
      var row;

      segRows = this.groupSegRows(segs); // group into nested arrays

      // iterate each row of segment groupings
      for (row = 0; row < segRows.length; row++) {
        rowStructs.push(
          this.renderSegRow(row, segRows[row])
        );
      }

      return rowStructs;
    },


    // Builds the HTML to be used for the default element for an individual segment
    fgSegHtml: function(seg, disableResizing) {
      var view = this.view;
      var event = seg.event;
      var isDraggable = view.isEventDraggable(event);
      var isResizableFromStart = !disableResizing && event.allDay &&
        seg.isStart && view.isEventResizableFromStart(event);
      var isResizableFromEnd = !disableResizing && event.allDay &&
        seg.isEnd && view.isEventResizableFromEnd(event);
      var classes = this.getSegClasses(seg, isDraggable, isResizableFromStart || isResizableFromEnd);
      var skinCss = cssToStr(this.getEventSkinCss(event));
      var timeHtml = '';
      var timeText;
      var titleHtml;

      classes.unshift('fc-day-grid-event', 'fc-h-event');

      // Only display a timed events time if it is the starting segment
      if (seg.isStart) {
        timeText = this.getEventTimeText(event);
        if (timeText) {
          timeHtml = '<span class="fc-time">' + htmlEscape(timeText) + '</span>';
        }
      }

      titleHtml =
        '<span class="fc-title">' +
          (htmlEscape(event.title || '') || '&nbsp;') + // we always want one line of height
            '</span>';

      return '<a class="' + classes.join(' ') + '"' +
        (event.url ?
         ' href="' + htmlEscape(event.url) + '"' :
           ''
        ) +
          (skinCss ?
           ' style="' + skinCss + '"' :
             ''
          ) +
            '>' +
              '<div class="fc-content">' +
                (this.isRTL ?
                 titleHtml + ' ' + timeHtml : // put a natural space in between
                   timeHtml + ' ' + titleHtml   //
                ) +
                  '</div>' +
                    (isResizableFromStart ?
                     '<div class="fc-resizer fc-start-resizer" />' :
                       ''
                    ) +
                      (isResizableFromEnd ?
                       '<div class="fc-resizer fc-end-resizer" />' :
                         ''
                      ) +
                        '</a>';
    },


    // Given a row # and an array of segments all in the same row, render a <tbody> element, a skeleton that contains
    // the segments. Returns object with a bunch of internal data about how the render was calculated.
    // NOTE: modifies rowSegs
    renderSegRow: function(row, rowSegs) {
      var colCnt = this.colCnt;
      var segLevels = this.buildSegLevels(rowSegs); // group into sub-arrays of levels
      var levelCnt = Math.max(1, segLevels.length); // ensure at least one level
      var tbody = $('<tbody/>');
      var segMatrix = []; // lookup for which segments are rendered into which level+col cells
      var cellMatrix = []; // lookup for all <td> elements of the level+col matrix
      var loneCellMatrix = []; // lookup for <td> elements that only take up a single column
      var i, levelSegs;
      var col;
      var tr;
      var j, seg;
      var td;

      // populates empty cells from the current column (`col`) to `endCol`
      function emptyCellsUntil(endCol) {
        while (col < endCol) {
          // try to grab a cell from the level above and extend its rowspan. otherwise, create a fresh cell
          td = (loneCellMatrix[i - 1] || [])[col];
          if (td) {
            td.attr(
              'rowspan',
              parseInt(td.attr('rowspan') || 1, 10) + 1
            );
          }
          else {
            td = $('<td/>');
            tr.append(td);
          }
          cellMatrix[i][col] = td;
          loneCellMatrix[i][col] = td;
          col++;
        }
      }

      for (i = 0; i < levelCnt; i++) { // iterate through all levels
        levelSegs = segLevels[i];
        col = 0;
        tr = $('<tr/>');

        segMatrix.push([]);
        cellMatrix.push([]);
        loneCellMatrix.push([]);

        // levelCnt might be 1 even though there are no actual levels. protect against this.
        // this single empty row is useful for styling.
        if (levelSegs) {
          for (j = 0; j < levelSegs.length; j++) { // iterate through segments in level
            seg = levelSegs[j];

            emptyCellsUntil(seg.leftCol);

            // create a container that occupies or more columns. append the event element.
            td = $('<td class="fc-event-container"/>').append(seg.el);
            if (seg.leftCol != seg.rightCol) {
              td.attr('colspan', seg.rightCol - seg.leftCol + 1);
            }
            else { // a single-column segment
              loneCellMatrix[i][col] = td;
            }

            while (col <= seg.rightCol) {
              cellMatrix[i][col] = td;
              segMatrix[i][col] = seg;
              col++;
            }

            tr.append(td);
          }
        }

        emptyCellsUntil(colCnt); // finish off the row
        this.bookendCells(tr, 'eventSkeleton');
        tbody.append(tr);
      }

      return { // a "rowStruct"
        row: row, // the row number
        tbodyEl: tbody,
        cellMatrix: cellMatrix,
        segMatrix: segMatrix,
        segLevels: segLevels,
        segs: rowSegs
      };
    },


    // Stacks a flat array of segments, which are all assumed to be in the same row, into subarrays of vertical levels.
    // NOTE: modifies segs
    buildSegLevels: function(segs) {
      var levels = [];
      var i, seg;
      var j;

      // Give preference to elements with certain criteria, so they have
      // a chance to be closer to the top.
      segs.sort(compareSegs);

      for (i = 0; i < segs.length; i++) {
        seg = segs[i];

        // loop through levels, starting with the topmost, until the segment doesn't collide with other segments
        for (j = 0; j < levels.length; j++) {
          if (!isDaySegCollision(seg, levels[j])) {
            break;
          }
        }
        // `j` now holds the desired subrow index
        seg.level = j;

        // create new level array if needed and append segment
        (levels[j] || (levels[j] = [])).push(seg);
      }

      // order segments left-to-right. very important if calendar is RTL
      for (j = 0; j < levels.length; j++) {
        levels[j].sort(compareDaySegCols);
      }

      return levels;
    },


    // Given a flat array of segments, return an array of sub-arrays, grouped by each segment's row
    groupSegRows: function(segs) {
      var segRows = [];
      var i;

      for (i = 0; i < this.rowCnt; i++) {
        segRows.push([]);
      }

      for (i = 0; i < segs.length; i++) {
        segRows[segs[i].row].push(segs[i]);
      }

      return segRows;
    }

  });


  // Computes whether two segments' columns collide. They are assumed to be in the same row.
  function isDaySegCollision(seg, otherSegs) {
    var i, otherSeg;

    for (i = 0; i < otherSegs.length; i++) {
      otherSeg = otherSegs[i];

      if (
        otherSeg.leftCol <= seg.rightCol &&
            otherSeg.rightCol >= seg.leftCol
      ) {
        return true;
      }
    }

    return false;
  }


  // A cmp function for determining the leftmost event
  function compareDaySegCols(a, b) {
    return a.leftCol - b.leftCol;
  }
})();
