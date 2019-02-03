class CreateRequestResults < ActiveRecord::Migration[5.2]
  def change
    create_table :request_results do |t|
      t.json :raw_data
      t.json :parsed_data

      t.timestamps
    end
  end
end
