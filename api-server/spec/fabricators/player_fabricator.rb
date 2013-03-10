Fabricator(:player) do
  email { Faker::Internet.email }
  password { Faker::Lorem.characters(16) }
  password_confirmation { |attrs| attrs[:password] }
end
