module ApiVersions
  VERSION_HEADER = 'api.version'

  class VersionCheck
    class << self
      attr_accessor :default_version, :vendor_string
    end

    def initialize(args = {})
      @process_version = args[:version].to_s
    end

    def matches?(request)
      accepts = request.headers['Accept'].split(',')
      # First, check if the version matches on the accept header
      return true if accepts.any? do |accept|
        accept.strip!
        accepts_proper_format?(accept) && matches_version?(accept)
      end
      # If the api.version header exists, rely on whether the versions match
      return get_gem_process_version.satisfied_by? Gem::Version.new request.headers[VERSION_HEADER] if request.headers[VERSION_HEADER]
      # else, fall back on the default and check if it is versioned
      accepts.any? do |accept|
        accepts_proper_format?(accept) && unversioned?(accept)
      end
    end

    private

    def accepts_proper_format?(accept_string)
      accept_string =~ /\Aapplication\/vnd\.#{self.class.vendor_string}\s*\+\s*.+/
    end

    def matches_version?(accept_string)
      # Ignore anything past the minor version
      # Versions can contain lowercase letters to indicate prerelease: http://ruby-doc.org/stdlib-2.0/libdoc/rubygems/rdoc/Gem/Version.html
      accept_version = Gem::Version.new version_regex.match(accept_string).try(:[], :version)
      get_gem_process_version.satisfied_by? accept_version
    end

    def get_gem_process_version
      @gem_process_version ||= Gem::Requirement.new(@process_version)
    end

    def unversioned?(accept_string)
      @process_version == get_default_version && !(accept_string =~ version_regex)
    end

    def get_default_version
      self.class.default_version.to_s
    end

    def version_regex
      /version\s*?=\s*?(?<version>[0-9]+(\.[0-9a-z]+)?)([^\.0-9a-z]|$)/
    end
  end
end
