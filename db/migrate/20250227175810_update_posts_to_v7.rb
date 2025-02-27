class UpdatePostsToV7 < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :post_id, :bigint
    remove_column :posts, :parent_post_id
    
  end
end
