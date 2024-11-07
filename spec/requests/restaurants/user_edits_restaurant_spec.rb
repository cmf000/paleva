require 'rails_helper'

describe 'Usuário edita um restaurante' do 
  it 'e não é o dono' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    other_user = User.create!(name: 'Zoroastro', email: 'zoroastro@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    other_restaurant = Restaurant.create!(registered_name: "Sabores do Brasil LTDA", trade_name: "Sabores do Brasil",
                       cnpj: CNPJ.generate, street_address: "Rua das Palmeiras, 123", district: 'Santana',
                       city: "São Paulo", state: "SP", zip_code: "01000-000", owner: other_user,
                       email: 'saboresdobrasil@email.com', phone_number: '11933301020')

    login_as(other_user)
    patch(restaurant_path(restaurant.id), params: {restaurant: { trade_name: 'Quitutes Mortais' } })
    restaurant.reload

    expect(restaurant.trade_name).not_to eq 'Quitutes Mortais'
    expect(response).to redirect_to root_path
  end
  
end