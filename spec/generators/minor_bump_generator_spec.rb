require 'spec_helper'
require 'generators/api_versions/minor_bump_generator'

describe ApiVersions::Generators::MinorBumpGenerator do
  before do
    destination File.expand_path("../../../tmp", __FILE__)
    prepare_destination
  end

  describe "Generated files" do
    before { run_generator }

    describe "Bar Controller" do
      subject { file('app/controllers/api/v3dot1/bar_controller.rb') }

      it { should exist }
      it { should contain /Api::V3dot1::BarController < Api::V3::BarController/ }
    end

    describe "Foo Controller" do
      subject { file('app/controllers/api/v3dot1/foo_controller.rb') }

      it { should exist }
      it { should contain /Api::V3dot1::FooController < Api::V3::FooController/ }
    end

    describe "Nested Controller" do
      subject { file('app/controllers/api/v3dot1/nests/nested_controller.rb') }

      it { should exist }
      it { should contain /Api::V3dot1::Nests::NestedController < Api::V3::Nests::NestedController/ }
    end

    describe "Users Controller" do
      subject { file('app/controllers/api/v3dot1/users_controller.rb') }

      it { should_not exist }
    end
  end
end
