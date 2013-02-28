require File.join(File.dirname(__FILE__), 'spec_helper')

describe TurboBridge::Util do

  describe ".format_phone_number" do
    context "US numbers" do
      [4152980615, '(415) 298-0615', '+14152980615', '415.298.0615'].each do |num|
        describe "#{num} should format to +14152980615" do
          subject { TurboBridge::Util.format_phone_number(num) }
          it{ should == '+14152980615' }
        end
      end
    end
  end
end