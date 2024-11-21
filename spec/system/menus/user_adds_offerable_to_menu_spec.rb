require 'rails_helper'

describe 'Usuário adiciona itens ao cardápio' do 
  it 'a partir da tela inicial' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                  cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                  city: "Ferraz de Vasconcelos", state: "SP",
                                  zip_code: "11111-111", owner: user,
                                  district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    menu = Menu.create!(restaurant: restaurant, name: 'Jantar')
    dish_1 = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'pão, carne, queijo', calories: 1200)
    dish_2 = Dish.create!(restaurant: restaurant, name: 'pão de queijo', description: 'quitute de polvilho com queijo', calories: 1200)
    dish_3 = Dish.create!(restaurant: restaurant, name: 'misto quente', description: 'pão, presunto, queijo', calories: 1200)
    beverage_1 = Beverage.create!(restaurant: restaurant, name: 'Coca-cola', description: 'Delicioso tônico', calories: 1200, alcoholic: :no)

    
    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on "#{dom_id(menu)}-details"
    click_on "Adicionar Item"

    expect(page).to have_content 'Hamburguer'
    expect(page).to have_content "pão de queijo"
    expect(page).to have_content 'misto quente'
    expect(page).to have_content 'Coca-cola'
  end

  it 'com sucesso' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                  cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                  city: "Ferraz de Vasconcelos", state: "SP",
                                  zip_code: "11111-111", owner: user,
                                  district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    beverage_1 = Beverage.create!(restaurant: restaurant, name: 'Coca-cola', description: 'Delicioso tônico', calories: 1200, alcoholic: :no)
    menu = Menu.create!(restaurant: restaurant, name: 'Café da Manhã')

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on "#{dom_id(menu)}-details"
    click_on 'Adicionar Item'
    click_on 'Adicionar ao Menu'

    save_page
    expect(page).to have_content 'Item adicionado com sucesso'
  end

  it 'e não vê itens que já estão no menu' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                  cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                  city: "Ferraz de Vasconcelos", state: "SP",
                                  zip_code: "11111-111", owner: user,
                                  district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    dish_1 = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'pão, carne, queijo', calories: 1200)
    dish_2 = Dish.create!(restaurant: restaurant, name: 'pão de queijo', description: 'quitute de polvilho com queijo', calories: 1200)
    dish_3 = Dish.create!(restaurant: restaurant, name: 'misto quente', description: 'pão, presunto, queijo', calories: 1200)
    beverage_1 = Beverage.create!(restaurant: restaurant, name: 'Coca-cola', description: 'Delicioso tônico', calories: 1200, alcoholic: :no)
    menu = Menu.create!(restaurant: restaurant, name: 'Café da Manhã')
    menu.dishes << dish_3

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on "#{dom_id(menu)}-details"
    click_on 'Adicionar Item'

    expect(page).to have_content 'Hamburguer'
    expect(page).to have_content 'pão de queijo'
    expect(page).to have_content 'Coca-cola'
    expect(page).not_to have_content 'misto quente'
  end

  it 'e não é o dono' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                  cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                  city: "Ferraz de Vasconcelos", state: "SP",
                                  zip_code: "11111-111", owner: user,
                                  district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    menu = Menu.create!(restaurant: restaurant, name: 'Café da Manhã')
    cpf = CPF.generate
    new_employee = NewEmployee.create!(restaurant: restaurant, cpf: cpf, email: 'gertrudes@email.com')
    employee = User.create!(name: 'Gertrudes', cpf: cpf, email: 'gertrudes@email.com', password: 'asdfalsdknfçaklsdnf')

    login_as(employee)
    visit root_path
    click_on "#{dom_id(menu)}-details"

    expect(page).not_to have_link 'Adicionar Item'
  end

  it 'e volta à página do menu' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                  cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                  city: "Ferraz de Vasconcelos", state: "SP",
                                  zip_code: "11111-111", owner: user,
                                  district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    dish_1 = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'pão, carne, queijo', calories: 1200)
    dish_2 = Dish.create!(restaurant: restaurant, name: 'pão de queijo', description: 'quitute de polvilho com queijo', calories: 1200)
    dish_3 = Dish.create!(restaurant: restaurant, name: 'misto quente', description: 'pão, presunto, queijo', calories: 1200)
    beverage_1 = Beverage.create!(restaurant: restaurant, name: 'Coca-cola', description: 'Delicioso tônico', calories: 1200, alcoholic: :no)
    menu = Menu.create!(restaurant: restaurant, name: 'Café da Manhã')

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on "#{dom_id(menu)}-details"
    click_on 'Adicionar Item'
    click_on 'Café da Manhã'

    expect(current_path).to eq restaurant_menu_path(restaurant, menu)
  end

  it 'e volta à página do restaurante' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                  cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                  city: "Ferraz de Vasconcelos", state: "SP",
                                  zip_code: "11111-111", owner: user,
                                  district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    menu = Menu.create!(restaurant: restaurant, name: 'Café da Manhã')

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on "#{dom_id(menu)}-details"
    click_on 'Adicionar Item'
    click_on 'Quitutes Picantes'

    expect(current_path).to eq restaurant_path(restaurant)
  end

  it 'e volta à página do menu' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                  cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                  city: "Ferraz de Vasconcelos", state: "SP",
                                  zip_code: "11111-111", owner: user,
                                  district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    menu = Menu.create!(restaurant: restaurant, name: 'Café da Manhã')

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on "#{dom_id(menu)}-details"
    click_on 'Adicionar Item'
    click_on 'Café da Manhã'

    expect(current_path).to eq restaurant_menu_path(restaurant, menu)
  end
end