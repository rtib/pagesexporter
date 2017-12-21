module Event
  # TypeError for expressing invalid type
  class TypeError < StandardError
    def initialize(msg = 'Unknown or invalid event type.')
      super(msg)
    end
  end
  # ContentError expressing error while processing the payload of an event
  class ContentError < StandardError
    def initialize(msg = 'Content not parsable.')
      super(msg)
    end
  end
end
