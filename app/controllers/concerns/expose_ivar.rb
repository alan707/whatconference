require 'active_support/concern'

# Expose an ivar for a view as a helper method
# http://jerodsanto.net/2012/12/a-handy-method-to-share-data-from-rails-controllers-to-views-without-requiring-direct-instance-variable-access/
module Concerns::ExposeIvar
  extend ActiveSupport::Concern

  module ClassMethods
    def exposes(*ivars)
      ivars.each do |ivar|
        attr_reader ivar.to_sym
        helper_method ivar.to_sym
      end
    end
  end
end
