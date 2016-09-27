class AnswerPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end
  
  def create?
    user.admin? || user
  end
  
  def update?
    user.admin? || user == record.user
  end
  
  def destroy?
    update?
  end
end
