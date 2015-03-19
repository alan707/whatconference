module TagsHelper
  def tags_options_for_select(selected = nil, options = {})
    names = tag_names
    names.unshift('') if options[:include_blank]
    options_for_select(names, selected)
  end

  def tag_names
    ActsAsTaggableOn::Tag.pluck(:name)
  end
end
