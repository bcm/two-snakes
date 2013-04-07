ActiveSupport.on_load(:active_record) do
  self.schema_format = :sql
end
