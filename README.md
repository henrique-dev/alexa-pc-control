# Alexa Control My PC
Application made in order to handle requests received by alexa in order to control computer functions such as turning on, turning off and opening programs.

## Requirements
- ruby 3.1.0
- ngrok

## To run
Execute ngrok with:
```
ngrok http 3000
```
Copy and paste in place of the host placed here:
> config/application.rb
```ruby
...
  config.hosts << "7c0d-2804-431-d7fe-ec2a-1912-8228-864b-ef46.sa.ngrok.io"
...
```

And to run the application just execute the following commands:
```
bundle install
rails s
```

## Configuring some things
You need to create a machine with your computer information such as ip, name and port to access.
```ruby
Alexa::Computer.create(network_ip: '127.0.0.1', network_name: 'henrique', network_port: '4567')
```
