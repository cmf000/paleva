require 'rails_helper'

describe 'Usuário acessa a página de cadastrar restaurante' do
    it 'e cadastra um restaurante com sucesso' do
      user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'asdfqewrasdf', cpf: CPF.generate)
      login_as(user)
      cnpj = CNPJ.generate

      visit root_path
      fill_in 'Razão social', with: 'Picante LTDA'
      fill_in 'Nome fantasia', with: 'Quitutes Picantes'
      fill_in 'CNPJ', with: cnpj
      fill_in 'Email', with: 'picante@email.com'
      fill_in 'Linha de endereço', with: "Avenida Quente, 456"
      fill_in 'Bairro', with: 'Pimentas'
      fill_in 'Cidade', with: 'Ferraz de Vasconcelos'
      fill_in 'Estado', with: 'SP'
      fill_in 'Telefone', with: '11933301020'
      fill_in 'CEP', with: '11111-111'
      within('#sunday') do
        check 'Fechado'
      end
      within('#monday') do
        select '17', from: 'restaurant_shifts_attributes_1_opening_time_4i'
        select '00', from: 'restaurant_shifts_attributes_1_opening_time_5i'
        select '23', from: 'restaurant_shifts_attributes_1_closing_time_4i'
        select '00', from: 'restaurant_shifts_attributes_1_closing_time_5i'
      end
      within('#tuesday') do
        check 'Fechado'
      end
      within('#wednesday') do
        check 'Fechado'
      end
      within('#thursday') do
        check 'Fechado'
      end
      within('#friday') do
        check 'Fechado'
      end
      within('#saturday') do
        check 'Fechado'
      end
      click_on 'Criar Restaurante'

      expect(page).to have_content 'Restaurante cadastrado com sucesso.'

    end

    it 'e cadastra um restaurante com dados incompletos' do
      user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'asdfqewrasdf', cpf: CPF.generate)
      login_as(user)

      visit root_path
      within('#sunday') do
        check 'Fechado'
      end
      within('#monday') do
        check('Fechado')
      end
      within('#tuesday') do
        check 'Fechado'
      end
      within('#wednesday') do
        check 'Fechado'
      end
      within('#thursday') do
        check 'Fechado'
      end
      within('#friday') do
        check 'Fechado'
      end
      within('#saturday') do
        check 'Fechado'
      end
      click_on 'Criar Restaurante'

      expect(page).to have_content 'Restaurante não cadastrado.'
      expect(page).to have_content 'Nome fantasia não pode ficar em branco'
      expect(page).to have_content 'Linha de endereço não pode ficar em branco'
      expect(page).to have_content 'Bairro não pode ficar em branco'
      expect(page).to have_content 'CNPJ não pode ficar em branco'
      expect(page).to have_content 'Cidade não pode ficar em branco'
      expect(page).to have_content 'Estado não pode ficar em branco'
      expect(page).to have_content 'CEP não pode ficar em branco'
      expect(page).to have_content 'Email não pode ficar em branco'
      expect(page).to have_content 'Telefone é muito curto (mínimo: 10 caracteres)'
    end

    it 'e cadastra um restaurante com dados inválidos' do
      user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'asdfqewrasdf', cpf: CPF.generate)
      login_as(user)

      visit root_path

      fill_in 'Razão social', with: 'Picante LTDA'
      fill_in 'Nome fantasia', with: 'Quitutes Picantes'
      fill_in 'Linha de endereço', with: "Avenida Quente, 456"
      fill_in 'Bairro', with: 'Pimentas'
      fill_in 'Cidade', with: 'Ferraz de Vasconcelos'
      fill_in 'Estado', with: 'SP'
      fill_in 'CEP', with: '11111-111'

      fill_in 'Email', with: 'asdf'
      fill_in 'Telefone', with: 'asdf'
      fill_in 'CNPJ', with: '1234'
      click_on 'Criar Restaurante'

      expect(page).to have_content('Horário de encerramento deve ser depois do horário de início do turno.')
      expect(page).to have_content('Email não é válido')
      expect(page).to have_content 'Telefone é muito curto (mínimo: 10 caracteres)'
      expect(page).to have_content('CNPJ não é válido')
      expect(page).to have_content('Telefone não é válido')
    end

    it 'e já tem um restaurante cadastrado' do
      user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
      Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                         cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                         city: "Ferraz de Vasconcelos", state: "SP",
                         zip_code: "11111-111", owner: user,
                         district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
      
      login_as(user)
      visit new_restaurant_path

      expect(current_path).to eq restaurants_path
    end

    it 'e é funcionário' do 
      user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
      restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
      cpf = CPF.generate
      new_employee = NewEmployee.create(restaurant: restaurant, email: 'gertrudes@email.com', cpf: cpf)
      employee = User.create!(name: 'Gertrudes', email: 'gertrudes@email.com', cpf: cpf, password: 'asdfasdfasdfasdfqwer')

      login_as(employee)
      visit new_restaurant_path

      expect(current_path).to eq restaurant_path(employee.works_at_restaurant)
    end
end 