class SorceryCore < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.string :email,            :default => nil, :null => false
      t.string :crypted_password, :default => nil, :null => false
      t.string :salt,             :default => nil, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :players
  end
end