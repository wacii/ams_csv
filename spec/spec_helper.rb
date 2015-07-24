require 'rails'
require 'action_controller'
require 'action_controller/railtie'
require 'rspec/rails'
require 'pry'

require 'active_model'
require 'active_model_csv_serializers'

class DummyApp < Rails::Application
  config.eager_load = false
  config.secret_key_base = 'abc123'
end
DummyApp.initialize!

Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each {|f| require f}

RSpec.configure do |config|
  config.order = :random
end

class Post
  include ActiveModel::Model
  include ActiveModel::Serialization

  attr_accessor :name, :body, :comments, :author, :category
end

class PostCsvSerializer < ActiveModel::CsvSerializer
  attributes :name, :body
  has_many :comments
  has_one :author
  has_one :category
end

class Post2CsvSerializer < PostCsvSerializer
  attributes :name, :body

  def name
    'pie'
  end
end

class Post3CsvSerializer < ActiveModel::CsvSerializer
  attributes :name
  attributes :body
end

#

class Comment
  include ActiveModel::Model
  include ActiveModel::Serialization

  attr_accessor :text
end

class CommentCsvSerializer < ActiveModel::CsvSerializer
  attributes :text
end

#

class Photo
  include ActiveModel::Model
  include ActiveModel::Serialization
end

#

class Author
  include ActiveModel::Model
  include ActiveModel::Serialization

  attr_accessor :name, :category
end

class AuthorCsvSerializer < ActiveModel::CsvSerializer
  attributes :name

  has_one :category
end

#

class Category
  include ActiveModel::Model
  include ActiveModel::Serialization

  attr_accessor :name
end

class CategoryCsvSerializer < ActiveModel::CsvSerializer
  attributes :name
end
