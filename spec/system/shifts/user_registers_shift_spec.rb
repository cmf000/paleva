require 'rails_helper'

describe 'Usuário cadastrar um novo horário de funcionamento' do 
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
    click_on 'Alterar'
    select 'Sexta-feira', from: "Dia da semana"
    fill_in 'Início', with: '10:30'
    fill_in 'Encerramento', with: '17:00'
    click_on 'Criar Turno'

    expect(page).to have_content 'Turno criado com sucesso'
    within("#friday") do
      expect(page).to have_content '10:30 às 17:00'
    end
  end

  it 'a partir da criação de um novo usuário' do
    visit root_path
    click_on 'Inscrever-se'
    fill_in 'Nome', with: 'Carlos Gomes'
    fill_in 'CPF', with: CPF.generate
    fill_in 'E-mail', with: 'zoroastro@email.com'
    fill_in 'Senha', with: 'alskdjfbh9873245%@24alsk'
    fill_in 'Confirme sua senha', with: 'alskdjfbh9873245%@24alsk'
    click_on 'Inscrever-se'
    fill_in 'Razão social', with: 'Picante LTDA'
    fill_in 'Nome fantasia', with: 'Quitutes Picantes'
    fill_in 'CNPJ', with: CNPJ.generate
    fill_in 'Email', with: 'picante@email.com'
    fill_in 'Linha de endereço', with: "Avenida Quente, 456"
    fill_in 'Bairro', with: 'Pimentas'
    fill_in 'Cidade', with: 'Ferraz de Vasconcelos'
    fill_in 'Estado', with: 'SP'
    fill_in 'Telefone', with: '11933301020'
    fill_in 'CEP', with: '11111-111'
    click_on 'Criar Restaurante'

    expect(page).to have_field("Dia da semana")
    expect(page).to have_field("Início")
    expect(page).to have_field("Encerramento")
    expect(page).to have_button("Criar Turno")

    within("#sunday") do
      expect(page).to have_content 'Fechado'
    end

    within("#monday") do
      expect(page).to have_content 'Fechado'
    end

    within("#tuesday") do
      expect(page).to have_content 'Fechado'
    end

    within("#wednesday") do
      expect(page).to have_content 'Fechado'
    end

    within("#thursday") do
      expect(page).to have_content 'Fechado'
    end

    within("#friday") do
      expect(page).to have_content 'Fechado'
    end

    within("#saturday") do
      expect(page).to have_content 'Fechado'
    end
  end

  it 'turnos não podem sobrepor uns aos outros' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                  cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                  city: "Ferraz de Vasconcelos", state: "SP",
                                  zip_code: "11111-111", owner: user,
                                  district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Alterar'
    select 'Sexta-feira', from: "Dia da semana"
    fill_in 'Início', with: '10:30'
    fill_in 'Encerramento', with: '17:00'
    click_on 'Criar Turno'
    select 'Sexta-feira', from: "Dia da semana"
    fill_in 'Início', with: '14:30'
    fill_in 'Encerramento', with: '17:00'
    click_on 'Criar Turno'

    expect(page).to have_content 'Turno não criado'
    expect(page).to have_content 'Turnos não podem sobrepor uns aos outros'
  end

  it 'horário de encerramento deve ser depois do horário de início' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                  cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                  city: "Ferraz de Vasconcelos", state: "SP",
                                  zip_code: "11111-111", owner: user,
                                  district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Alterar'
    select 'Sexta-feira', from: "Dia da semana"
    fill_in 'Início', with: '18:00'
    fill_in 'Encerramento', with: '17:00'
    click_on 'Criar Turno'

    expect(page).to have_content 'Turno não criado'
    expect(page).to have_content 'Encerramento deve ser depois do horário de início do turno.'
  end

  it 'e volta à página inicial' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                  cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                  city: "Ferraz de Vasconcelos", state: "SP",
                                  zip_code: "11111-111", owner: user,
                                  district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Alterar'
    click_on 'Quitutes Picantes'

    expect(current_path).to eq restaurant_path(restaurant)

  end

  it 'funcionário não vê botão de alterar horários' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                  cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                  city: "Ferraz de Vasconcelos", state: "SP",
                                  zip_code: "11111-111", owner: user,
                                  district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    cpf = CPF.generate
    new_employee = NewEmployee.create!(cpf: cpf, email: 'gertrudes@email.com', restaurant: restaurant)
    employee = User.create!(email: 'gertrudes@email.com', name: 'Gertrudes', cpf: cpf, password: 'açslkdfnçalsebçrkan')

    login_as(employee)
    
    expect(page).not_to have_button("Alterar")
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
    click_on 'Alterar'
    click_on 'Criar Turno'

    expect(page).to have_content 'Turno não criado'
    expect(page).to have_content 'Início não pode ficar em branco'
    expect(page).to have_content 'Encerramento não pode ficar em branco'
  end
end