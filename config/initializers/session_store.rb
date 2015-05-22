# Be sure to restart your server when you modify this file.

#Rails.application.config.session_store :cookie_store, key: '_muzmongki-web_session'
MuzmongkiWeb::Application.config.session_store :mongoid_store
MongoSessionStore.collection_name = "sessions"