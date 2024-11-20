require 'rails_helper'

describe 'Usuário cancela pedido' do 
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
    cpf = CPF.generate
    new_employee = NewEmployee.create!(restaurant: restaurant, cpf: cpf, email: 'gertrudes@email.com')
    employee = User.create!(cpf: cpf, name: 'Gertrudes', email: 'gertrudes@email.com', password: 'açsldkfçlaskndfçlaks')

    login_as(employee)
    visit root_path
    click_on 'Ver Pedidos'
    click_on "#{dom_id order}-link"
    click_on "Cancelar"

    expect(page).to have_content("Motivo")
    expect(page).to have_button("Cancelar")
  end

  it 'e volta à tela de detalhes do pedido' do 
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
    cpf = CPF.generate
    new_employee = NewEmployee.create!(restaurant: restaurant, cpf: cpf, email: 'gertrudes@email.com')
    employee = User.create!(cpf: cpf, name: 'Gertrudes', email: 'gertrudes@email.com', password: 'açsldkfçlaskndfçlaks')


    login_as(employee)
    visit root_path
    click_on 'Ver Pedidos'
    click_on "#{dom_id order}-link"
    click_on "Cancelar"
    click_on 'Voltar'

    expect(current_path).to eq restaurant_order_path(restaurant, order)
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
    order.pending_kitchen!
    cpf = CPF.generate
    new_employee = NewEmployee.create!(restaurant: restaurant, cpf: cpf, email: 'gertrudes@email.com')
    employee = User.create!(cpf: cpf, name: 'Gertrudes', email: 'gertrudes@email.com', password: 'açsldkfçlaskndfçlaks')


    login_as(employee)
    visit root_path
    click_on 'Ver Pedidos'
    click_on "#{dom_id order}-link"
    click_on "Cancelar"
    fill_in "Motivo", with: "Cliente esqueceu o cartão em casa"
    click_on "Cancelar"

    expect(page).to have_content 'Pedido cancelado com sucesso'
    expect(current_path).to eq restaurant_path(restaurant)
  end

  it 'e o motivo é obrigatório' do 
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
    order.pending_kitchen!
    cpf = CPF.generate
    new_employee = NewEmployee.create!(restaurant: restaurant, cpf: cpf, email: 'gertrudes@email.com')
    employee = User.create!(cpf: cpf, name: 'Gertrudes', email: 'gertrudes@email.com', password: 'açsldkfçlaskndfçlaks')


    login_as(employee)
    visit root_path
    click_on 'Ver Pedidos'
    click_on "#{dom_id order}-link"
    click_on "Cancelar"
    click_on "Cancelar"

    expect(page).to have_content 'Pedido não foi cancelado'
    expect(page).to have_content 'Motivo não pode ficar em branco'
  end

  it 'e não vê o botão de cancelar se o pedido já estiver cancelado' do
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
    order.pending_kitchen!
    order.update(status: 'cancelled', cancellation_note: 'Acabou o hamburguer')
    cpf = CPF.generate
    new_employee = NewEmployee.create!(restaurant: restaurant, cpf: cpf, email: 'gertrudes@email.com')
    employee = User.create!(cpf: cpf, name: 'Gertrudes', email: 'gertrudes@email.com', password: 'açsldkfçlaskndfçlaks')

    login_as(employee)
    visit root_path
    click_on 'Ver Pedidos'
    click_on "#{dom_id order}-link"

    expect(page).not_to have_content('Cancelar')
  end
end