require 'rails_helper'

describe 'Usuário acessa a página inicial da aplicação' do 
  it 'e deve se autenticar' do
    visit root_path

    expect(current_path).to eq new_user_session_path
  end

  it 'e cria uma conta' do
    visit root_path
    click_on "Inscrever-se"

    expect(current_path).to eq new_user_registration_path

  end
end