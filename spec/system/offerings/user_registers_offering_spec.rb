require 'rails_helper'

describe 'Usuário cadastra uma nova porção' do
  it 'a partir da página inicial' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    beverage = Beverage.create!(restaurant: restaurant, name: 'Coca-cola', description: 'Delicioso tônico', calories: 1200, alcoholic: :no)
    offering = Offering.create!(offerable: beverage, description: '350 ml', current_price: 8.00)

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Coca-cola'
    click_on 'Nova Porção'

    expect(page).to have_field 'Descrição'
    expect(page).to have_field 'Preço'
    expect(page).to have_button 'Criar Porção'
  end

  it 'e volta à página inicial' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'pão, carne, queijo', calories: 1200)
    offering = Offering.create!(offerable: dish, description: '350 ml', current_price: 8.00)

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Hamburguer'
    click_on 'Nova Porção'
    click_on 'Paleva'

    expect(current_path).to eq restaurants_path
    
  end

  it 'e volta à página do restaurante' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    beverage = Beverage.create!(restaurant: restaurant, name: 'Coca-cola', description: 'Delicioso tônico', calories: 1200, alcoholic: :no)

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Coca-cola'
    click_on 'Nova Porção'
    click_on 'Quitutes Picantes'

    expect(current_path).to eq restaurant_path(restaurant.id)
    
  end

  it 'de uma bebida com sucesso' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    beverage = Beverage.create!(restaurant: restaurant, name: 'Coca-cola', description: 'Delicioso tônico', calories: 1200, alcoholic: :no)

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Coca-cola'
    click_on 'Nova Porção'
    fill_in 'Descrição', with: '500 ml'
    fill_in 'Preço', with: 8.50
    click_on 'Criar Porção'

    expect(page).to have_content 'Porção cadastrada com sucesso'
    expect(page).to have_content '500 ml'
    expect(page).to have_content 'R$ 8,50'
  end

  it 'de um prato com sucesso' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'pão, carne, queijo', calories: 1200)

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Hamburguer'
    click_on 'Nova Porção'
    fill_in 'Descrição', with: 'Médio'
    fill_in 'Preço', with: 20
    click_on 'Criar Porção'

    expect(page).to have_content 'Porção cadastrada com sucesso'
    expect(page).to have_content 'Médio'
    expect(page).to have_content 'R$ 20,00'
  end

  it 'de uma bebida com dados incompletos' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    beverage = Beverage.create!(restaurant: restaurant, name: 'Coca-cola', description: 'Delicioso tônico', calories: 1200, alcoholic: :no)

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Coca-cola'
    click_on 'Nova Porção'
    click_on 'Criar Porção'

    expect(page).to have_content 'Porção não cadastrada'
    expect(page).to have_content 'Descrição não pode ficar em branco'
    expect(page).to have_content 'Preço não pode ficar em branco'
    expect(page).to have_content 'Preço não é um número'
  end

  it 'de um prato com dados incompletos' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'pão, carne, queijo', calories: 1200)

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Hamburguer'
    click_on 'Nova Porção'
    click_on 'Criar Porção'

    expect(page).to have_content 'Porção não cadastrada'
    expect(page).to have_content 'Descrição não pode ficar em branco'
    expect(page).to have_content 'Preço não pode ficar em branco'
    expect(page).to have_content 'Preço não é um número'
  end
end