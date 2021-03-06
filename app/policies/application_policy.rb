class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def new?
    create?
  end

  def edit?
    update?
  end

  def create?
    false
  end

  def update?
    false
  end

  def destroy?
    false
  end

  def access_flag_stamps?
    admin? && user.flag_stamps
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end

  private

  def user?
    user.present?
  end

  def moderator?
    user? && user.moderator?
  end

  def admin?
    user? && user.admin?
  end
end
