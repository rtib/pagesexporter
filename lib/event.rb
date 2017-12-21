require_relative 'event/github'
require_relative 'event/gitlab'
require_relative 'event/errors'

# Event module to model events
module Event
  # Factory class will create instances to different kinds of events
  class Factory
    def get_event(headers, payload)
      return Event::GitLab.new(headers, payload) if
        headers.key?('HTTP_X_GITLAB_EVENT')
      return Event::GitHub.new(headers, payload) if
        headers.key?('HTTP_X_GITHUB_EVENT')
      raise Event::TypeError
    end
  end
end
