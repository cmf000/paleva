require 'rails_helper'

RSpec.describe Offering, type: :model do
  describe '#valid' do
    context 'presence' do 
      it 'descrição não pode ficar em branco' do 
        user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
        restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                        cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                        city: "Ferraz de Vasconcelos", state: "SP",
                                        zip_code: "11111-111", owner: user,
                                        district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
        dish = Dish.create!(name: 'Hamburguer', restaurant: restaurant, description: 'carne, mostarda, queijo')
        offering = Offering.new(offerable: dish, current_price: 15.00, effective_at: DateTime.now)
        offering.price_histories.build(price: 30.0, effective_at: DateTime.now - 1.week)

        offering.valid?
        expect(offering.errors.include? :description).to be true
        expect(offering.errors[:description]).to include 'não pode ficar em branco'
      end

      it 'deve estar associada a um prato ou bebida' do 
        user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
        restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                        cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                        city: "Ferraz de Vasconcelos", state: "SP",
                                        zip_code: "11111-111", owner: user,
                                        district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
        offering = Offering.new(description: '2 Hamburgueres')
        offering.price_histories.build(price: 30.0, effective_at: DateTime.now)

        offering.valid?

        expect(offering.errors.include? :offerable_id).to be true
        expect(offering.errors[:offerable_id]).to include 'não pode ficar em branco'
      end

      it 'pode estar associada a um prato' do 
        user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
        restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                        cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                        city: "Ferraz de Vasconcelos", state: "SP",
                                        zip_code: "11111-111", owner: user,
                                        district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
        dish = Dish.create!(name: 'Hamburguer', restaurant: restaurant, description: 'carne, mostarda, queijo')
        offering = Offering.new(offerable: dish, description: '2 Hamburgueres', current_price: 15.00, effective_at: DateTime.now)
        offering.price_histories.build(price: 30.0, effective_at: DateTime.now - 1.week)

        expect(offering).to be_valid

      end

      it 'pode estar associada a uma bebida' do 
        user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
        restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                        cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                        city: "Ferraz de Vasconcelos", state: "SP",
                                        zip_code: "11111-111", owner: user,
                                        district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
        beverage = Beverage.create!(name: 'Coca-cola', restaurant: restaurant, description: 'delicioso tônico de Atlanta', alcoholic: :no)
        offering = Offering.new(offerable: beverage, description: '2 L', current_price: 10.00, effective_at: DateTime.now)
        offering.price_histories.build(price: 30.0, effective_at: DateTime.now - 1.week)

        expect(offering).to be_valid
      end

      it 'preço é obrigatório' do 
        user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
        restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                        cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                        city: "Ferraz de Vasconcelos", state: "SP",
                                        zip_code: "11111-111", owner: user,
                                        district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
        beverage = Beverage.create!(name: 'Coca-cola', restaurant: restaurant, description: 'delicioso tônico de Atlanta', alcoholic: :no)
        offering = Offering.new(offerable: beverage, description: '2 L', effective_at: DateTime.now)
        
        expect(offering).not_to be_valid
      end
    end

    it 'a data é criada automaticamente para agora' do
      user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
      restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                      cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                      city: "Ferraz de Vasconcelos", state: "SP",
                                      zip_code: "11111-111", owner: user,
                                      district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
      beverage = Beverage.create!(name: 'Coca-cola', restaurant: restaurant, description: 'delicioso tônico de Atlanta', alcoholic: :no)
      offering = Offering.create!(offerable: beverage, current_price: 10,  description: '2 L')

      expect(offering).not_to be_nil
    end

    it 'preço só pode ser alterado para um valor diferente' do
      user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
      restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                      cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                      city: "Ferraz de Vasconcelos", state: "SP",
                                      zip_code: "11111-111", owner: user,
                                      district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
      beverage = Beverage.create!(name: 'Coca-cola', restaurant: restaurant, description: 'delicioso tônico de Atlanta', alcoholic: :no)
      offering = Offering.create!(offerable: beverage, current_price: 10,  description: '2 L')
      offering.update(current_price: 10)

      expect(offering).not_to be_valid
    end

    it 'preço deve ser positivo' do
      user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
      restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                      cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                      city: "Ferraz de Vasconcelos", state: "SP",
                                      zip_code: "11111-111", owner: user,
                                      district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
      beverage = Beverage.create!(name: 'Coca-cola', restaurant: restaurant, description: 'delicioso tônico de Atlanta', alcoholic: :no)
      offering = Offering.new(offerable: beverage, current_price: -10.0,  description: '2 L')

      expect(offering).not_to be_valid
    end
  end
end
