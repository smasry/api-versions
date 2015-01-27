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
      process_version = Gem::Requirement.new(@process_version)
      # Ignore anything past the minor version
      # Versions can contain lowercase letters to indicate prerelease: http://ruby-doc.org/stdlib-2.0/libdoc/rubygems/rdoc/Gem/Version.html
      accept_version = Gem::Version.new version_regex.match(accept_string).try(:[], :version)
      process_version.satisfied_by? accept_version
    end

    def unversioned?(accept_string)
      @process_version == get_default_version && !(accept_string =~ version_regex)
    end

    def get_default_version
      self.class.default_version
    end

    def version_regex
      /version\s*?=\s*?(?<version>[0-9]+(\.[0-9a-z]+)?)([^\.0-9a-z]|$)/
    end
  end
end
