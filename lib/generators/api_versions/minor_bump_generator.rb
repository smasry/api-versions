module ApiVersions
  module Generators
    class MinorBumpGenerator < Rails::Generators::Base
      desc "Bump API version to next minor version, initializing controllers"
      source_root File.expand_path('../templates', __FILE__)

      def get_controllers
        Dir.chdir File.join(Rails.root, 'app', 'controllers') do
          @controllers = Dir.glob('api/v**/**/*.rb')
        end

        @highest_version = @controllers.map do |controller|
          Gem::Version.new ApiVersions::DSL.to_version_string(controller.match(/api\/v(\d+?(?:dot)?\d*[a-z]?\d*)\//)[1])
        end.max
        @highest_version_string = ApiVersions::DSL.to_version_dsl(@highest_version)

        @controllers.keep_if { |element| element =~ /api\/v#{@highest_version_string}\// }
      end

      def generate_new_controllers
        new_version_string = ApiVersions::DSL.to_version_dsl(ApiVersions::DSL.bump_minor(@highest_version))
        @controllers.each do |controller|
          new_controller = controller.gsub(/api\/v#{@highest_version_string}\//, "api/v#{new_version_string}/")
          @current_new_controller = new_controller.chomp(File.extname(controller)).camelize
          @current_old_controller = controller.chomp(File.extname(controller)).camelize
          template 'controller.rb', File.join('app', 'controllers', new_controller)
        end
      end
    end
  end
end
