require 'rails_helper'

describe 'Usuário adiciona porção a um pedido' do
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
      
    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on "#{dom_id(menu)}-details"
    click_on "R$ 8,00"

    expect(page).to have_content "Selecione o Pedido"
    expect(page).to have_content "Quantidade"
    expect(page).to have_content "Observação"
    expect(page).to have_button "Adicionar ao Pedido"
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
      
    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on "#{dom_id(menu)}-details"
    click_on "R$ 8,00"
    select 'Derp', from: "Selecione o Pedido"
    click_on 'Adicionar ao Pedido'

    expect(page).to have_content 'Adicionado ao pedido com sucesso'
    expect(order.order_offerings.last.offering.offerable).to eq dish
  end
end