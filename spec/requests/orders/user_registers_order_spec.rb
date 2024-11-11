require 'rails_helper'

describe 'Usuário cadastra um novo pedido' do
  it 'e não é o dono ou trabalha no restaurante' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    other_user = User.create!(name: 'Zoroastro', email: 'zoroastro@email.com', password: 'alsdkjfaksdlkkjhased', cpf: CPF.generate)

    login_as(other_user)
    post(restaurant_orders_path(restaurant), params: { order: { name: 'Amarildo', cpf: CPF.generate, email: 'amarildo@email.com', phone_number: '11933301090'}})

    expect(response).to redirect_to root_path
  end
end