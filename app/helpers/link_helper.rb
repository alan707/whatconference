module LinkHelper

  def wrap_link_if(*args, &block)
    condition    = args.first
    if block_given?
      content = capture(&block)
      options      = args.second || {}
      html_options = args.third
    else
      content = args.second
      options = args.third || {}
      html_options = args.fourth
    end

    if condition
      link_to(content, options, html_options)
    else
      content
    end
  end

  def wrap_link_unless(*args, &block)
    wrap_link_if(*[!args.shift, *args], &block)
  end

end

