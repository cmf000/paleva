require 'rails_helper'

describe 'Usuário visita a página de uma bebida' do 
  it 'a partir da página inicial' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", user: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    beverage = Beverage.create!(restaurant: restaurant, name: 'Coca-cola', description: 'Delicioso tônico', calories: 1200, alcoholic: :no)
    offering_1 = Offering.create!(offerable: beverage, description: '350 ml', current_price: 8.00)
    offering_2 = Offering.create!(offerable: beverage, description: '500 ml', current_price: 10.00)
    offering_3 = Offering.create!(offerable: beverage, description: '2 L', current_price: 18.00)

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Coca-cola'
    
    expect(page).to have_content 'Coca-cola'
    expect(page).to have_content 'Delicioso tônico'
    expect(page).to have_content '1200 kcal'
    expect(page).to have_content 'Não-alcoólica'
    expect(page).to have_content 'Porções'
    expect(page).to have_content '350 ml'
    expect(page).to have_content '500 ml'
    expect(page).to have_content '2 L'
    expect(page).to have_content 'R$ 8,00'
    expect(page).to have_content 'R$ 10,00'
    expect(page).to have_content 'R$ 18,00'
  end

  it 'e volta à página do restaurante' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", user: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    beverage = Beverage.create!(restaurant: restaurant, name: 'Coca-cola', description: 'Delicioso tônico', calories: 1200, alcoholic: :no)
    offering_1 = Offering.create!(offerable: beverage, description: '350 ml', current_price: 8.00)

    offering_2 = Offering.create!(offerable: beverage, description: '500 ml', current_price: 10.00)

    offering_3 = Offering.create!(offerable: beverage, description: '2 L', current_price: 18.00)


    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Coca-cola'
    click_on 'Quitutes Picantes'

    expect(current_path).to eq restaurant_path(restaurant.id)
  end

  it 'e volta à página inicial' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", user: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    beverage = Beverage.create!(restaurant: restaurant, name: 'Coca-cola', description: 'Delicioso tônico', calories: 1200, alcoholic: :no)
    offering_1 = Offering.create!(offerable: beverage, description: '350 ml', current_price: 8.00)

    offering_2 = Offering.create!(offerable: beverage, description: '500 ml', current_price: 10.00)

    offering_3 = Offering.create!(offerable: beverage, description: '2 L', current_price: 18.00)


    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Coca-cola'
    click_on 'Paleva'

    expect(current_path).to eq restaurants_path
  end

  it 'e não há porções cadastradas' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", user: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    beverage = Beverage.create!(restaurant: restaurant, name: 'Coca-cola', description: 'Delicioso tônico', calories: 1200, alcoholic: :no)

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Coca-cola'
    
    expect(page).to have_content 'Não há porções cadastradas'
  end

  it 'e não é o dono do restaurante' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", user: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    other_user = User.create!(name: 'Zoroastro', email: 'zoroastro@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    other_restaurant = Restaurant.create!(registered_name: "Churros LTDA", trade_name: "Churros",
                                    cnpj: CNPJ.generate, street_address: "Avenida Doce, 456",
                                    city: "Guarulhos", state: "SP",
                                    zip_code: "33333-333", user: other_user,
                                    district: "Doces", email: 'churros@email.com', phone_number: '11933301040')
    beverage = Beverage.create!(restaurant: restaurant, name: 'Coca-cola', description: 'Delicioso tônico', calories: 1200, alcoholic: :no)

    login_as(other_user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Coca-cola'

    expect(current_path).to eq restaurants_path
  end
end