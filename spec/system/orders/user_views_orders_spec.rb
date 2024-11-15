require 'rails_helper'

describe 'Usuário vê pedidos' do
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
    order_1 = Order.create!(restaurant: restaurant, customer_name: 'Derpina', email: 'derpina@email.com')
    order_1.offerings << offering
    order_1.pending_kitchen!

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Ver Pedidos'

    expect(page).to have_content 'Derp'
    expect(page).to have_content 'Aguardando finalização'
    expect(page).to have_content 'Derpina'
    expect(page).to have_content 'Aguardando confirmação da cozinha'
  end
end