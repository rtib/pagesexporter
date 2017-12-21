require_relative 'abstractevent'
require 'logger'

module Event
  # GitHub class
  class GitHub < Event::AbstractEvent
    attr_reader :namespace, :name, :git_url
    attr_reader :guid

    def initialize(headers, payload)
      @logger = Logger.new(STDOUT)
      @logger.progname = self.class
      raise Event::TypeError if
        !headers.key?('HTTP_X_GITHUB_EVENT') ||
        headers['HTTP_X_GITHUB_EVENT'] != 'push'
      @guid = headers['HTTP_X_GITHUB_DELIVERY'] if
        headers.key?('HTTP_X_GITHUB_DELIVERY')
      @logger.info("Got GitHub Push event. Delivered with #{@guid}")
      parse_payload(payload)
    end

    def parse_payload(payload)
      begin
        @event_payload = JSON.parse(payload)
      rescue
        raise Event::ContentError('Failed to parse event payload.')
      end
      @namespace = @event_payload['repository']['owner']['name']
      @name = @event_payload['repository']['name']
      @git_url = @event_payload['repository']['clone_url']
    end
  end
end
