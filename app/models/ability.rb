class Ability
  include CanCan::Ability

  def initialize(user)
     user ||= User.new # guest user (not logged in)
     if user.has_role? :admin
       can :manage, :all
     else
       can :read, :all
       can :write, :all if user.has_role?(:editor)
       can :read, :all if user.has_role?(:reader)
     end
  end
end
