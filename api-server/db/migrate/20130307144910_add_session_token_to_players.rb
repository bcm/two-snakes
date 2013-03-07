class AddSessionTokenToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :session_token, :string, limit: 20
    add_index :players, :session_token, unique: true
  end
end
