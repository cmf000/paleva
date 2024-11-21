require 'rails_helper'

describe 'Usuário cadastra um novo cardápio' do 
  it 'a partir da página inicial' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                  cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                  city: "Ferraz de Vasconcelos", state: "SP",
                                  zip_code: "11111-111", owner: user,
                                  district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Cadastrar novo cardápio'

    expect(page).to have_content 'Nome'
    expect(page).to have_content 'Novo cardápio'
  end

  it 'e volta à página do restaurante' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                  cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                  city: "Ferraz de Vasconcelos", state: "SP",
                                  zip_code: "11111-111", owner: user,
                                  district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Cadastrar novo cardápio'
    click_on 'Quitutes Picantes'

    expect(current_path).to eq restaurant_path(restaurant)
  end

  it 'com sucesso' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                  cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                  city: "Ferraz de Vasconcelos", state: "SP",
                                  zip_code: "11111-111", owner: user,
                                  district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Cadastrar novo cardápio'
    fill_in 'Nome', with: 'Jantar'
    click_on 'Criar cardápio'

    expect(page).to have_content 'Cardápio criado com sucesso'
    expect(current_path).to eq restaurant_menu_path(restaurant, Menu.last)
  end

  it 'com dados incompletos' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                  cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                  city: "Ferraz de Vasconcelos", state: "SP",
                                  zip_code: "11111-111", owner: user,
                                  district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Cadastrar novo cardápio'
    click_on 'Criar cardápio'

    expect(page).to have_content 'Cardápio não foi criado'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(current_path).to eq restaurant_menus_path(restaurant, Menu.last)
  end

  it 'com nome repetido' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                  cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                  city: "Ferraz de Vasconcelos", state: "SP",
                                  zip_code: "11111-111", owner: user,
                                  district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    menu = Menu.create!(restaurant: restaurant, name: 'Jantar')

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Cadastrar novo cardápio'
    fill_in 'Nome', with: 'Jantar'
    click_on 'Criar cardápio'

    expect(page).to have_content 'Cardápio não foi criado'
    expect(page).to have_content 'Nome já existe'
  end

  it 'e não é o dono do restaurante' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                  cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                  city: "Ferraz de Vasconcelos", state: "SP",
                                  zip_code: "11111-111", owner: user,
                                  district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    cpf = CPF.generate
    new_employee = NewEmployee.create!(restaurant: restaurant, cpf: cpf, email: 'gertrudes@email.com')
    employee = User.create!(name: 'Gertrudes', cpf: cpf, email: 'gertrudes@email.com', password: 'asdfasdfasdfasdfçlk')

    login_as(employee)
    visit root_path

    expect(page).not_to have_content 'Cadastrar novo cardápio'
  end
end