class Version < ActiveRecord::Base
  belongs_to :application
  has_many :version_configurations
end
