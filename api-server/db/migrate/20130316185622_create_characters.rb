class CreateCharacters < ActiveRecord::Migration
  def up
    create_table :characters do |t|
      t.string :name, null: false, limit: 32
      t.integer :player_id, null: false
      t.timestamps
    end
    add_index :characters, :name, unique: true
    execute "CREATE UNIQUE INDEX characters_name_lower_index ON characters(LOWER(name))"
    add_index :characters, :player_id
  end

  def down
    drop_table :characters
  end
end
