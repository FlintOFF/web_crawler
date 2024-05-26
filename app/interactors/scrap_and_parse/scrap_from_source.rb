require 'open-uri'
require 'uri'

module ScrapAndParse
  class ScrapFromSource
    include Interactor

    def call
      return if context.content

      begin
        content = URI(context.params[:url])&.open(&:read)
      rescue NoMethodError
        context.fail!(message: I18n.t('interactors.errors.invalid_url'))
      rescue OpenURI::HTTPError
        context.fail!(message: I18n.t('interactors.errors.page_load'))
      end

      context.content = content
    end
  end
end
