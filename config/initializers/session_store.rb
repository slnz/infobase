# Be sure to restart your server when you modify this file.

#Infobase::Application.config.session_store :cookie_store, key: '_infobase_session'

require 'action_dispatch/middleware/session/dalli_store'
Infobase::Application.config.session_store :dalli_store, :memcache_server => ['127.0.0.1'], :namespace => 'sessions', :key => '_infobase_session', :expire_after => 1.hour
