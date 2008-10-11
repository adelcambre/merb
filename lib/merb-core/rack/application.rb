module Merb  
  module Rack
    class Application
      
      # The main rack application call method.  This is the entry point from rack (and the webserver) 
      # to your application.  
      #
      # ==== Parameters
      # env<Hash>:: A rack request of parameters.  
      #
      # ==== Returns
      # <Array>:: A rack response of [status<Integer>, headers<Hash>, body<String, Stream>]
      #
      # @api private
      def call(env) 
        begin
          rack_response = ::Merb::Dispatcher.handle(Merb::Request.new(env))
        rescue Object => e
          return [500, {Merb::Const::CONTENT_TYPE => "text/html"}, e.message + "<br/>" + e.backtrace.join("<br/>")]
        end
        Merb.logger.info "\n\n"
        Merb.logger.flush

        # unless controller.headers[Merb::Const::DATE]
        #   require "time"
        #   controller.headers[Merb::Const::DATE] = Time.now.rfc2822.to_s
        # end
        rack_response
      end

      # Determines whether this request is a "deferred_action", usually a long request. 
      # Rack uses this method to detemine whether to use an evented request or a deferred 
      # request in evented rack handlers.  
      #
      # ==== Parameters
      # env<Hash>:: The rack request
      #
      # ==== Returns
      # Boolean::
      #   True if the request should be deferred.  
      #
      # @api private
      def deferred?(env)
        path = env[Merb::Const::PATH_INFO] ? env[Merb::Const::PATH_INFO].chomp('/') : ""
        if path =~ Merb.deferred_actions
          Merb.logger.info! "Deferring Request: #{path}"
          true
        else
          false
        end        
      end # deferred?(env)
    end # Application
  end # Rack
end # Merb
