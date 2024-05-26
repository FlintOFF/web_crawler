# frozen_string_literal: true

module ScrapAndParse
  class Organizer
    include Interactor::Organizer

    organize Scrap, Parse
  end
end
