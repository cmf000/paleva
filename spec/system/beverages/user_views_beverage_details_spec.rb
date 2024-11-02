require 'rails_helper'

describe 'Usuário visita a página de uma bebida' do 
  it 'a partir da página inicial' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", user: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    beverage = Beverage.create!(restaurant: restaurant, name: 'Coca-cola', description: 'Delicioso tônico', calories: 1200, alcoholic: :no)
    offering_1 = Offering.new(offerable: beverage, description: '350 ml')
    offering_1.price_histories.build(price: 6.0, effective_date: DateTime.now)
    offering_1.save

    offering_2 = Offering.new(offerable: beverage, description: '500 ml')
    offering_2.price_histories.build(price: 8.0, effective_date: DateTime.now - 1.week)
    offering_2.save

    offering_3 = Offering.new(offerable: beverage, description: '2 L')
    offering_3.price_histories.build(price: 12.0, effective_date: DateTime.now - 2.week)
    offering_3.save


    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Coca-cola'
    
    expect(page).to have_content 'Coca-cola'
    expect(page).to have_content 'Delicioso tônico'
    expect(page).to have_content '1200 kcal'
    expect(page).to have_content 'Não-alcoólica'
    expect(page).to have_content 'Porções'

  end
end