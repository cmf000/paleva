require 'rails_helper'

describe 'Usuário edita bebida' do 
  it 'e não é o dono do restaurante' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    other_user = User.create!(name: 'Zoroastro', email: 'zoroastro@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    beverage = Beverage.create!(restaurant: restaurant, name: 'Coca-cola', description: '2L', calories: 1200, alcoholic: :no)
    Restaurant.create!(registered_name: "Churros LTDA", trade_name: "Churros",
                                    cnpj: CNPJ.generate, street_address: "Avenida dos Churros, 456",
                                    city: "Guarulhos", state: "SP",
                                    zip_code: "22222-222", owner: other_user,
                                    district: "Bairro dos Churros", email: 'churros@email.com', phone_number: '11933301050')

    login_as(other_user)
    patch(restaurant_beverage_path(restaurant.id, beverage.id), params: { beverage: { description: 'Bebida venenosa' } })
    beverage.reload

    expect(beverage.description).not_to eq 'Bebida venenosa'
    expect(response).to redirect_to root_path       
  end

  it 'e é funcionário do restaurante' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    other_user = User.create!(name: 'Zoroastro', email: 'zoroastro@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)

    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    beverage = Beverage.create!(restaurant: restaurant, name: 'Coca-cola', description: '2L', calories: 1200, alcoholic: :no)

    cpf = CPF.generate
    new_employee = NewEmployee.create(restaurant: restaurant, email: 'gertrudes@email.com', cpf: cpf)
    employee = User.create!(name: 'Gertrudes', email: 'gertrudes@email.com', cpf: cpf, password: 'asdfasdfasdfasdfqwe')

    login_as(employee)
    patch(restaurant_beverage_path(restaurant.id, beverage.id), params: { beverage: { description: 'Bebida venenosa' } })
    beverage.reload

    expect(beverage.description).not_to eq 'Bebida venenosa'
    expect(response).to redirect_to root_path     
  end
end