class AddTimestampsToPosts < ActiveRecord::Migration[7.0]
  def change
    unless column_exists?(:posts, :created_at)
      add_timestamps :posts, default: -> { 'NOW()' }, null: false
    end
  end
end
