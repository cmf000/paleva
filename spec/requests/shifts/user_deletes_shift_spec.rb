require 'rails_helper'

describe 'Usuário remove turno' do
  it 'e funcionário não pode alterar os horários de funcionamento' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                       cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                       city: "Ferraz de Vasconcelos", state: "SP",
                       zip_code: "11111-111", owner: user,
                       district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    cpf = CPF.generate
    new_employee = NewEmployee.create!(restaurant: restaurant, cpf: cpf, email: 'gertrudes@email.com')
    employee = User.create!(cpf: cpf, email: 'gertrudes@email.com', name: 'Gertrudes', password: 'asdfqwerasdf')
    travel_to Time.zone.local(1000, 1, 1, 18, 0, 0)
    shift = Shift.create!(restaurant: restaurant, opening_time: Time.current, closing_time: 1.hour.from_now, weekday: 'wednesday')
    travel_back
    
    login_as(employee)
    delete restaurant_shift_path(restaurant, shift)

    expect(response).to redirect_to root_path
  end
end