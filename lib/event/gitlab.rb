require_relative 'abstractevent'
require 'logger'

module Event
  # GitLab event class
  class GitLab < Event::AbstractEvent
    attr_reader :namespace, :name, :git_url

    def initialize(headers, payload)
      @logger = Logger.new(STDOUT)
      @logger.progname = self.class
      raise Event::TypeError if
        !headers.key?('HTTP_X_GITLAB_EVENT') ||
        headers['HTTP_X_GITLAB_EVENT'] != 'Push Hook'
      @logger.info('Got GitLab Push event.')
      parse_payload(payload)
    end

    def parse_payload(payload)
      begin
        @event_payload = JSON.parse(payload)
      rescue
        raise Event::ContentError('Failed to parse event payload.')
      end
      @namespace = @event_payload['project']['namespace']
      @name = @event_payload['project']['name']
      @git_url = @event_payload['project']['git_http_url']
    end
  end
end
