require 'rails_helper'

describe 'Usuário dono vê detalhes de um pedido' do 
  it 'a partir da página inicial' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    menu = Menu.create!(restaurant: restaurant, name: 'Jantar')
    dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'pão, carne, queijo', calories: 1200)
    beverage = Beverage.create!(restaurant: restaurant, name: 'Coca-cola', description: 'Refrigerante', calories: 1200, alcoholic: :no)
    dish_offering = Offering.create!(offerable: dish, description: 'médio', current_price: 19.00)
    beverage_offering = Offering.create!(offerable: beverage, description: '350ml', current_price: 10.00)
    menu.dishes << dish
    menu.beverages << beverage
    allow(SecureRandom).to receive(:alphanumeric).and_return("ABC123")
    order = Order.create!(restaurant: restaurant, customer_name: 'Derp', email: 'derp@email.com')
    order_offering = order.order_offerings.build(offering: dish_offering, comment: 'Sem cebola!', quantity: 2)
    order_offering.save
    order.order_offerings << OrderOffering.new(offering: beverage_offering)

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Ver Pedidos'
    click_on 'Derp'

    expect(page).to have_content 'Pedido'
    expect(page).to have_content 'Nome do cliente: Derp'
    expect(page).to have_content 'Status: Aguardando finalização'
    expect(page).to have_content 'Coca-cola'
    expect(page).to have_content 'R$ 10,00'
    expect(page).to have_content 'Hamburguer'
    expect(page).to have_content 'R$ 38,00'
    expect(page).to have_content 'Sem cebola!'
  end

  it 'e volta à página de listagem de pedidos' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    menu = Menu.create!(restaurant: restaurant, name: 'Jantar')
    dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'pão, carne, queijo', calories: 1200)
    beverage = Beverage.create!(restaurant: restaurant, name: 'Coca-cola', description: 'Refrigerante', calories: 1200, alcoholic: :no)
    dish_offering = Offering.create!(offerable: dish, description: 'médio', current_price: 19.00)
    beverage_offering = Offering.create!(offerable: beverage, description: '350ml', current_price: 10.00)
    menu.dishes << dish
    menu.beverages << beverage
    allow(SecureRandom).to receive(:alphanumeric).and_return("ABC123")
    order = Order.create!(restaurant: restaurant, customer_name: 'Derp', email: 'derp@email.com')

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Ver Pedidos'
    click_on 'Derp'
    click_on 'Pedidos'

    expect(current_path).to eq restaurant_orders_path(restaurant)
  end

  it 'e volta à página do restaurante' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    menu = Menu.create!(restaurant: restaurant, name: 'Jantar')
    dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'pão, carne, queijo', calories: 1200)
    beverage = Beverage.create!(restaurant: restaurant, name: 'Coca-cola', description: 'Refrigerante', calories: 1200, alcoholic: :no)
    dish_offering = Offering.create!(offerable: dish, description: 'médio', current_price: 19.00)
    beverage_offering = Offering.create!(offerable: beverage, description: '350ml', current_price: 10.00)
    menu.dishes << dish
    menu.beverages << beverage
    allow(SecureRandom).to receive(:alphanumeric).and_return("ABC123")
    order = Order.create!(restaurant: restaurant, customer_name: 'Derp', email: 'derp@email.com')

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Ver Pedidos'
    click_on 'Derp'
    click_on 'Quitutes Picantes'

    expect(current_path).to eq restaurant_path(restaurant)
  end
end