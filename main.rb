require "rubygems"
require "yaml"
require "pp"


YAML::load(File.open("setting.yml")).each do |setting|

	pp setting

end

