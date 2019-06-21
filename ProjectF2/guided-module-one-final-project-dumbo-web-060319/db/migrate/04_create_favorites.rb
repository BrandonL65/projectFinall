
class CreateFavorites < ActiveRecord::Migration[4.2]

    def change 
        create_table :favorites do |t|
            t.string :quote
            t.string :candidate
        end
    end
end