require 'rails_helper'

RSpec.describe Dish, type: :model do
  describe '#valid' do
    context 'presence' do
      it 'nome não pode ficar em branco' do 
        user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
        restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                        cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                        city: "Ferraz de Vasconcelos", state: "SP",
                                        zip_code: "11111-111", owner: user,
                                        district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
        dish = Dish.new(restaurant: restaurant, description: 'carne, mostarda, queijo')
        dish.valid?

        expect(dish.errors.include? :name).to be true
        expect(dish.errors[:name]).to include 'não pode ficar em branco'
      end

      it 'descrição não pode ficar em branco' do 
        user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
        restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                        cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                        city: "Ferraz de Vasconcelos", state: "SP",
                                        zip_code: "11111-111", owner: user,
                                        district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
        dish = Dish.new(restaurant: restaurant, name: 'Hamburguer')
        dish.valid?

        expect(dish.errors.include? :description).to be true
        expect(dish.errors[:description]).to include 'não pode ficar em branco'
      end
    end

    it 'calorias é um inteiro positivo' do
      user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
      restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                      cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                      city: "Ferraz de Vasconcelos", state: "SP",
                                      zip_code: "11111-111", owner: user,
                                      district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
      dish = Dish.new(restaurant: restaurant, name: 'Hamburguer', description: 'carne, queijo, mostarda', calories: -1000)
      dish.valid?
      
      expect(dish.errors.include? :calories).to be true
      expect(dish.errors[:calories]).to include 'deve ser maior ou igual a 0'
    end

    it 'status ao ser criado é ativo' do
      user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
      restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                      cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                      city: "Ferraz de Vasconcelos", state: "SP",
                                      zip_code: "11111-111", owner: user,
                                      district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
      dish = Dish.new(restaurant: restaurant, name: 'Hamburguer', description: 'carne, queijo, mostarda', calories: -1000)
      
      expect(dish).to be_active
    end
  end
end
