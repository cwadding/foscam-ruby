# Foscam::Ruby

A client library written in ruby to communicate to your [foscam webcam](http://www.foscam.com/) using the [foscam SDK](http://site.usajumping.com/Download/ipcam_cgi_sdk.pdf).

## Installation

Add this line to your application's Gemfile:

    gem 'foscam-ruby'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install foscam-ruby

## Usage
    
    # Connecting to a camera
    client = Foscam::Client.new(url: http://192.168.0.1/, username: 'admin', password: 'secret')
    
    # Capturing the current Image
    client.snapshot # => 
    
    # Controlling the pan or tilt of camera
    client.decoder_control(:up)
    client.decoder_control(:stop_up)
    client.decoder_control(:left)
    client.decoder_control(:horizontal_patrol)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
