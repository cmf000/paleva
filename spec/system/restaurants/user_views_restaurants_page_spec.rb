require 'rails_helper'

describe 'Usuário visita a página de restaurantes' do 
  it 'e existe outro restaurante cadastrado' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                city: "Ferraz de Vasconcelos", state: "SP",
                                zip_code: "11111-111", owner: user,
                                district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    other_user = User.create!(name: 'Zoroastro', email: 'zoroastro@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    other_restaurant = Restaurant.create!(registered_name: "Sabores do Brasil LTDA", trade_name: "Sabores do Brasil",
                                          cnpj: CNPJ.generate, street_address: "Rua das Palmeiras, 123", district: 'Santana',
                                          city: "São Paulo", state: "SP", zip_code: "01000-000", owner: other_user,
                                          email: 'saboresdobrasil@email.com', phone_number: '11933301020')

    login_as(user)
    visit root_path
    expect(current_path).to eq restaurants_path
    expect(page).to have_content restaurant.trade_name
    expect(page).to have_content other_restaurant.trade_name
    expect(page).to have_content 'Olá, Amarildo'

  end

  it 'e não existe outro restaurante cadastrado' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                city: "Ferraz de Vasconcelos", state: "SP",
                                zip_code: "11111-111", owner: user,
                                district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')

    login_as(user)
    visit root_path
    expect(page).to have_content restaurant.trade_name
    expect(page).to have_content 'Olá, Amarildo'
    expect(page).not_to have_content 'Veja o que os outros restaurantes estão fazendo:'

  end

  it 'e é um funcionário' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    cpf = CPF.generate
    new_employee = NewEmployee.create!(restaurant: restaurant, cpf: cpf, email: 'gertrudes@email.com')
    employee = User.create!(cpf: cpf, email: 'gertrudes@email.com', name: 'Gertrudes', password: 'asdfqwerasdf')
    login_as(employee)

    visit restaurants_path

    expect(current_path).to eq restaurant_path(employee.works_at_restaurant)
  end
end