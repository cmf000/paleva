require 'rails_helper'

RSpec.describe Menu, type: :model do
  describe '#presence' do
    context 'uniqueness' do 
      it 'nome deve ser único' do
        user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
        restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                          cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                          city: "Ferraz de Vasconcelos", state: "SP",
                                          zip_code: "11111-111", owner: user,
                                          district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
        Menu.create!(name: 'Jantar', restaurant: restaurant)
        menu = Menu.new(name: 'jantar', restaurant: restaurant)

        expect(menu).not_to be_valid
      end
    end

    context 'presence' do
      it 'nome é obrigatório' do
        user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
        restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                          cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                          city: "Ferraz de Vasconcelos", state: "SP",
                                          zip_code: "11111-111", owner: user,
                                          district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
        menu = Menu.new(restaurant: restaurant)

        expect(menu).not_to be_valid
      end
    end
  end
end
