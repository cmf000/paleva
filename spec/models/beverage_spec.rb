require 'rails_helper'

RSpec.describe Beverage, type: :model do
  describe '#valid' do
    context 'presence' do
      it 'nome não pode ficar em branco' do 
        user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
        restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                        cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                        city: "Ferraz de Vasconcelos", state: "SP",
                                        zip_code: "11111-111", owner: user,
                                        district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
        beverage = Beverage.new(restaurant: restaurant, description: '2L')
        beverage.valid?

        expect(beverage.errors.include? :name).to be true
        expect(beverage.errors[:name]).to include 'não pode ficar em branco'
      end

      it 'descrição não pode ficar em branco' do 
        user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
        restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                        cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                        city: "Ferraz de Vasconcelos", state: "SP",
                                        zip_code: "11111-111", owner: user,
                                        district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
        beverage = Beverage.new(restaurant: restaurant, name: 'Coca-cola')
        beverage.valid?

        expect(beverage.errors.include? :description).to be true
        expect(beverage.errors[:description]).to include 'não pode ficar em branco'
      end
    end

    it 'calorias é um inteiro positivo' do
      user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
      restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                      cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                      city: "Ferraz de Vasconcelos", state: "SP",
                                      zip_code: "11111-111", owner: user,
                                      district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
      beverage = Beverage.new(restaurant: restaurant, name: 'Coca-cola', description: '2L', calories: -1000)
      beverage.valid?
      
      expect(beverage.errors.include? :calories).to be true
      expect(beverage.errors[:calories]).to include 'deve ser maior ou igual a 0'
    end
  end

  it 'status ao ser criada é ativo' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    beverage = Beverage.new(restaurant: restaurant, name: 'Coca-cola', description: '2L', calories: 1000)
    
    expect(beverage).to be_active
  end
end
