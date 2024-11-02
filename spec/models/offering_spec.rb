require 'rails_helper'

RSpec.describe Offering, type: :model do
  describe '#valid' do
    context 'presence' do 
      it 'descrição não pode ficar em branco' do 
        user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
        restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                        cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                        city: "Ferraz de Vasconcelos", state: "SP",
                                        zip_code: "11111-111", user: user,
                                        district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
        dish = Dish.create!(name: 'Hamburguer', restaurant: restaurant, description: 'carne, mostarda, queijo')
        offering = Offering.new(offerable: dish)
        offering.price_histories.build(price: 30.0, effective_date: DateTime.now)

        offering.valid?
        expect(offering.errors.include? :description).to be true
        expect(offering.errors[:description]).to include 'não pode ficar em branco'
      end

      it 'deve estar associada a um prato ou bebida' do 
        user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
        restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                        cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                        city: "Ferraz de Vasconcelos", state: "SP",
                                        zip_code: "11111-111", user: user,
                                        district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
        offering = Offering.new(description: '2 Hamburgueres')
        offering.price_histories.build(price: 30.0, effective_date: DateTime.now)

        offering.valid?

        expect(offering.errors.include? :offerable_id).to be true
        expect(offering.errors[:offerable_id]).to include 'não pode ficar em branco'
      end

      it 'pode estar associada a um prato' do 
        user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
        restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                        cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                        city: "Ferraz de Vasconcelos", state: "SP",
                                        zip_code: "11111-111", user: user,
                                        district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
        dish = Dish.create!(name: 'Hamburguer', restaurant: restaurant, description: 'carne, mostarda, queijo')
        offering = Offering.new(offerable: dish, description: '2 Hamburgueres')
        offering.price_histories.build(price: 30.0, effective_date: DateTime.now)

        expect(offering).to be_valid

      end

      it 'pode estar associada a uma bebida' do 
        user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
        restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                        cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                        city: "Ferraz de Vasconcelos", state: "SP",
                                        zip_code: "11111-111", user: user,
                                        district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
        beverage = Beverage.create!(name: 'Coca-cola', restaurant: restaurant, description: 'delicioso tônico de Atlanta', alcoholic: :no)
        offering = Offering.new(offerable: beverage, description: '2 L')
        offering.price_histories.build(price: 30.0, effective_date: DateTime.now)

        expect(offering).to be_valid
      end

      it 'deve estar associada a um preço no histórico' do 
        user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
        restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                        cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                        city: "Ferraz de Vasconcelos", state: "SP",
                                        zip_code: "11111-111", user: user,
                                        district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
        beverage = Beverage.create!(name: 'Coca-cola', restaurant: restaurant, description: 'delicioso tônico de Atlanta', alcoholic: :no)
        offering = Offering.new(offerable: beverage, description: '2 L')
        
        expect(offering).not_to be_valid
      end
      
    end
  end
end
