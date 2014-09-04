json.array!(@items) do |item|
  json.extract! item, :id, :command, :comment
  json.url item_url(item, format: :json)
end
