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

  def follow?
    true
  end

  def destroy?
    # Same user who created a conference can destroy it
    user.id == record.creation_user_id
  end
end
