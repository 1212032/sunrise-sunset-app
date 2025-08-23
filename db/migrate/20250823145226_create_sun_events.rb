class CreateSunEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :sun_events do |t|
      t.date :date
      t.string :sunrise
      t.string :sunset
      t.string :first_light
      t.string :last_light
      t.string :dawn
      t.string :dusk
      t.string :solar_noon
      t.string :golden_hour
      t.string :day_length
      t.string :timezone
      t.integer :utc_offset
      t.string :location
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
