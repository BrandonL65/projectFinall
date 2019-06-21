
class CreateQuotes < ActiveRecord::Migration[4.2]
    def change 
        create_table :quotes do |t|
            t.integer :isFav
            t.string :content
        end
    end
end