json.array!(@charts) do |chart|
  json.extract! chart, :id
  json.url chart_url(chart, format: :json)
end
