require 'rails_helper'

describe 'Usuário vê pedidos' do
  it 'a partir da página inicial' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    menu = Menu.create!(restaurant: restaurant, name: 'Jantar')
    dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'pão, carne, queijo', calories: 1200)
    offering = Offering.create!(offerable: dish, description: 'médio', current_price: 8.00)
    menu.dishes << dish
    order = Order.create!(restaurant: restaurant, customer_name: 'Derp', email: 'derp@email.com')
    order_1 = Order.create!(restaurant: restaurant, customer_name: 'Derpina', email: 'derpina@email.com')
    order_1.offerings << offering
    order_1.pending_kitchen!

    order_2 = Order.create!(restaurant: restaurant, customer_name: 'Derpina', email: 'derpina@email.com')
    order_2.offerings << offering
    order_2.pending_kitchen!
    order_2.preparing!

    order_3 = Order.create!(restaurant: restaurant, customer_name: 'Derpina', email: 'derpina@email.com')
    order_3.offerings << offering
    order_3.pending_kitchen!
    order_3.preparing!
    order_3.ready!

    order_4 = Order.create!(restaurant: restaurant, customer_name: 'Derpina', email: 'derpina@email.com')
    order_4.offerings << offering
    order_4.pending_kitchen!
    order_4.preparing!
    order_4.ready!
    order_4.delivered!

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    click_on 'Ver Pedidos'

    within("##{dom_id order}") do
      expect(page).to have_content 'Derp'
      expect(page).to have_content 'Aguardando finalização'
      expect(page).to have_content number_to_currency(order.total_price)
    end

    within("##{dom_id order_1}") do
      expect(page).to have_content 'Derpina'
      expect(page).to have_content 'Aguardando confirmação da cozinha'
      expect(page).to have_content number_to_currency(order_1.total_price)
      expect(page).to have_content order_1.placed_at.strftime('%H:%M')
    end

    within("##{dom_id order_2}") do
      expect(page).to have_content 'Derp'
      expect(page).to have_content 'Em preparação'
    end

    within("##{dom_id order_3}") do
      expect(page).to have_content 'Derp'
      expect(page).to have_content 'Pronto'
    end

    within("##{dom_id order_4}") do
      expect(page).to have_content 'Derp'
      expect(page).to have_content 'Entregue'
    end
  end
end