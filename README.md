## Description

Ruby library for using the TurboBridge conference calling API described at http://www.turbobridge.com/api/2.0/

* Currently supports all operations on Bridge objects only
* Converts between API camelCase and ruby underscoring for attribute names
* All methods raise exceptions upon failure

## Usage

Before doing anything, you need to configure the gem with your account info:

    TurboBridge::Config.merge(
        account_id: 123455,
        email: api_account@example.com,
        password: verysecret
    )
    
Then you can go ahead and play with bridges:

    conf_id = '04567'
    bridge = TurboBridge::Bridge.create!(conference_id: conf_id, name: "My Bridge")
    bridge = TurboBridge::Bridge.find(conf_id)
    bridge.update_attributes!(entry_chimes: 'none')
    bridge.destroy! or TurboBridge::Bridge.destroy!(conf_id)

## Running the Specs

Note that the specs run LIVE tests against TurboBridge, and require real account info to do so; you will need to create a 'test_config.yml' file with access credentials; see `test_config.yml.example` for the format.

The tests will create (and if successful, clean up) a test bridge with conference ID 5555555555.
