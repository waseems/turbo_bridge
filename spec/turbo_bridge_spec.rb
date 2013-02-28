require File.join(File.dirname(__FILE__), 'spec_helper')

TEST_CONFERENCE_ID = '5555555555'

describe "TurboBridge" do
  before(:all) do
    # Make sure our test conference doesn't already exist
    begin
      TurboBridge::Bridge.destroy!(TEST_CONFERENCE_ID)
    rescue TurboBridge::Bridge::Error::BridgeNotFound
    end
  end

  it "bridge lifecycle" do
    conf_id = TEST_CONFERENCE_ID

    ->() do
      TurboBridge::Bridge.find(conf_id)
    end.should raise_error(TurboBridge::Bridge::Error::BridgeNotFound)

    @bridge = TurboBridge::Bridge.create!(conference_id: conf_id, name: "Automated Test Bridge; Nuke at Will")
    @bridge.conference_id.should == conf_id

    found = TurboBridge::Bridge.find(conf_id)
    found.entry_chimes.should == 'chime'

    @bridge.update_attributes!(entry_chimes: 'none')

    found = TurboBridge::Bridge.find(conf_id)
    found.entry_chimes.should == 'none'

    ->() do
      TurboBridge::Bridge.create!(conference_id: conf_id)
    end.should raise_error(TurboBridge::Bridge::Error::ConferenceAlreadyExists)

    @bridge.destroy!

    ->() do
      TurboBridge::Bridge.find(conf_id)
    end.should raise_error(TurboBridge::Bridge::Error::BridgeNotFound)

    ->() do
      @bridge.update_attributes!(name: 'Zombie Bridge')
    end.should raise_error(TurboBridge::Bridge::Error::BridgeNotFound)

    # Now if we re-create it, it should start over with default properties
    reanimated = TurboBridge::Bridge.create!(conference_id: conf_id)
    reanimated.entry_chimes.should == 'chime'

    # Destroy it the other way, direct by id
    TurboBridge::Bridge.destroy!(conf_id)
    ->() do
      TurboBridge::Bridge.find(conf_id)
    end.should raise_error(TurboBridge::Bridge::Error::BridgeNotFound)
  end

  context "live manager" do
    before do
      conf_id = TEST_CONFERENCE_ID
      @bridge = TurboBridge::Bridge.create!(conference_id: conf_id, name: "Automated Test Bridge; Nuke at Will")
      @manager = TurboBridge::LiveManager.new(conference_id: conf_id)
    end
    it "can make calls" do
      @manager.make_call(:number => '4152980615')
    end

  end

  context "any API call" do
    subject do
      TurboBridge::Bridge.find("123456")
    end

    it "authentication failure" do
      TurboBridge::Config.stub(:password).and_return {"foo"}
      ->() {subject}.should raise_error(TurboBridge::Api::Error) {|err| err.code.should == "ERR_API_INVALID_LOGIN"}
    end

    it "network failure" do
      TurboBridge::Config.stub(:api_url).and_return("http://nonexistent.nowhere:1/")
      TurboBridge::Api.configure_connection
      ->() {subject}.should raise_error(Faraday::Error::ConnectionFailed)
    end
  end
end