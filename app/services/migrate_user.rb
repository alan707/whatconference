# Take all the stuff associated with the former user and move it to the
# current user
class MigrateUser
  attr_private_initialize :current_user, :former_user

  def call
    migrate_comments
    migrate_conferences
    migrate_followings
    delete_former_user
  end

  def migrate_comments
    former_user.comments.update_all(:user_id => current_user.id)
  end

  def migrate_conferences
    former_user.created_conferences.update_all(:creation_user_id => current_user.id)
  end

  def migrate_followings
    current_user.conferences << former_user.conferences
  end

  def delete_former_user
    former_user.destroy
  end
end
