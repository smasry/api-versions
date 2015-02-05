require 'forwardable'

module ApiVersions
  class DSL
    extend Forwardable

    VERSION_SEPARATOR = 'dot'

    class << self
      def to_version_dsl(version)
        version.to_s.gsub('.', VERSION_SEPARATOR)
      end

      def to_version_string(version)
        version.to_s.gsub(VERSION_SEPARATOR, '.')
      end

      # @see Gem::Version#bump
      def bump_minor(version)
        segments = version.segments.dup
        segments.pop while segments.any? { |s| String === s }
        segments.push 0 if segments.size == 1

        segments[-1] = segments[-1].succ
        Gem::Version.new segments.join('.')
      end
    end

    def initialize(context, &block)
      @context = context
      singleton_class.def_delegators :@context, *(@context.public_methods - public_methods)
      instance_eval(&block)
    end

    def version(version_number, &block)
      VersionCheck.default_version ||= version_number

      constraints VersionCheck.new(version: version_number) do
        # Valid module names are [0-9A-Za-z_] but ActionDispatch will camelize and remove underscores
        scope({ module: "v#{self.class.to_version_dsl(version_number)}" }, &block)
      end

      Versions.add_version(version_number) # Track the version
    end

    def inherit(options)
      Array.wrap(options[:from]).each do |block|
         @resource_cache[block].call
      end
    end

    def cache(options, &block)
      @resource_cache ||= {}
      @resource_cache[options[:as]] = block
      yield
    end
  end
end
