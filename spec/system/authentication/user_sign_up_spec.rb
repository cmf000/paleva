require 'rails_helper'

describe 'Usuário registra uma conta' do
  it 'do tipo dono com sucesso' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
        
    visit root_path
    click_on 'Inscrever-se'
    fill_in 'Nome', with: 'Carlos Gomes'
    fill_in 'CPF', with: CPF.generate
    fill_in 'E-mail', with: 'zoroastro@email.com'
    fill_in 'Senha', with: 'alskdjfbh9873245%@24alsk'
    fill_in 'Confirme sua senha', with: 'alskdjfbh9873245%@24alsk'
    click_on 'Inscrever-se'

    expect(page).to have_content 'Bem vindo! Você realizou seu registro com sucesso.'
    expect(current_path).to eq new_restaurant_path
    expect(User.last.email).to eq 'zoroastro@email.com'
  end

  it 'e todos os dados devem ser preenchidos' do
    visit root_path
    click_on 'Login'
    click_on 'Inscrever-se'
  
    fill_in 'Nome', with: ''
    fill_in 'CPF', with: ''
    fill_in 'E-mail', with: ''
    fill_in 'Senha', with: ''
    fill_in 'Confirme sua senha', with: ''
    click_on 'Inscrever-se'
  
    expect(page).to have_content 'Não foi possível salvar usuário: 6 erros.'
    expect(page).to have_content 'E-mail não pode ficar em branco'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Senha não pode ficar em branco'
    expect(page).to have_content 'CPF não pode ficar em branco'
    expect(page).to have_content 'CPF não é válido'
  end
  

  it 'e E-mail e CPF já estão cadastrados' do
    cpf = CPF.generate
    User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: cpf)

    visit root_path
    click_on 'Inscrever-se'
    fill_in 'Nome', with: 'Zoroastro'
    fill_in 'CPF', with: cpf
    fill_in 'E-mail', with: 'amarildo@email.com'
    fill_in 'Senha', with: 'vn3@sot8*#09'
    fill_in 'Confirme sua senha', with: 'vn3@sot8*#09'
    click_on 'Inscrever-se'

    expect(page).to have_content 'Não foi possível salvar usuário: 2 erros.'
    expect(page).to have_content 'E-mail já existe'
    expect(page).to have_content 'CPF já existe'
  end

  it 'do tipo funcionário com sucesso' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    cpf = CPF.generate
    new_employee = NewEmployee.create!(restaurant: restaurant, cpf: cpf, email: 'gertrudes@email.com')
        
    visit root_path
    click_on 'Inscrever-se'
    fill_in 'Nome', with: 'Gertrudes'
    fill_in 'CPF', with: cpf
    fill_in 'E-mail', with: 'gertrudes@email.com'
    fill_in 'Senha', with: 'asdfqwerasdf'
    fill_in 'Confirme sua senha', with: 'asdfqwerasdf'
    click_on 'Inscrever-se'

    expect(page).to have_content 'Bem vindo! Você realizou seu registro com sucesso.'
    expect(User.last.user_type).to eq 'employee'
    expect(current_path).to eq restaurant_path(restaurant)
  end

  it 'do tipo funcionário com diferentes do pré-cadastro' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    cpf = CPF.generate
    other_cpf = CPF.generate
    new_employee = NewEmployee.create!(restaurant: restaurant, cpf: cpf, email: 'gertrudes@email.com')
    other_new_employee = NewEmployee.create!(restaurant: restaurant, cpf: other_cpf, email: 'domestaquio@email.com')
        
    visit root_path
    click_on 'Inscrever-se'
    fill_in 'Nome', with: 'Gertrudes'
    fill_in 'CPF', with: cpf
    fill_in 'E-mail', with: 'domestaquio@email.com'
    fill_in 'Senha', with: 'asdfqwerasdf'
    fill_in 'Confirme sua senha', with: 'asdfqwerasdf'
    click_on 'Inscrever-se'

    expect(page).to have_content 'Não foi possível salvar usuário: 2 erros.'
    expect(page).to have_content 'E-mail não é válido'
    expect(page).to have_content 'CPF não é válido'
  end
end
