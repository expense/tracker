json.array!(@statements) do |statement|
  json.extract! statement, :id, :command, :params, :comment, :time
  json.url statement_url(statement, format: :json)
end
