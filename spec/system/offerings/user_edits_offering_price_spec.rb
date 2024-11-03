require 'rails_helper'

describe 'Usuário edita o preço de uma porção' do
  it 'a partir da tela inicial' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", user: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    beverage = Beverage.create!(restaurant: restaurant, name: 'Coca-cola', description: 'Delicioso tônico', calories: 1200, alcoholic: :no)
    offering = Offering.create!(offerable: beverage, description: '350 ml', current_price: 8.00)

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Coca-cola'
    click_on '350 ml'
    click_on 'Alterar Preço'

    expect(page).to have_content('Preço')
  end

  it 'e volta à tela inicial' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", user: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    beverage = Beverage.create!(restaurant: restaurant, name: 'Coca-cola', description: 'Delicioso tônico', calories: 1200, alcoholic: :no)
    offering = Offering.create!(offerable: beverage, description: '350 ml', current_price: 8.00)

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Coca-cola'
    click_on '350 ml'
    click_on 'Alterar Preço'
    click_on 'Paleva'

    expect(current_path).to eq restaurants_path
  end

  it 'e volta à tela da bebida' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", user: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    beverage = Beverage.create!(restaurant: restaurant, name: 'Coca-cola', description: 'Delicioso tônico', calories: 1200, alcoholic: :no)
    offering = Offering.create!(offerable: beverage, description: '350 ml', current_price: 8.00)

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Coca-cola'
    click_on '350 ml'
    click_on 'Alterar Preço'
    click_on 'Coca-cola'

    expect(current_path).to eq restaurant_beverage_path(restaurant.id, beverage.id)
  end

  it 'de uma bebida com sucesso' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", user: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    beverage = Beverage.create!(restaurant: restaurant, name: 'Coca-cola', description: 'Delicioso tônico', calories: 1200, alcoholic: :no)
    offering = Offering.create!(offerable: beverage, description: '350 ml', current_price: 8.00)

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Coca-cola'
    click_on '350 ml'
    click_on 'Alterar Preço'
    fill_in 'Preço', with: 50
    click_on 'Alterar Preço'

    expect(current_path).to eq restaurant_beverage_path(restaurant.id, beverage.id)
    expect(page).to have_content 'R$ 50,00'
  end

  it 'de uma bebida e não especifica um novo preço' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", user: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    beverage = Beverage.create!(restaurant: restaurant, name: 'Coca-cola', description: 'Delicioso tônico', calories: 1200, alcoholic: :no)
    offering = Offering.create!(offerable: beverage, description: '350 ml', current_price: 8.00)

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Coca-cola'
    click_on '350 ml'
    click_on 'Alterar Preço'
    fill_in 'Preço', with: ""
    click_on 'Alterar Preço'

    expect(page).to have_content 'Preço não foi alterado'
    expect(page).to have_content 'Preço não pode ficar em branco'
    expect(page).to have_content 'Preço não é um número'
  end

  it 'de uma bebida com preço negativo' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", user: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    beverage = Beverage.create!(restaurant: restaurant, name: 'Coca-cola', description: 'Delicioso tônico', calories: 1200, alcoholic: :no)
    offering = Offering.create!(offerable: beverage, description: '350 ml', current_price: 8.00)

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Coca-cola'
    click_on '350 ml'
    click_on 'Alterar Preço'
    fill_in 'Preço', with: -10
    click_on 'Alterar Preço'

    expect(page).to have_content 'Preço não foi alterado'
    expect(page).to have_content 'Preço deve ser maior que 0'
  end

  it 'e volta à tela do prato' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", user: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'pão, carne, queijo', calories: 1200)
    offering = Offering.create!(offerable: dish, description: 'médio', current_price: 8.00)

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Hamburguer'
    click_on 'médio'
    click_on 'Alterar Preço'
    click_on 'Hamburguer'

    expect(current_path).to eq restaurant_dish_path(restaurant.id, dish.id)
  end

  it 'de um prato com sucesso' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", user: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'pão, carne, queijo', calories: 1200)
    offering = Offering.create!(offerable: dish, description: 'médio', current_price: 8.00)

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Hamburguer'
    click_on 'médio'
    click_on 'Alterar Preço'
    fill_in 'Preço', with: 50
    click_on 'Alterar Preço'

    expect(current_path).to eq restaurant_dish_path(restaurant.id, dish.id)
    expect(page).to have_content 'R$ 50,00'
  end

  it 'de um prato e não especifica um novo preço' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", user: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'pão, carne, queijo', calories: 1200)
    offering = Offering.create!(offerable: dish, description: 'médio', current_price: 8.00)

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Hamburguer'
    click_on 'médio'
    click_on 'Alterar Preço'
    fill_in 'Preço', with: ""
    click_on 'Alterar Preço'

    expect(page).to have_content 'Preço não foi alterado'
    expect(page).to have_content 'Preço não pode ficar em branco'
    expect(page).to have_content 'Preço não é um número'
  end

  it 'de um prato com preço negativo' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", user: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'pão, carne, queijo', calories: 1200)
    offering = Offering.create!(offerable: dish, description: 'médio', current_price: 8.00)

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Hamburguer'
    click_on 'médio'
    click_on 'Alterar Preço'
    fill_in 'Preço', with: -10
    click_on 'Alterar Preço'

    expect(page).to have_content 'Preço não foi alterado'
    expect(page).to have_content 'Preço deve ser maior que 0'
  end
end