require 'spec_helper'

describe 'Version Tracking' do
  describe "versions" do
    context "without prerelease flag" do
      before(:each) do
        @versions = ApiVersions::Versions.versions
      end

      it "should return only released versions" do
        expect(@versions).not_to(include '2.0b')
        expect(@versions).not_to(include '2.0b1')
      end
    end

    context "with prerelease flag" do
      before(:each) do
        @versions = ApiVersions::Versions.versions(prerelease: true)
      end

      it "should return all versions with prerelease option" do
        expect(@versions).to(include '1')
        expect(@versions).to(include '1.1')
        expect(@versions).to(include '2.0b')
        expect(@versions).to(include '2.0b1')
        expect(@versions).to(include '2')
        expect(@versions).to(include '3')
      end
    end
  end

  describe "latest_version" do
    context "with a new prerelease version" do
      before(:all) do
        ApiVersions::Versions.add_version('3.1b1')
      end

      context "without prerelease flag" do
        before(:each) do
          @version = ApiVersions::Versions.latest_version
        end

        it "should return the newest released version" do
          expect(@version).to eq('3')
        end
      end

      context "with prerelease flag" do
        before(:each) do
          @version = ApiVersions::Versions.latest_version(prerelease: true)
        end

        it "should return the absolute newest version" do
          expect(@version).to eq('3.1b1')
        end
      end
    end
  end
end
