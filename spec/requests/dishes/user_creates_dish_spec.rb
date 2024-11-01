require 'rails_helper'

describe 'Usuário cria um prato' do 
  it 'e não é dono do restaurante' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    other_user = User.create!(name: 'Zoroastro', email: 'zoroastro@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", user: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')

    login_as(other_user)
    post(restaurant_dishes_path(restaurant.id), params: { dish: { restaurant: restaurant, name: 'Hamburguer', description: 'carne, queijo, mostarda', calories: 120 } })
   
    expect(response).to redirect_to root_path
  end
end