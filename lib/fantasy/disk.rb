require "json"
require "ostruct"
require "fileutils"

module Disk
  @@data_path = "#{Dir.pwd}/disk/data.json"
  @@data = nil

  def self.data
    @@data ||= OpenStruct.new(load)
  end

  def self.save
    dirname = File.dirname(@@data_path)
    unless File.directory?(dirname)
      FileUtils.mkdir_p(dirname)
    end

    File.open(@@data_path, "w") { |f| f.write JSON.pretty_generate(@@data.to_h) }
  end

  private

  def self.load
    if File.file?(@@data_path)
      JSON.parse(File.read(@@data_path))
    else
      {}
    end
  end
end
