Rails.application.routes.draw do
  scope "(:locale)", locale: /vi|en/ do
    get "static_pages/home"
    get "static_pages/help"
  end
end
