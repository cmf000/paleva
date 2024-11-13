require 'rails_helper'

RSpec.describe OrderOffering, type: :model do
  describe "#valid?" do
    it "item de um pedido não pode ser inativo" do
      user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
      restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                        cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                        city: "Ferraz de Vasconcelos", state: "SP",
                                        zip_code: "11111-111", owner: user,
                                        district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
      dish = Dish.create!(name: 'Hamburguer', restaurant: restaurant, description: 'carne, mostarda, queijo', status: :inactive)
      offering = Offering.create!(offerable: dish, current_price: 15.00, effective_at: DateTime.now, description: 'Grande')
      menu = Menu.create!(name: 'Almoço', restaurant: restaurant)
      menu.dishes << dish
      order = Order.create!(restaurant: restaurant, customer_name: 'Amarildo', phone_number: '11933301090', email: 'amarildo@email.com', cpf: CPF.generate)
      order_offering = OrderOffering.new(order_id: order.id, offering_id: offering.id, comment: 'Sem cebola!!!', quantity: 1)

      expect(order_offering).not_to be_valid
    end
  end
end
