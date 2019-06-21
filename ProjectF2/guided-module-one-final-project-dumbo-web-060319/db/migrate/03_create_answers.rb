
class CreateAnswers < ActiveRecord::Migration[4.2]

    def change 
        create_table :answers do |t|
            t.integer :quote_id
            t.integer :candidate_id
        end
    end 
end