module Lce
  class Client
    module Request
      def get(resource = nil, id = nil, action = nil, format = nil, params = nil)
        p = path(resource, id, action, format)
        request(:get, p, params, format)
      end

      def post(resource = nil, params = nil)
        p = path(resource)
        request(:post, p, params)
      end


      private

      def path(resource = nil, id = nil, action = nil, format = nil)
        path = []
        path << version << resource.to_s if resource
        path << id.to_s if id
        path << action.to_s if action
        path = '/'+path.join('/')
        path += ".#{format}" if format
        return path
      end

      def request(action, path, params, format = nil)
        response = connection.send(action, path, params)
        if success?(response)
          return response.body.data
        else
          error!(response)
          return nil
        end
      end
      
      def success?(response)
        response.status.between?(200, 299) && response.body.status == "success"
      end
      
      def error!(response)
        if response.body.error
          case response.body.error.type
            when 'access_denied'
              raise Lce::Client::AccessDenied.new(response.body.error.message, response.body.error.type, response.body.error.details)
            when 'account_disabled'
              raise Lce::Client::AccountDisabled.new(response.body.error.message, response.body.error.type, response.body.error.details)
            when 'internal'
              raise Lce::Client::LceError.new(response.body.error.message, response.body.error.type, response.body.error.details)              
          end
        end
      end
    end
  end
end
