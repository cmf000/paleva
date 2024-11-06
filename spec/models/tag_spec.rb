require 'rails_helper'

RSpec.describe Tag, type: :model do
  context '#valid?' do
    it 'nome é obrigatório' do 
      tag = Tag.new

      expect(tag).not_to be_valid
    end

    it 'nome é deve ser único' do 
      tag = Tag.create!(name: :vegan)
      other_tag = Tag.new(name: :vegan)

      expect(other_tag).not_to be_valid
    end
  end
end
