Fabricator(:character) do
  name { Faker::Lorem.characters(12) }
  str { rand(3..18) }
  dex { rand(3..18) }
  con { rand(3..18) }
  int { rand(3..18) }
  wis { rand(3..18) }
  cha { rand(3..18) }
end
