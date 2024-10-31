require 'rails_helper'
include ActionView::RecordIdentifier

describe 'Usuário visita página de editar bebida' do 
  it 'e vê os campos de edição' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", user: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    beverage = Beverage.create!(restaurant: restaurant, name: 'Coca-cola', description: 'delicioso tônico', calories: 1200, alcoholic: :no)

    login_as(user)
    visit root_path
    click_on "Quitutes Picantes"
    within("##{dom_id(beverage)}") do
      click_on 'Editar'
    end

    expect(page).to have_field(id: 'beverage_name')
    expect(page).to have_field(id: 'beverage_description')
    expect(page).to have_field(id: 'beverage_calories')
    expect(page).to have_field(id: 'beverage_image')
    expect(page).to have_field(id: 'beverage_alcoholic_yes')
    expect(page).to have_field(id: 'beverage_alcoholic_no')
  end

  it 'e volta à página do restaurante' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", user: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    beverage = Beverage.create!(restaurant: restaurant, name: 'Coca-cola', description: 'delicioso tônico', calories: 1200, alcoholic: :no)

    login_as(user)
    visit root_path
    click_on "Quitutes Picantes"
    within("##{dom_id(beverage)}") do
      click_on 'Editar'
    end
    click_on 'Quitutes Picantes'

    expect(current_path).to eq restaurant_path(restaurant.id)

  end
end