require 'rails_helper'

describe 'Usuário cancela pedido' do
  it 'e não é o dono ou funcionário do restaurante' do
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
    other_user = User.create!(name: 'Zoroastro', email: 'zoroastro@email.com', password: 'alsdkjfaksdlkkjhased', cpf: CPF.generate)

    login_as(other_user)

    patch(update_status_to_cancelled_restaurant_order_path(restaurant, order), params: {order: { cancellation_note: 'Acabou o hamburguer'}})

    expect(response).to redirect_to root_path
    
  end
end