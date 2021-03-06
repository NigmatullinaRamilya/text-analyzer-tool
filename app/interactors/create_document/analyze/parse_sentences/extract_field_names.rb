module CreateDocument
  module Analyze
    module ParseSentences
      class ExtractFieldNames
        include Interactor

        RESERVED_WORDS = %w[the a has and have field fields].freeze

        delegate :sentences, :models_list, to: :context

        def call
          field_sentences.each { |sentence| add_field(sentence) }
        end

        private

        def field_sentences
          sentences.select { |sentence| sentence.template_kind == "field" }
        end

        def add_field(sentence)
          model_and_field_names = sentence.text.split(%r{\s|,\s})
          model_and_field_names -= RESERVED_WORDS

          model_name = normalize(model_and_field_names[0]).classify
          field_names = model_and_field_names[1..-1]

          return unless exists?(model_name)

          field_names.each do |field_name|
            models_list.select do |model|
              next unless model[:name] == model_name

              model[:fields] << field_structure(field_name)
            end
          end
        end

        def exists?(model_name)
          models_list.select { |model| model[:name] == model_name }.any?
        end

        def normalize(word)
          lemmatizer.lemma(word)
        end

        def lemmatizer
          @lemmatizer ||= Lemmatizer.new
        end

        def field_structure(field_name)
          {
            name: field_name,
            required: false,
            type: "string"
          }
        end
      end
    end
  end
end
