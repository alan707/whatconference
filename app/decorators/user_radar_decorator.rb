class UserRadarDecorator < SimpleDecorator
  def link_to_radar
    context.link_to(username, context.radar_path(self))
  end
end

