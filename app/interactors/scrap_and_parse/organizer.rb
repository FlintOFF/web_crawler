module ScrapAndParse
  class Organizer
    include Interactor::Organizer

    organize ScrapFromCache,
             ScrapFromSource,
             Parse
  end
end
