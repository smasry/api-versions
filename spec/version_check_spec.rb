require 'spec_helper'

ACCEPT = 'Accept'

test_cases = {
  requests: {
    'matches accept version' => {
      matches: true,
      headers: {
        ACCEPT => 'application/vnd.myvendor+json;version=1'
      },
      version: 1
    },
    'matches api.version version' => {
      matches: true,
      headers: {
        ACCEPT => 'application/vnd.myvendor+json',
        ApiVersions::VERSION_HEADER => '1.1'
      },
      version: 1.1
    },
    'matches default version' => {
      matches: true,
      headers: {
        ACCEPT => 'application/vnd.myvendor+json'
      },
      version: 1
    },
    'matches api.version without vendor key present' => {
      matches: true,
      headers: {
        ACCEPT => 'junk',
        ApiVersions::VERSION_HEADER => '1'
      },
      version: 1
    },
    'api.version does not match default version' => {
      matches: false,
      headers: {
        ACCEPT => 'application/vnd.myvendor+json',
        ApiVersions::VERSION_HEADER => '1.0'
      },
      version: 1.1
    },
    'vendor version does not match default version' => {
      matches: false,
      headers: {
        ACCEPT => 'application/vnd.myvendor+json;version=1',
      },
      version: 1.1
    },
    'accept not valid, vendor does not match' => {
      matches: false,
      headers: {
        ACCEPT => 'junk',
        ApiVersions::VERSION_HEADER => '1.0'
      },
      version: 1.1
    },
  },
  valid: {
    'with major version only' => {
      string: 'application/vnd.myvendor+json;version=1',
      version: 1,
    },
    'with major and minor version' => {
      string: 'application/vnd.myvendor+json;version=1.0',
      version: 1,
    },
    'with major and minor prerelease version' => {
      string: 'application/vnd.myvendor+json;version=1.0b',
      version: '1.0b',
    },
    'with a capital letter' => {
      string: 'application/vnd.myvendor+json;version=1.0A',
      version: '1.0',
    },
  },
  invalid: {
    'without version information' => 'application/vnd.myvendor+json',
    'lacking minor version' => 'application/vnd.myvendor+json;version=1.',
    'with multiple periods' => 'application/vnd.myvendor+json;version=1.1.',
    'with patch version' => 'application/vnd.myvendor+json;version=1.1.1',
  },
  additions: [
    ',More headers= more good',
    ';More headers= more good',
    '; And.then,some;things!',
    '*More headers= more good',
    '+More headers= more good',
    ' additional th1ngs here',
    ' ',
    '$',
    '\b',
    "\n",
  ],
}

describe ApiVersions::VersionCheck do
  describe 'version_regex' do
    subject { described_class.new.send(:version_regex) }

    test_cases[:valid].each do |description, test_case|
      it "should match an isolated string #{description}" do
        should match(test_case[:string])
      end

      it "should match a string #{description} and appended content" do
        test_cases[:additions].each do |addition|
          should match("#{test_case[:string]}#{addition}")
        end
      end
    end

    test_cases[:invalid].each do |description, test_case|
      it "should not match an isolated string #{description}" do
        should_not match(test_case)
      end

      it "should not match a string #{description} and appended content" do
        test_cases[:additions].each do |addition|
          should_not match("#{test_case}#{addition}")
        end
      end
    end
  end

  describe 'matches_version?' do
    subject do
      described_class.new(version: version).send(:matches_version?, test_string)
    end

    test_cases[:valid].each do |description, test_case|
      let(:test_string) { test_case[:string] }
      let(:version) { test_case[:version] }

      it "should match the version of an isolated string #{description}" do
        should be true
      end

      context "with appended content" do
        test_cases[:additions].each do |addition|
          context 'new addition context' do
            let(:test_string) { "#{test_case[:string]}#{addition}" }
            let(:version) { test_case[:version] }

            it "should match the version of a string #{description}" do
              should be true
            end
          end
        end
      end
    end
  end

  describe 'matches?' do
    subject do
      described_class.new(version: version).matches?(test_request)
    end

    test_cases[:requests].each do |description, test_case|

      context 'with new match' do
        let(:test_request) { OpenStruct.new(headers: test_case[:headers]) }
        let(:version) { test_case[:version] }

        it "should match the version #{description}" do
          should be test_case[:matches]
        end
      end
    end
  end
end
