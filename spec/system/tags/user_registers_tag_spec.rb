require 'rails_helper'

describe 'Usuário cria uma nova tag' do 
  it 'a partir da tela de cadastro de uma bebida' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    Tag.create!(restaurant: restaurant, name: :vegan)
                                  
    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Cadastrar nova bebida'
    click_on 'Nova Marcação'
    fill_in 'Nome', with: 'Vegetariano'
    click_on 'Criar Marcação'

    expect(current_path).to eq new_restaurant_beverage_path(restaurant)
    expect(page).to have_content 'Vegano'
    expect(page).to have_content 'Vegetariano'
  end

  it 'a partir da tela de edição de uma bebida' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    beverage = Beverage.create!(restaurant: restaurant, name: 'Coca-cola', description: 'Delicioso tônico', alcoholic: :no)
    Tag.create!(restaurant: restaurant, name: :vegan)
                                  
    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    within("##{dom_id(beverage)}") do
      click_on 'Editar'
    end
    click_on 'Nova Marcação'
    fill_in 'Nome', with: 'Vegetariano'
    click_on 'Criar Marcação'

    expect(current_path).to eq edit_restaurant_beverage_path(restaurant.id, beverage.id)
    expect(page).to have_content 'Vegano'
    expect(page).to have_content 'Vegetariano'
  end

  it 'a partir da tela de cadastro de um prato' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    Tag.create!(restaurant: restaurant, name: :vegan)
                                  
    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Cadastrar novo prato'
    click_on 'Nova Marcação'
    fill_in 'Nome', with: 'Vegetariano'
    click_on 'Criar Marcação'

    expect(current_path).to eq new_restaurant_dish_path(restaurant)
    expect(page).to have_content 'Vegano'
    expect(page).to have_content 'Vegetariano'
  end

  it 'a partir da tela de edição de um prato' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'pão, carne, queijo')
    Tag.create!(restaurant: restaurant, name: :vegan)
                                  
    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    within("##{dom_id(dish)}") do
      click_on 'Editar'
    end
    click_on 'Nova Marcação'
    fill_in 'Nome', with: 'Vegetariano'
    click_on 'Criar Marcação'

    expect(current_path).to eq edit_restaurant_dish_path(restaurant, dish)
    expect(page).to have_content 'Vegano'
    expect(page).to have_content 'Vegetariano'
  end

  it 'e retorna à página do restaurante' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'pão, carne, queijo')
    Tag.create!(restaurant: restaurant, name: :vegan)
                                  
    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    within("##{dom_id(dish)}") do
      click_on 'Editar'
    end
    click_on 'Nova Marcação'
    click_on 'Quitutes Picantes'

    expect(current_path).to eq restaurant_path(restaurant.id)
  end

  it 'e retorna ao menu anterior' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'pão, carne, queijo')
    Tag.create!(restaurant: restaurant, name: :vegan)
                                  
    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    within("##{dom_id(dish)}") do
      click_on 'Editar'
    end
    click_on 'Nova Marcação'
    click_on 'Voltar'

    expect(current_path).to eq edit_restaurant_dish_path(restaurant.id, dish.id)
  end
end