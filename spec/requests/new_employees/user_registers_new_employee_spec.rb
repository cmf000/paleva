require 'rails_helper'

describe 'Usuário pré-cadastra funcionário para um restaurante' do 
  it 'e não é o dono' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    cpf = CPF.generate
    new_employee = NewEmployee.create!(restaurant: restaurant, email: 'gertrudes@email.com', cpf: cpf)
    employee = User.create!(name: 'Gertrudes', email: 'gertrudes@email.com', cpf: cpf, password: 'asdfqwerasdfqwer')

    login_as(employee)
    post(restaurant_new_employees_path(restaurant_id: restaurant.id), params: { new_employee: { email: 'domestaquio@email.com', cpf: CPF.generate } })

    expect(response).to redirect_to root_path
  end
end