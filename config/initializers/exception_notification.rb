Infobase::Application.config.middleware.use ExceptionNotifier,
    :email_prefix => "[Infobase] ",
    :sender_address => %{ib_error@uscm.org},
    :exception_recipients => %w{justin.sabelko@uscm.org}