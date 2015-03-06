class ConferencePolicy < ApplicationPolicy
  def index?
    true
  end

  def autocomplete?
    true
  end

  def create?
    true
  end

  def update?
    true
  end

  def upvote?
    true
  end

  def destroy?
    # Same user who created a conference can destroy it
    user.id == record.user_id
  end
end
