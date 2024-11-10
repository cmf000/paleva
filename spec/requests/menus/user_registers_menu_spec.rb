require 'rails_helper'

describe 'Usuário cadastra novo cardápio' do 
  it 'e não é o dono do restaurante' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    other_user = User.create!(name: 'Zoroastro', email: 'zoroastro@email.com', password: 'çaslkdnfçqlwpe', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')

    login_as(other_user)
    post(restaurant_menus_path(restaurant_id: restaurant.id), params: { menu: { name: 'menu fantasma' } } )

    expect(response).to redirect_to root_path
  end
end
