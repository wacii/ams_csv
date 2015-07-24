require 'spec_helper'

describe 'csv renderer', type: :controller do
  controller do
    def object
      render csv: Post.new(name: 'a')
    end

    def array
      render csv: [Post.new(name: 'b'), Category.new(name: 'c')]
    end
  end

  before do
    routes.draw { get ':controller/:action' }
  end

  it 'renders an object' do
    get :object
    expect(response.body).to include('a')
  end

  it 'renders an array' do
    get :array
    expect(response.body).to include('b')
    expect(response.body).to include('c')
  end

  describe 'filename option'
  describe 'serializer option'
  describe 'each_serializer option'
end
