class CreateHearts < ActiveRecord::Migration
  def change
    create_table :hearts do |t|
      t.references :lovable, polymorphic: true, index: true, null: false
      t.references :user, index: true, null: false

      t.timestamps null: false
    end

    add_index :hearts, [:user_id, :lovable_id]
  end
end

