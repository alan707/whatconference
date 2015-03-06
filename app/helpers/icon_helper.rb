module IconHelper
  def radar_sweep_icon
    # Use ' instead of " for the HTML attributes to be able to use this
    # inside a data-disable-with HTML attribute
    "<span class='fa-stack icon-left'><i class='what-radar fa-stack-2x'></i><i class='what-radar-sweep fa-spin fa-stack-2x'></i></span>"
  end
end
