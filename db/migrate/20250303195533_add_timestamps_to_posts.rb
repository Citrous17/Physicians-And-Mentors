class AddTimestampsToPosts < ActiveRecord::Migration[6.0]
  def change
    add_timestamps :posts, default: -> { 'CURRENT_TIMESTAMP' }, null: false
  end
end