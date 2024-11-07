require 'rails_helper'

describe 'Usuário visita a página de um prato' do 
  it 'a partir da página inicial' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'pão, carne, queijo', calories: 1200)
    offering_1 = Offering.create!(offerable: dish, description: 'pequeno', current_price: 20)
    offering_2 = Offering.create!(offerable: dish, description: 'grande', current_price: 30)
    offering_3 = Offering.create!(offerable: dish, description: 'extra-grande', current_price: 40)


    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Hamburguer'
    
    expect(page).to have_content 'Hamburguer'
    expect(page).to have_content 'pão, carne, queijo'
    expect(page).to have_content '1200 kcal'
    expect(page).to have_content 'Porções'
    expect(page).to have_content 'pequeno'
    expect(page).to have_content 'grande'
    expect(page).to have_content 'extra-grande'
    expect(page).to have_content 'R$ 20,00'
    expect(page).to have_content 'R$ 30,00'
    expect(page).to have_content 'R$ 40,00'
  end

  it 'e volta à página do restaurante' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'pão, carne, queijo', calories: 1200)

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Hamburguer'
    click_on 'Quitutes Picantes'

    expect(current_path).to eq restaurant_path(restaurant.id)
  end

  it 'e volta à página inicial' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'pão, carne, queijo', calories: 1200)

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Hamburguer'
    click_on 'Paleva'

    expect(current_path).to eq restaurants_path
  end

  it 'e não há porções cadastradas' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'pão, carne, queijo', calories: 1200)

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Hamburguer'

    expect(page).to have_content 'Não há porções cadastradas'
  end

  it 'e não é o dono do restaurante' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    other_user = User.create!(name: 'Zoroastro', email: 'zoroastro@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    other_restaurant = Restaurant.create!(registered_name: "Churros LTDA", trade_name: "Churros",
                                    cnpj: CNPJ.generate, street_address: "Avenida Doce, 456",
                                    city: "Guarulhos", state: "SP",
                                    zip_code: "33333-333", owner: other_user,
                                    district: "Doces", email: 'churros@email.com', phone_number: '11933301040')
    dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'pão, carne, queijo', calories: 1200)

    login_as(other_user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Hamburguer'

    expect(current_path).to eq restaurants_path
  end
end