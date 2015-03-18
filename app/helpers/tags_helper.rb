module TagsHelper
  def tags_options_for_select
    options_for_select(tag_names)
  end

  def tag_names
    ActsAsTaggableOn::Tag.pluck(:name)
  end
end
