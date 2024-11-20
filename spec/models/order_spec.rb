require 'rails_helper'

RSpec.describe Order, type: :model do
  describe '#valid?' do
    it 'Nome do cliente é obrigatório' do 
      user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
      restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
      cpf = CPF.generate
      new_employee = NewEmployee.create!(restaurant: restaurant, cpf: cpf, email: 'gertrudes@email.com')
      employee = User.create!(email: 'gertrudes@email.com', name: 'Gertrudes', cpf: cpf, password: 'asdflakjsdbnçfqbwkejb')

      order = Order.new(cpf: CPF.generate, email: 'eustaquio@email.com', phone_number: '11933301090')

      expect(order).not_to be_valid
    end

    it 'E-mail ou Telefone deve ser fornecido' do 
      user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
      restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
      cpf = CPF.generate
      new_employee = NewEmployee.create!(restaurant: restaurant, cpf: cpf, email: 'gertrudes@email.com')
      employee = User.create!(email: 'gertrudes@email.com', name: 'Gertrudes', cpf: cpf, password: 'asdflakjsdbnçfqbwkejb')

      order = Order.new(customer_name: 'Eustáquio', cpf: CPF.generate, email: 'eustaquio@email.com')
      order_1 = Order.new(customer_name: 'Eustáquio', cpf: CPF.generate, phone_number: '11933301020')

      expect(order).not_to be_valid
      expect(order_1).not_to be_valid
    end

    it 'E-mail deve ser válido' do 
      user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
      restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
      cpf = CPF.generate
      new_employee = NewEmployee.create!(restaurant: restaurant, cpf: cpf, email: 'gertrudes@email.com')
      employee = User.create!(email: 'gertrudes@email.com', name: 'Gertrudes', cpf: cpf, password: 'asdflakjsdbnçfqbwkejb')

      order = Order.new(cpf: CPF.generate, customer_name: 'Eustaquio', phone_number: '11933301090', email: 'açsldkfj')

      expect(order).not_to be_valid
    end

    it 'CPF deve ser válido' do 
      user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
      restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
      cpf = CPF.generate
      new_employee = NewEmployee.create!(restaurant: restaurant, cpf: cpf, email: 'gertrudes@email.com')
      employee = User.create!(email: 'gertrudes@email.com', name: 'Gertrudes', cpf: cpf, password: 'asdflakjsdbnçfqbwkejb')

      order = Order.new(cpf: 'alsdkfj', customer_name: 'Eustaquio', phone_number: '11933301090', email: 'eustaquio@email.com')

      expect(order).not_to be_valid
    end

    it 'Telefone deve ser alfanumérico' do 
      user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
      restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
      cpf = CPF.generate
      new_employee = NewEmployee.create!(restaurant: restaurant, cpf: cpf, email: 'gertrudes@email.com')
      employee = User.create!(email: 'gertrudes@email.com', name: 'Gertrudes', cpf: cpf, password: 'asdflakjsdbnçfqbwkejb')

      order = Order.new(restaurant: restaurant, cpf: CPF.generate, customer_name: 'Eustaquio', phone_number: 'laskdjfh', email: 'eustaquio@email.com')

      expect(order).not_to be_valid
    end

    it 'Pedido não pode ser finalizado se estiver vazio' do
      user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
      restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
      cpf = CPF.generate
      new_employee = NewEmployee.create!(restaurant: restaurant, cpf: cpf, email: 'gertrudes@email.com')
      employee = User.create!(email: 'gertrudes@email.com', name: 'Gertrudes', cpf: cpf, password: 'asdflakjsdbnçfqbwkejb')

      order = Order.create!(restaurant: restaurant, cpf: CPF.generate, customer_name: 'Eustaquio', phone_number: '11933301020', email: 'eustaquio@email.com')
      order.status = "pending_kitchen"

      expect(order).not_to be_valid
    end

    it 'Pedido não pode ser cancelado mais de uma vez' do 
      user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
      restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                      cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                      city: "Ferraz de Vasconcelos", state: "SP",
                                      zip_code: "11111-111", owner: user,
                                      district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
      menu = Menu.create!(restaurant: restaurant, name: 'Jantar')
      dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'pão, carne, queijo', calories: 1200)
      menu.offerable_menus << OfferableMenu.new(offerable: dish)
      offering = Offering.create!(offerable: dish, current_price: 40, description: 'extra-grande')
      order = Order.create!(customer_name: 'Derp', email: 'derp@email.com', restaurant: restaurant)
      order.order_offerings << OrderOffering.new(offering: offering, quantity: 2)
      order.update!(status: 'cancelled', cancellation_note: 'Acabou o hamburguer')
      order.update(status: 'cancelled', cancellation_note: 'Acabou o ketchup')

      expect(order).not_to be_valid
    end

    it 'Motivo de cancelamento não deve ser informado se o pedido não estiver sendo cancelado' do 
      user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
      restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                      cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                      city: "Ferraz de Vasconcelos", state: "SP",
                                      zip_code: "11111-111", owner: user,
                                      district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
      menu = Menu.create!(restaurant: restaurant, name: 'Jantar')
      dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'pão, carne, queijo', calories: 1200)
      menu.offerable_menus << OfferableMenu.new(offerable: dish)
      offering = Offering.create!(offerable: dish, current_price: 40, description: 'extra-grande')
      order = Order.create!(customer_name: 'Derp', email: 'derp@email.com', restaurant: restaurant)
      order.order_offerings << OrderOffering.new(offering: offering, quantity: 2)
      order.update(status: 'pending_kitchen', cancellation_note: 'Acabou o ketchup')

      expect(order).not_to be_valid
    end
  end
end
