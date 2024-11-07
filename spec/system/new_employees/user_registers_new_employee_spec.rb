require 'rails_helper'

describe 'Usuário cadastra um novo funcionário' do 
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
    click_on 'Gestão de Funcionários'
    click_on 'Pré-cadastrar funcionário'
    
    expect(current_path).to eq new_restaurant_new_employee_path(restaurant.id)
    expect(page).to have_content 'CPF'
    expect(page).to have_content 'E-mail'
    expect(page).to have_button 'Criar Novo Funcionário'
  end

  it 'e volta à tela inicial' do
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
    click_on 'Pré-cadastrar funcionário'
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
    click_on 'Pré-cadastrar funcionário'
    click_on 'Quitutes Picantes'
    
    expect(current_path).to eq restaurant_path(restaurant.id)
  end

  it 'e volta à página de gestão de funcionários' do
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
    click_on 'Pré-cadastrar funcionário'
    click_on 'Gestão de funcionários'
    
    expect(current_path).to eq manage_employees_restaurant_path(restaurant.id)
  end

  it 'com sucesso' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    cpf = CPF.generate(strict: true)

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Gestão de Funcionários'
    click_on 'Pré-cadastrar funcionário'
    fill_in 'CPF', with: cpf
    fill_in 'E-mail', with: 'gertrude@email.com'
    click_on 'Criar Novo Funcionário' 
    
    expect(page).to have_content 'Pré-cadastro realizado com sucesso'
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
    click_on 'Gestão de Funcionários'
    click_on 'Pré-cadastrar funcionário'
    click_on 'Criar Novo Funcionário' 
    
    expect(page).to have_content 'Pré-cadastro não realizado'
    expect(page).to have_content 'CPF não pode ficar em branco'
    expect(page).to have_content 'E-mail não pode ficar em branco'
  end

  it 'com dados inválidos' do
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
    click_on 'Pré-cadastrar funcionário'
    fill_in 'E-mail', with: 'asdf'
    fill_in 'CPF', with: '1234'
    click_on 'Criar Novo Funcionário' 
    
    expect(page).to have_content 'Pré-cadastro não realizado'
    expect(page).to have_content 'CPF não é válido'
    expect(page).to have_content 'E-mail não é válido'
  end

  it 'e o cpf já está pré-cadastrado' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    cpf = CPF.generate
    employee = NewEmployee.create!(restaurant: restaurant, cpf: cpf, email: 'domestaquio@email.com')

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Gestão de Funcionários'
    click_on 'Pré-cadastrar funcionário'
    fill_in 'E-mail', with: 'gertrudes@email.com'
    fill_in 'CPF', with: cpf
    click_on 'Criar Novo Funcionário'

    expect(page).to have_content 'Pré-cadastro não realizado'
    expect(page).to have_content 'CPF já existe'
  end

  it 'e o e-mail já está pré-cadastrado' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    employee = NewEmployee.create!(restaurant: restaurant, cpf: CPF.generate, email: 'domestaquio@email.com')

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Gestão de Funcionários'
    click_on 'Pré-cadastrar funcionário'
    fill_in 'E-mail', with: 'domestaquio@email.com'
    fill_in 'CPF', with: CPF.generate
    click_on 'Criar Novo Funcionário'

    expect(page).to have_content 'Pré-cadastro não realizado'
    expect(page).to have_content 'E-mail já existe'
  end

  it 'e o cpf já está cadastrado' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    cpf = CPF.generate
    other_user = User.create!(name: 'Zoroastro', email: 'zoroastro@email.com', password: 'asdfn1234çlknv3', cpf: cpf)

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Gestão de Funcionários'
    click_on 'Pré-cadastrar funcionário'
    fill_in 'E-mail', with: 'zoroastro@email.com'
    fill_in 'CPF', with: cpf
    click_on 'Criar Novo Funcionário'

    expect(page).to have_content 'Pré-cadastro não realizado'
    expect(page).to have_content 'CPF já existe'
  end

  it 'e o e-mail já está cadastrado' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    other_user = User.create!(name: 'Zoroastro', email: 'zoroastro@email.com', password: 'asdfn1234çlknv3', cpf: CPF.generate)

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Gestão de Funcionários'
    click_on 'Pré-cadastrar funcionário'
    fill_in 'E-mail', with: 'zoroastro@email.com'
    fill_in 'CPF', with: CPF.generate
    click_on 'Criar Novo Funcionário'

    expect(page).to have_content 'Pré-cadastro não realizado'
    expect(page).to have_content 'E-mail já existe'
  end
end