# frozen_string_literal: true

require "yaml"

module Plugin::Saizeriya
  MENU = open(File.join(__dir__, 'menu.yml'), "r") {|f| YAML.load(f) }
  KEY_MATCHER = Regexp.union(*MENU.keys)

  class SaizeriyaNote < Diva::Model
    register :score_text, name: "Saizeriya Note"

    field.string :code, required: true

    def description
      MENU[code]
    end

    def inspect
      "saizeriya note(#{description})"
    end
  end
end

Plugin.create(:mikutter_saizeriya) do

  filter_score_filter do |target_model, note, yielder|
    if target_model != note
      text = note.description
      matched = Plugin::Saizeriya::KEY_MATCHER.match(text)

      if matched
        score = Array.new
        if matched.begin(0) != 0
          score << Plugin::Score::TextNote.new(
            description: text[0...matched.begin(0)])
        end
        #score << Diva::Model(:web).new(perma_link: matched.to_s)
        score << Plugin::Saizeriya::SaizeriyaNote.new(code: matched.to_s)
        if matched.end(0) != text.size
          score << Plugin::Score::TextNote.new(
            description: text[matched.end(0)..text.size])
        end

        yielder << score
      end
    end
    [target_model, note, yielder]
  end

end
