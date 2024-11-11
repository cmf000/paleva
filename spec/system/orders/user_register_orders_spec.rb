require 'rails_helper'

describe 'Usuário cadastra novo pedido' do
  it 'a partir da página inicial' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    cpf = CPF.generate
    new_employee = NewEmployee.create!(restaurant: restaurant, cpf: cpf, email: 'gertrudes@email.com')
    employee = User.create!(email: 'gertrudes@email.com', name: 'Gertrudes', cpf: cpf, password: 'asdflakjsdbnçfqbwkejb')

    login_as(employee)
    visit root_path
    click_on 'Novo pedido'

    expect(page).to have_content 'Nome'
    expect(page).to have_content 'E-mail'
    expect(page).to have_content 'CPF'
    expect(page).to have_content 'Telefone'
  end

  it 'com sucesso' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    cpf = CPF.generate
    new_employee = NewEmployee.create!(restaurant: restaurant, cpf: cpf, email: 'gertrudes@email.com')
    employee = User.create!(email: 'gertrudes@email.com', name: 'Gertrudes', cpf: cpf, password: 'asdflakjsdbnçfqbwkejb')

    login_as(employee)
    visit root_path
    click_on 'Novo pedido'
    fill_in 'Nome', with: 'Eustáquio'
    cpf = CPF.generate
    fill_in 'CPF', with: cpf
    fill_in 'Telefone', with: '11933301090'
    fill_in 'E-mail', with: 'eustaquio@email.com'
    click_on 'Criar Pedido'

    expect(page).to have_content 'Pedido criado com sucesso'
    expect(restaurant.orders.last.status).to eq "draft"
  end

  it 'com dados incompletos' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    cpf = CPF.generate
    new_employee = NewEmployee.create!(restaurant: restaurant, cpf: cpf, email: 'gertrudes@email.com')
    employee = User.create!(email: 'gertrudes@email.com', name: 'Gertrudes', cpf: cpf, password: 'asdflakjsdbnçfqbwkejb')

    login_as(employee)
    visit root_path
    click_on 'Novo pedido'
    click_on 'Criar Pedido'

    expect(page).to have_content 'Pedido não criado'
    expect(page).to have_content 'Nome do cliente não pode ficar em branco'
    expect(page).to have_content 'É obrigatório informar Telefone ou E-mail'
  end

  it 'com Telefone e E-mail em branco' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    cpf = CPF.generate
    new_employee = NewEmployee.create!(restaurant: restaurant, cpf: cpf, email: 'gertrudes@email.com')
    employee = User.create!(email: 'gertrudes@email.com', name: 'Gertrudes', cpf: cpf, password: 'asdflakjsdbnçfqbwkejb')

    login_as(employee)
    visit root_path
    click_on 'Novo pedido'
    click_on 'Criar Pedido'
    fill_in 'Nome', with: 'Eustáquio'
    cpf = CPF.generate
    fill_in 'CPF', with: cpf
    click_on 'Criar Pedido'

    expect(page).to have_content 'Pedido não criado'
    expect(page).to have_content 'É obrigatório informar Telefone ou E-mail'
  end

  it 'informando o telefone e deixando e-mail em branco' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    cpf = CPF.generate
    new_employee = NewEmployee.create!(restaurant: restaurant, cpf: cpf, email: 'gertrudes@email.com')
    employee = User.create!(email: 'gertrudes@email.com', name: 'Gertrudes', cpf: cpf, password: 'asdflakjsdbnçfqbwkejb')

    login_as(employee)
    visit root_path
    click_on 'Novo pedido'
    click_on 'Criar Pedido'
    fill_in 'Nome', with: 'Eustáquio'
    cpf = CPF.generate
    fill_in 'CPF', with: cpf
    fill_in 'Telefone', with: '11933310190'
    click_on 'Criar Pedido'

    expect(page).to have_content 'Pedido criado com sucesso'
  end

  it 'informando o e-mail e deixando telefone em branco' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    cpf = CPF.generate
    new_employee = NewEmployee.create!(restaurant: restaurant, cpf: cpf, email: 'gertrudes@email.com')
    employee = User.create!(email: 'gertrudes@email.com', name: 'Gertrudes', cpf: cpf, password: 'asdflakjsdbnçfqbwkejb')

    login_as(employee)
    visit root_path
    click_on 'Novo pedido'
    click_on 'Criar Pedido'
    fill_in 'Nome', with: 'Eustáquio'
    cpf = CPF.generate
    fill_in 'CPF', with: cpf
    fill_in 'E-mail', with: 'eustaquio@email.com'
    click_on 'Criar Pedido'

    expect(page).to have_content 'Pedido criado com sucesso'
  end

  it 'com CPF inválido' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    cpf = CPF.generate
    new_employee = NewEmployee.create!(restaurant: restaurant, cpf: cpf, email: 'gertrudes@email.com')
    employee = User.create!(email: 'gertrudes@email.com', name: 'Gertrudes', cpf: cpf, password: 'asdflakjsdbnçfqbwkejb')

    login_as(employee)
    visit root_path
    click_on 'Novo pedido'
    click_on 'Criar Pedido'
    fill_in 'Nome', with: 'Eustáquio'
    fill_in 'CPF', with: '120376'
    fill_in 'E-mail', with: 'eustaquio@email.com'
    click_on 'Criar Pedido'

    expect(page).to have_content 'Pedido não criado'
    expect(page).to have_content 'CPF não é válido'
  end

  it 'com email inválido' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    cpf = CPF.generate
    new_employee = NewEmployee.create!(restaurant: restaurant, cpf: cpf, email: 'gertrudes@email.com')
    employee = User.create!(email: 'gertrudes@email.com', name: 'Gertrudes', cpf: cpf, password: 'asdflakjsdbnçfqbwkejb')

    login_as(employee)
    visit root_path
    click_on 'Novo pedido'
    click_on 'Criar Pedido'
    fill_in 'Nome', with: 'Eustáquio'
    fill_in 'CPF', with: CPF.generate
    fill_in 'E-mail', with: 'eustaquioemail.com'
    click_on 'Criar Pedido'

    expect(page).to have_content 'Pedido não criado'
    expect(page).to have_content 'E-mail não é válido'
  end

  it 'com telefone inválido' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    cpf = CPF.generate
    new_employee = NewEmployee.create!(restaurant: restaurant, cpf: cpf, email: 'gertrudes@email.com')
    employee = User.create!(email: 'gertrudes@email.com', name: 'Gertrudes', cpf: cpf, password: 'asdflakjsdbnçfqbwkejb')

    login_as(employee)
    visit root_path
    click_on 'Novo pedido'
    click_on 'Criar Pedido'
    fill_in 'Nome', with: 'Eustáquio'
    fill_in 'CPF', with: CPF.generate
    fill_in 'E-mail', with: 'eustaquio#email.com'
    fill_in 'Telefone', with: 'asldkf'
    click_on 'Criar Pedido'

    expect(page).to have_content 'Pedido não criado'
    expect(page).to have_content 'Telefone não é válido'
  end
end