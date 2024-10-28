require 'rails_helper'

describe 'Usuário busca pratos e bebidas' do
  it 'a partir do menu' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                       cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                       city: "Ferraz de Vasconcelos", state: "SP",
                       zip_code: "11111-111", user: user,
                       district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'carne, queijo, mostarda', calories: 1200)
    beverage = Beverage.create!(restaurant: restaurant, name: 'Coca-cola', description: '2L', calories: 1200, alcoholic: :no)

    login_as(user)
    visit root_path

    within('header nav') do
      expect(page).to have_button('Buscar')
      expect(find('#query')[:placeholder]).to eq 'buscar em Quitutes Picantes'
    end
  end

  it 'e deve estar autenticado' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                       cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                       city: "Ferraz de Vasconcelos", state: "SP",
                       zip_code: "11111-111", user: user,
                       district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    visit root_path

    within('header nav') do
      expect(page).not_to have_button('Buscar')
    end
  end

  it 'e encontra um prato' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                       cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                       city: "Ferraz de Vasconcelos", state: "SP",
                       zip_code: "11111-111", user: user,
                       district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    Beverage.create!(restaurant: restaurant, name: 'Coca-cola', description: '2L', calories: 1200, alcoholic: :no)
    Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'carne, queijo, mostarda', calories: 1200)
    Beverage.create!(restaurant: restaurant, name: 'Cerveja', description: '350ml', calories: 500, alcoholic: :no)
    Dish.create!(restaurant: restaurant, name: 'Cachorro Quente', description: 'pao, salsicha, molhos', calories: 1200)


    login_as(user)
    visit root_path
    fill_in 'Buscar itens', with: 'Hamburguer'
    click_on "Buscar"

    expect(page).to have_content 'Resultados da busca por: Hamburguer'
    expect(page).to have_content '1 iten(s) encontrado(s)'
  end
end