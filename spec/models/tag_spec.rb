require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe '#valid?' do
    context 'presence' do 
      it 'nome é obrigatório' do 
        user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
        restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                      cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                      city: "Ferraz de Vasconcelos", state: "SP",
                                      zip_code: "11111-111", owner: user,
                                      district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
        tag = Tag.new(restaurant: restaurant)
  
        expect(tag).not_to be_valid
      end
  
      it 'nome é deve ser único' do 
        user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
        restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                      cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                      city: "Ferraz de Vasconcelos", state: "SP",
                                      zip_code: "11111-111", owner: user,
                                      district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
        tag = Tag.create!(restaurant: restaurant, name: :vegan)
        other_tag = Tag.new(restaurant: restaurant, name: :vegan)
        expect(other_tag).not_to be_valid
      end

      it 'restaurante é obrigatório' do 
        tag = Tag.new(name: :vegan)
  
        expect(tag).not_to be_valid
      end
    end
  end
end
