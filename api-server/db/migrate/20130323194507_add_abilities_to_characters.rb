class AddAbilitiesToCharacters < ActiveRecord::Migration
  def change
    add_column :characters, :str, :integer, null: false, default: 10, limit: 2
    add_column :characters, :dex, :integer, null: false, default: 10, limit: 2
    add_column :characters, :con, :integer, null: false, default: 10, limit: 2
    add_column :characters, :int, :integer, null: false, default: 10, limit: 2
    add_column :characters, :wis, :integer, null: false, default: 10, limit: 2
    add_column :characters, :cha, :integer, null: false, default: 10, limit: 2
  end
end
