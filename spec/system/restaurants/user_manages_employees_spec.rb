require 'rails_helper'

describe 'Usuário genrencia os funcionários do restaurante' do 
  it 'a partir da página inicial' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    new_employee = NewEmployee.create(restaurant: restaurant, email: 'gertrudes@email.com', cpf: CPF.generate)
  
    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Gestão de Funcionários'
  end

  it 'e volta à tela inicial' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    new_employee = NewEmployee.create(restaurant: restaurant, email: 'gertrudes@email.com', cpf: CPF.generate)
    
    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Gestão de Funcionários'
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
    
    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Gestão de Funcionários'
    click_on 'Quitutes Picantes'

    expect(current_path).to eq restaurant_path(restaurant)
  end

  it 'e vê funcionários pendentes e ativos' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    cpf1 = CPF.generate
    cpf2 = CPF.generate
    new_employee_1 = NewEmployee.create!(restaurant: restaurant, email: 'gertrudes@email.com', cpf: cpf1)
    new_employee_2 = NewEmployee.create!(restaurant: restaurant, email: 'domestaquio@email.com', cpf: cpf2)
    new_employee_3 = NewEmployee.create!(restaurant: restaurant, email: 'matilda@email.com', cpf: CPF.generate)
    new_employee_4 = NewEmployee.create!(restaurant: restaurant, email: 'ronilson@email.com', cpf: CPF.generate)
    employee_1 = User.create!(email: "gertrudes@email.com", cpf: cpf1, name: 'Gertrudes', password: 'asdfalskdjfhalkdjf')
    employee_2 = User.create!(email: "domestaquio@email.com", cpf: cpf2, name: "Domestaquio", password: 'asdfalskdjfhalkdjf')

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Gestão de Funcionários'
    
    within("##{dom_id(new_employee_3)}") do
      expect(page).to have_content "matilda@email.com"
      expect(page).to have_content CPF.new(new_employee_3.cpf).formatted
    end

    within("##{dom_id(new_employee_4)}") do
      expect(page).to have_content "ronilson@email.com"
      expect(page).to have_content CPF.new(new_employee_4.cpf).formatted
    end

    within("##{dom_id(employee_1)}") do
      expect(page).to have_content "gertrudes@email.com"
      expect(page).to have_content CPF.new(employee_1.cpf).formatted
    end

    within("##{dom_id(employee_2)}") do
      expect(page).to have_content "domestaquio@email.com"
      expect(page).to have_content CPF.new(employee_2.cpf).formatted
    end
  end

  it 'e não há funcionários pendentes ou ativos' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    cpf1 = CPF.generate
    cpf2 = CPF.generate

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Gestão de Funcionários'
    
    expect(page).to have_content 'Nenhum funcionário pré-cadastrado'
    expect(page).to have_content 'Nenhum funcionário cadastrado'
  end
end