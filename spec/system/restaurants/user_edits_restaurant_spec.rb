require 'rails_helper'

describe "Usuário edita um restaurante" do
  it 'com sucesso' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                city: "Ferraz de Vasconcelos", state: "SP",
                                zip_code: "11111-111", owner: user,
                                district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    opening_time = Time.zone.local(1000, 1, 1, 17, 0, 0)
    Shift.create!(weekday: :sunday, restaurant: restaurant, opening_time: opening_time, closing_time: opening_time + 3.hours)

    login_as(user)
    visit root_path
    click_on('Quitutes Picantes')
    click_on("#{dom_id restaurant}-expand-icon")
    within("##{dom_id restaurant}-details") do
      click_on 'Editar'
    end
    fill_in 'Nome fantasia', with: 'Canapés Picantes'
    fill_in 'Email', with: 'canapespicantes@email.com'
    fill_in 'Linha de endereço', with: "Avenida dos Canapés, 789"
    fill_in 'Bairro', with: 'Pimentos'
    fill_in 'Cidade', with: 'Guarulhos'
    fill_in 'Estado', with: 'MG'
    fill_in 'Telefone', with: '11933301030'
    fill_in 'CEP', with: '33333-333'

    click_on 'Atualizar Restaurante'

    expect(current_path).to eq restaurant_path(restaurant.id)
    expect(page).to have_content('Restaurante editado com sucesso')
    expect(page).to have_content 'Avenida dos Canapés, 789'
    expect(page).to have_content 'Guarulhos - MG'
  end

  it 'com dados inválidos' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                  cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                  city: "Ferraz de Vasconcelos", state: "SP",
                                  zip_code: "11111-111", owner: user,
                                  district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    opening_time = Time.zone.local(1000, 1, 1, 17, 0, 0)
    Shift.create!(weekday: :sunday, restaurant: restaurant, opening_time: opening_time, closing_time: opening_time + 3.hours)
  
    login_as(user)
    visit root_path
    click_on('Quitutes Picantes')
    click_on("#{dom_id restaurant}-expand-icon")
    within("##{dom_id restaurant}-details") do
      click_on 'Editar'
    end
    fill_in 'Nome fantasia', with: ''
    fill_in 'Email', with: ''
    fill_in 'Linha de endereço', with: ""
    fill_in 'Bairro', with: ''
    fill_in 'Cidade', with: ''
    fill_in 'Estado', with: ''
    fill_in 'Telefone', with: ''
    fill_in 'CEP', with: ''
  
    click_on 'Atualizar Restaurante'

    expect(page).to have_content 'Restaurante não editado'
    expect(page).to have_content 'Nome fantasia não pode ficar em branco'
    expect(page).to have_content 'Linha de endereço não pode ficar em branco'
    expect(page).to have_content 'Bairro não pode ficar em branco'
    expect(page).to have_content 'Cidade não pode ficar em branco'
    expect(page).to have_content 'Estado não pode ficar em branco'
    expect(page).to have_content 'CEP não pode ficar em branco'
    expect(page).to have_content 'Email não pode ficar em branco'
    expect(page).to have_content 'Telefone é muito curto (mínimo: 10 caracteres)'
  end

  it 'e restorna à página de seu restaurante' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                city: "Ferraz de Vasconcelos", state: "SP",
                                zip_code: "11111-111", owner: user,
                                district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')

    login_as(user)
    visit root_path
    click_on('Quitutes Picantes')
    click_on("#{dom_id restaurant}-expand-icon")
    within("##{dom_id restaurant}-details") do
      click_on 'Editar'
    end
    click_on 'Quitutes Picantes'

    expect(current_path).to eq restaurant_path(restaurant.id)
    
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
    visit root_path

    expect(page).not_to have_content 'Editar'
  end
end