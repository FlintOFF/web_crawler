# frozen_string_literal: true

module ScrapAndParse
  module V1
    class Organizer
      include Interactor::Organizer

      organize ::ScrapAndParse::Common::Scrap,
               ::ScrapAndParse::V1::Parse
    end
  end
end
