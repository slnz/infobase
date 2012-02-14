ActiveSupport.on_load(:active_record) do
  ActiveRecord::ConnectionAdapters::OracleEnhancedAdapter.class_eval do
    # some sample settings that I use in my projects

    #self.emulate_integers_by_column_name = true
    #self.emulate_dates_by_column_name = true
    #self.emulate_booleans_from_strings = true

    # set string to date format if using e.g. calendar helpers

    # self.string_to_date_format = "%d.%m.%Y"
    # self.string_to_time_format = "%d.%m.%Y %H:%M:%S"

    # to ensure that sequences will start from 1 and without gaps
    self.default_sequence_start_value = "1 NOCACHE INCREMENT BY 1"

    # Cache column descriptions between requests.
    # Highly recommended as currently Arel is doing a lot of additional queries
    # to get table columns and primary key.
    # If this is used then you need to restart server in development environment
    # after running migrations which change table columns.
    # By default caching is enabled just in test and production environments.
    self.cache_columns = true
  end
end