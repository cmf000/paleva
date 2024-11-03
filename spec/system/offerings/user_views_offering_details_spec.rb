require 'rails_helper'

describe 'Usuário vê detalhes de uma porção' do
  it 'a partir da tela inicial' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", user: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'pão, carne, queijo', calories: 1200)
    offering_1 = Offering.create!(offerable: dish, description: 'pequeno', current_price: 20)
    offering_2 = Offering.create!(offerable: dish, description: 'grande', current_price: 30)
    offering_3 = Offering.create!(offerable: dish, description: 'extra-grande', current_price: 40)
    offering_3.update(current_price: 50)
    offering_3.update(current_price: 60)

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Hamburguer'
    click_on 'extra-grande'

    within('.price_history') do 
      expect(page).to have_content 'R$ 40,00'
      expect(page).to have_content I18n.localize(offering_3.price_histories[0].effective_at)
      expect(page).to have_content 'R$ 50,00'
      expect(page).to have_content I18n.localize(offering_3.price_histories[1].effective_at)
    end
    expect(page).to have_content 'extra-grande'
    expect(page).to have_content I18n.localize(offering_3.effective_at)
  end

  it 'e volta á página inicial' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", user: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'pão, carne, queijo', calories: 1200)
    offering = Offering.create!(offerable: dish, description: 'extra-grande', current_price: 40)

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Hamburguer'
    click_on 'extra-grande'
    click_on 'Paleva'

    expect(current_path).to eq restaurants_path
  end

  it 'e volta à página do restaurante' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", user: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'pão, carne, queijo', calories: 1200)
    offering = Offering.create!(offerable: dish, description: 'extra-grande', current_price: 40)

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Hamburguer'
    click_on 'extra-grande'
    click_on 'Quitutes Picantes'

    expect(current_path).to eq restaurant_path(restaurant.id)
  end

  it 'e volta à página do item ofertável' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", user: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'pão, carne, queijo', calories: 1200)
    offering = Offering.create!(offerable: dish, description: 'extra-grande', current_price: 40)

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Hamburguer'
    click_on 'extra-grande'
    click_on 'Hamburguer'

    expect(current_path).to eq restaurant_dish_path(restaurant.id, dish.id)
  end
end