require 'rails_helper'

describe 'Usuário vê a página de detalhes de uma porção' do
  it 'e não é o dono do restaurante' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    other_user = User.create!(name: 'Zoroastro', email: 'zoroastro@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    Restaurant.create!(registered_name: "Churros LTDA", trade_name: "Churros",
                                    cnpj: CNPJ.generate, street_address: "Avenida dos Churros, 456",
                                    city: "Guarulhos", state: "SP",
                                    zip_code: "22222-222", owner: other_user,
                                    district: "Bairro dos Churros", email: 'churros@email.com', phone_number: '11933301050')
    dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'pão, carne, queijo', calories: 1200)
    offering = Offering.create!(offerable: dish, description: '350 ml', current_price: 8.00)

    login_as(other_user)
    get(restaurant_dish_offering_path(restaurant, dish, offering))

    expect(response).to redirect_to root_path
  end
end