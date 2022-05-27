module Alexa
  class Program
    include Mongoid::Document
    include Mongoid::Timestamps

    field :name,                        type: String
    field :type,                        type: String # execute, list_and_execute
    field :routes,                      type: Array
    field :paths,                       type: Array
    field :commands,                    type: Array
    field :prompts,                     type: Array

    validates_presence_of :name, :type, :paths, :commands
  end
end
