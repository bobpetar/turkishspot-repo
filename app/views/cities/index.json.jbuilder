json.array!(@cities) do |city|
  json.extract! city, :id, :first_name, :last_name, :email, :about, :city_name
  json.url city_url(city, format: :json)
end
