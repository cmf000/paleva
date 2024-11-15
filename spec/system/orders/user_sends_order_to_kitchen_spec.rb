require 'rails_helper'

describe 'Usuário finaliza pedido' do
  it 'a partir da página inicial' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    menu = Menu.create!(restaurant: restaurant, name: 'Jantar')
    dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'pão, carne, queijo', calories: 1200)
    offering = Offering.create!(offerable: dish, description: 'médio', current_price: 8.00)
    menu.dishes << dish
    order = Order.create!(restaurant: restaurant, customer_name: 'Derp', email: 'derp@email.com')
    order.offerings << offering
    order_1 = Order.create!(restaurant: restaurant, customer_name: 'Derpina', email: 'derpina@email.com')
    order_1.offerings << offering
    order_1.pending_kitchen!

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Ver Pedidos'
    click_on "Aguardando finalização"
  end

  it 'com sucesso' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    menu = Menu.create!(restaurant: restaurant, name: 'Jantar')
    dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'pão, carne, queijo', calories: 1200)
    offering = Offering.create!(offerable: dish, description: 'médio', current_price: 8.00)
    menu.dishes << dish
    order = Order.create!(restaurant: restaurant, customer_name: 'Derp', email: 'derp@email.com')
    order.offerings << offering

    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABC12345')

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Ver Pedidos'
    click_on "Aguardando finalização"
    click_on "Enviar para Cozinha"

    expect(page).to have_content 'Pedido enviado à cozinha'
    expect(restaurant.orders.last.status).to eq "pending_kitchen"
    expect(restaurant.orders.last.code).to eq 'ABC12345'
  end
end