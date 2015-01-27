require 'spec_helper'

test_cases = {
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
      described_class.new.send(:matches_version?, test_string)
    end

    test_cases[:valid].each do |description, test_case|
      let(:test_string) { test_case[:string] }

      it "should match the version of an isolated string #{description}" do
        instance_variable_set(:@process_version, test_case[:version])
        should be true
      end

      context "with appended content" do
        test_cases[:additions].each do |addition|
          let(:test_string) { "#{test_case[:string]}#{addition}" }

          it "should match the version of a string #{description}" do
            instance_variable_set(:@process_version, test_case[:version])
            should be true
          end
        end
      end
    end
  end
end
