module ApiVersions
  class Versions
    class << self
      # @option options [Boolean] :prerelease (false) If true, prerelease versions are included
      # @return [Array<String>]
      def versions(options = {})
        gem_versions(options).map(&:to_s)
      end

      # @option options [Boolean] :prerelease (false) If true, prerelease versions are considered
      # @return [String]
      def latest_version(options = {})
        max_version = gem_versions(options).max
        max_version = max_version.to_s unless max_version.nil?
        max_version
      end

      def add_version(version_number)
        @versions ||= {} # Use a hash to dedup
        gem_version = Gem::Version.new(version_number)
        @versions[gem_version.to_s] = gem_version
      end

      protected
      # @option options [Boolean] :prerelease (false) If true, prerelease versions are included
      # @return [Array<Gem::Version>]
      def gem_versions(options = {})
        @versions ||= {}
        versions = @versions.values
        versions.delete_if { |v| v.prerelease? } unless options[:prerelease]
        versions
      end
    end
  end
end
