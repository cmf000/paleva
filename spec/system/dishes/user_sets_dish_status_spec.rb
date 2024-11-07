require 'rails_helper'

describe 'Usuário muda o status do prato' do
  it 'com sucesso' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                       cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                       city: "Ferraz de Vasconcelos", state: "SP",
                       zip_code: "11111-111", owner: user,
                       district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'pão, carne, mostarda', calories: 1200, status: :inactive)

    login_as(user)
    visit restaurant_path(restaurant.id)
    within("##{dom_id(dish)}") do
      click_on 'Hamburguer'
    end

    expect(page).to have_content "Hamburguer"
    expect(page).to have_content '1200 kcal'
    expect(page).to have_content 'Status: Inativo'
    expect(page).to have_button 'Ativar'
  end

  it 'e retorna à página de seu restaurante' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                       cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                       city: "Ferraz de Vasconcelos", state: "SP",
                       zip_code: "11111-111", owner: user,
                       district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'pão, carne, mostarda', calories: 1200, status: :inactive)

    login_as(user)
    visit restaurant_path(restaurant.id)
    within("##{dom_id(dish)}") do
      click_on 'Hamburguer'
    end
    click_on 'Quitutes Picantes'

    expect(current_path).to eq restaurant_path(restaurant.id)
  end

  it 'e retorna à página inicial' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                       cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                       city: "Ferraz de Vasconcelos", state: "SP",
                       zip_code: "11111-111", owner: user,
                       district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'pão, carne, mostarda', calories: 1200, status: :inactive)

    login_as(user)
    visit restaurant_path(restaurant.id)
    within("##{dom_id(dish)}") do
      click_on 'Hamburguer'
    end
    click_on 'Quitutes Picantes'

    expect(current_path).to eq restaurant_path(restaurant.id)
  end

  it 'e encontra o botão para ativar um prato inativo' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                       cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                       city: "Ferraz de Vasconcelos", state: "SP",
                       zip_code: "11111-111", owner: user,
                       district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'pão, carne, mostarda', calories: 1200, status: :inactive)

    login_as(user)
    visit restaurant_path(restaurant.id)
    within("##{dom_id(dish)}") do
      click_on 'Hamburguer'
    end

    expect(page).to have_button 'Ativar'
  end

  it 'e não encontra o botão de desativar um prato inativo' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                       cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                       city: "Ferraz de Vasconcelos", state: "SP",
                       zip_code: "11111-111", owner: user,
                       district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'pão, carne, mostarda', calories: 1200, status: :inactive)

    login_as(user)
    visit restaurant_path(restaurant.id)
    within("##{dom_id(dish)}") do
      click_on 'Hamburguer'
    end

    expect(page).not_to have_button 'Desativar'
  end

  it 'e encontra o botão para desativar um prato ativo' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                       cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                       city: "Ferraz de Vasconcelos", state: "SP",
                       zip_code: "11111-111", owner: user,
                       district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'pão, carne, queijo', calories: 1200, status: :active)

    login_as(user)
    visit restaurant_path(restaurant.id)
    within("##{dom_id(dish)}") do
      click_on 'Hamburguer'
    end

    expect(page).to have_button 'Desativar'
  end

  it 'e não encontra o botão de ativar um prato ativo' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                       cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                       city: "Ferraz de Vasconcelos", state: "SP",
                       zip_code: "11111-111", owner: user,
                       district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'pão, carne, mostarda', calories: 1200, status: :active)

    login_as(user)
    visit restaurant_path(restaurant.id)
    within("##{dom_id(dish)}") do
      click_on 'Hamburguer'
    end

    expect(page).not_to have_button 'Ativar'
  end

  it 'e ativa um prato inativo com sucesso' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                       cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                       city: "Ferraz de Vasconcelos", state: "SP",
                       zip_code: "11111-111", owner: user,
                       district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'pão carne queijo', status: :inactive)

    login_as(user)
    visit restaurant_path(restaurant.id)
    within("##{dom_id(dish)}") do
      click_on 'Hamburguer'
    end
    click_on 'Ativar'
    dish.reload

    expect(dish).to be_active
  end

  it 'e desativa um prato inativo com sucesso' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                       cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                       city: "Ferraz de Vasconcelos", state: "SP",
                       zip_code: "11111-111", owner: user,
                       district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'pão carne queijo', status: :active)

    login_as(user)
    visit restaurant_path(restaurant.id)
    within("##{dom_id(dish)}") do
      click_on 'Hamburguer'
    end
    click_on 'Desativar'
    dish.reload

    expect(dish).to be_inactive
  end
end