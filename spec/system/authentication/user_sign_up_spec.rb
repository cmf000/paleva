require 'rails_helper'

describe 'Usuário registra uma conta' do
  it 'com sucesso' do 
    visit root_path
    click_on 'Inscrever-se'
    fill_in 'Nome', with: 'Carlos Gomes'
    fill_in 'CPF', with: CPF.generate
    fill_in 'E-mail', with: 'zoroastro@email.com'
    fill_in 'Senha', with: 'alskdjfbh9873245%@24alsk'
    fill_in 'Confirme sua senha', with: 'alskdjfbh9873245%@24alsk'
    click_on 'Inscrever-se'

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
  
    
    expect(page).to have_content 'Não foi possível salvar usuário: 4 erros.'
    expect(page).to have_content 'E-mail não pode ficar em branco'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Senha não pode ficar em branco'
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
end
