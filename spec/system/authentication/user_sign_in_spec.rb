require 'rails_helper'

describe 'usuário realiza login' do
  it 'e faz logout' do
    User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'asdfqewrasdf', cpf: CPF.generate)

    visit root_path
    fill_in 'E-mail', with: 'amarildo@email.com'
    fill_in 'Senha', with: 'asdfqewrasdf'
    click_on 'Login'
    click_on 'Sair'

    expect(current_path).to eq new_user_session_path
  end
  it 'e precisa cadastrar um restaurante' do 
    User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'asdfqewrasdf', cpf: CPF.generate)

    visit root_path
    fill_in 'E-mail', with: 'amarildo@email.com'
    fill_in 'Senha', with: 'asdfqewrasdf'
    click_on 'Login'

    expect(current_path).to eq new_restaurant_path
    expect(page).to have_content 'Login efetuado com sucesso.'
  end

  it 'e já tem um restaurante vinculado à sua conta' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'asdfqewrasdf', cpf: CPF.generate)
    Restaurant.create!(registered_name: "Sabores do Brasil LTDA", trade_name: "Sabores do Brasil",
                       cnpj: CNPJ.generate, street_address: "Rua das Palmeiras, 123", district: 'Santana',
                       city: "São Paulo", state: "SP", zip_code: "01000-000", owner: user,
                       email: 'saboresdobrasil@email.com', phone_number: '11933301020')

    visit root_path
    fill_in 'E-mail', with: 'amarildo@email.com'
    fill_in 'Senha', with: 'asdfqewrasdf'
    click_on 'Login'

    expect(current_path).to eq restaurants_path
    expect(page).to have_content 'Login efetuado com sucesso.'
  end

  it 'com dados incorretos' do
    User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'asdfqewrasdf', cpf: CPF.generate)

    visit root_path
    fill_in 'E-mail', with: 'a@email.com'
    fill_in 'Senha', with: 'ewrasdf'
    click_on 'Login'

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content ('E-mail ou senha inválidos.')
  end
end
