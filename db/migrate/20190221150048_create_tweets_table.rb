class CreateTweetsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :tweets, id: :uuid, default: "gen_random_uuid()" do |t|
      t.text :tweet, null: false
      t.uuid :author_id, null: false

      t.timestamps
    end
  end
end
