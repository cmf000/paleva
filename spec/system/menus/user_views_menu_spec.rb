 require 'rails_helper'
 
 describe 'Usuário dono abre a página de um cardápio' do
    it 'a partir da tela inicial' do 
      user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
      restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
      menu = Menu.create!(restaurant: restaurant, name: 'Jantar')
      dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'pão, carne, queijo', calories: 1200)
      offering = Offering.create!(offerable: dish, description: 'médio', current_price: 8.00)
      menu.dishes << dish
      
      login_as(user)
      visit root_path
      click_on 'Quitutes Picantes'
      click_on "#{dom_id(menu)}-details"

      expect(page).to have_content 'Adicionar Item'
      expect(page).to have_content 'Hamburguer'
      expect(page).to have_content 'médio'
      expect(page).to have_content 'R$ 8,00'

    end 

    it 'e volta à página do restaurante' do 
      user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
      restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
      menu = Menu.create!(restaurant: restaurant, name: 'Jantar')
      dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'pão, carne, queijo', calories: 1200)
      offering = Offering.create!(offerable: dish, description: 'médio', current_price: 8.00)
      menu.dishes << dish
      
      login_as(user)
      visit root_path
      click_on 'Quitutes Picantes'
      click_on "#{dom_id(menu)}-details"
      click_on 'Quitutes Picantes'

      expect(current_path).to eq restaurant_path(restaurant)

    end 
  end

  describe 'Usuário funcionário abre a página de um cardápio' do
    it 'a partir da tela inicial' do 
      user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
      restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
      menu = Menu.create!(restaurant: restaurant, name: 'Jantar')
      dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'pão, carne, queijo', calories: 1200)
      offering = Offering.create!(offerable: dish, description: 'médio', current_price: 8.00)
      menu.dishes << dish
      cpf = CPF.generate
      new_employee = NewEmployee.create!(restaurant: restaurant, cpf: cpf, email: 'gertrudes@email.com')
      employee = User.create!(name: 'Gertrudes', cpf: cpf, email: 'gertrudes@email.com', password: 'asdfalsdknfçaklsdnf')
      
      login_as(employee)
      visit root_path
      click_on "#{dom_id(menu)}-details"

      expect(page).to have_content 'Hamburguer'
      expect(page).to have_content 'médio'
      expect(page).to have_content 'R$ 8,00'

    end 

    it 'e volta à página do restaurante' do 
      user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
      restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
      menu = Menu.create!(restaurant: restaurant, name: 'Jantar')
      dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'pão, carne, queijo', calories: 1200)
      offering = Offering.create!(offerable: dish, description: 'médio', current_price: 8.00)
      menu.dishes << dish
      cpf = CPF.generate
      new_employee = NewEmployee.create!(restaurant: restaurant, cpf: cpf, email: 'gertrudes@email.com')
      employee = User.create!(name: 'Gertrudes', cpf: cpf, email: 'gertrudes@email.com', password: 'asdfalsdknfçaklsdnf')
      
      login_as(employee)
      visit root_path
      click_on "#{dom_id(menu)}-details"
      click_on 'Quitutes Picantes'

      expect(current_path).to eq restaurant_path(restaurant)

    end 
  end