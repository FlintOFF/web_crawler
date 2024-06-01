# frozen_string_literal: true

module ScrapAndParse
  module V2
    class Organizer
      include Interactor::Organizer

      organize ::ScrapAndParse::Common::Scrap,
               ::ScrapAndParse::V2::Parse
    end
  end
end
