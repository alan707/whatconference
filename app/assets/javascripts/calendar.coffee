$ ->
  $(".conference-calendar").each (index, element) =>
    $(element).fullCalendar({
      header: {
        left: 'prev,next today',
        center: 'title',
        right: 'month,basicWeek'
      },
      events: Routes.conferences_path({ format: 'json' })
    })

