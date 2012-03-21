class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :q_text
      t.string :option_1
      t.string :option_2
      t.string :option_3
      t.string :option_4
      t.string :answer

      t.timestamps
    end
  end
end
