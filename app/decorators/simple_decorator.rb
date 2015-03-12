require 'delegate'
class SimpleDecorator < SimpleDelegator
  attr_private :context

  def initialize(model, context)
    @context = context
    super(model)
  end
end

