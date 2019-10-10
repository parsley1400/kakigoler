require 'bundler/setup'
Bundler.require

if development?
  ActiveRecord::Base.establish_connection('sqlite3:db/development.db')
end

class User < ActiveRecord::Base
  has_secure_password
  validates :username,
    presence: true
  has_many :contributions
  has_many :favorites
end

class Contribution < ActiveRecord::Base
  validates :image,
    presence: true
  belongs_to :users
  has_many :favorites
  has_many :users, through: :favorites
  has_many :contribution_tags
  has_many :tags, through: :contribution_tags
  belongs_to :sweets
  belongs_to :ices
  belongs_to :sizes
  belongs_to :plos
end

class Favorite < ActiveRecord::Base
  belongs_to :users
  belongs_to :contributions
end

class Tag < ActiveRecord::Base
  validates :name,
    presence: true
  has_many :contribution_tags
  has_many :contributions, through: :contribution_tags
end

class ContributionTag < ActiveRecord::Base
  belongs_to :contributions
  belongs_to :tags
end

class Sweet < ActiveRecord::Base
  validates :sweet_n,
    presence: true
  has_many :contributions
end

class Ice < ActiveRecord::Base
  validates :ice_n,
    presence: true
  has_many :contributions
end

class Size < ActiveRecord::Base
  validates :size_n,
    presence: true
  has_many :contributions
end

class Plo < ActiveRecord::Base
  validates :plo_n,
    presence: true
  has_many :contributions
end