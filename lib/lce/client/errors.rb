module Lce
  class Client
    module Errors
      class LceError < StandardError
        attr_reader :type, :details
        def initialize(msg, type, details)
          super(msg)
          @type = type
          @details = details
        end
        def to_s
          s = super
          s+= "\n#{@details.join(' ')}" if @details && !@details.empty?
          s
        end
      end
      class VersionError <  LceError; end
      class ConnectionError <  LceError; end      
      class AccessDenied <  LceError; end
      class AccountDisabled <  LceError; end
      
    end
  end
end
