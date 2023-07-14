# frozen_string_literal: true

require "yaml"

Plugin.create(:mikutter_saizeriya) do

  menu = open(File.join(__dir__, 'menu.yml'), "r") {|f| YAML.load(f) }

  filter_extract_receive_message do |slug, statuses|
    statuses.select {|status| menu.each {|k, v| status.message.description.sub!(k.to_s, v)} }
    [slug, statuses]
  end
end
