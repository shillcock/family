class RemoveNullConstraintFromPostsAndComments < ActiveRecord::Migration
  def change
    change_column_null(:posts, :content, true)
    change_column_null(:comments, :content, true)
  end
end
