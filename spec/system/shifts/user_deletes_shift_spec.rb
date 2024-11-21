require 'rails_helper'

describe 'Usuário remove turno' do
  it 'com sucesso' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                  cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                  city: "Ferraz de Vasconcelos", state: "SP",
                                  zip_code: "11111-111", owner: user,
                                  district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    travel_to Time.zone.local(1000, 1, 1, 18, 0, 0)
    Shift.create!(restaurant: restaurant, opening_time: Time.current, closing_time: 1.hour.from_now, weekday: 'wednesday')
    travel_back

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Alterar'
    within ("#wednesday") do
      click_on 'Remover'
    end

    expect(page).to have_content("Turno removido com sucesso")
    within("#wednesday") do
      expect(page).to have_content 'Fechado'
    end
  end
end