json.array!(@studies) do |study|
  json.extract! study, :id
  json.url study_url(study, format: :json)
end
