module ApiVersions
  class VersionCheck
    class << self
      attr_accessor :default_version, :vendor_string
    end

    def initialize(args = {})
      @process_version = args[:version]
    end

    def matches?(request)
      accepts = request.headers['Accept'].split(',')
      accepts.any? do |accept|
        accept.strip!
        accepts_proper_format?(accept) && (matches_version?(accept) || unversioned?(accept))
      end
    end

    private

    def accepts_proper_format?(accept_string)
      accept_string =~ /\Aapplication\/vnd\.#{self.class.vendor_string}\s*\+\s*.+/
    end

    def matches_version?(accept_string)
      accept_string =~ version_regex(@process_version)
    end

    def unversioned?(accept_string)
      @process_version == self.class.default_version && !(accept_string =~ version_regex)
    end

    def version_regex(version_pattern = '\d')
      Regexp.new "version\\s*?=\\s*?#{version_pattern}\\b"
    end
  end
end
