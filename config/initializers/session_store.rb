require 'action_dispatch/middleware/session/dalli_store'
Infobase::Application.config.session_store :dalli_store, :memcache_server => ['127.0.0.1'], :namespace => 'sessions', :key => '_infobase_session', :expire_after => 1.hour
