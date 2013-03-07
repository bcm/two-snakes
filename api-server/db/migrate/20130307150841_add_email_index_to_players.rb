class AddEmailIndexToPlayers < ActiveRecord::Migration
  def up
    add_index :players, :email, unique: true
    execute "CREATE UNIQUE INDEX players_email_lower_index ON players(LOWER(email))"
  end

  def down
    remove_index :players, :email
    execute "DROP INDEX IF EXISTS players_email_lower_index"
  end
end
