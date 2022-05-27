module Alexa
  class Computer
    include Mongoid::Document
    include Mongoid::Timestamps

    field :network_ip,                    type: String
    field :network_name,                  type: String
    field :network_port,                  type: String
  end
end
