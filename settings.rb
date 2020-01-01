class Settings
  FILE_NAME = "#{File.dirname(__FILE__)}/settings.dat"

  class SettingsObject
    def initialize
      @last_hunt = Time.now
      @hunt = true
    end

    def to_s
      instance_variables.map{ |ivar|
        "#{ivar} => #{instance_variable_get ivar}"
      }.join('; ')
    end

    attr_accessor :last_hunt, :hunt
  end

  at_exit { self.marshal_dump }

  def self.marshal_load
    begin
      @settings = Marshal.load(File.read(FILE_NAME))
    rescue
      @settings = SettingsObject.new
    end
  end

  if @settings.nil?
    self.marshal_load
  end

  def self.marshal_dump
    open(FILE_NAME, 'wb') { |f| f.puts Marshal.dump(@settings) }
  end

  def self.get
    @settings
  end
end