require 'rails_helper'

describe "Order API" do
  context 'GET /api/v1/orders/restaurant_code' do
    it 'sucesso' do
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
      order_1 = Order.create!(restaurant: restaurant, customer_name: 'Derp', email: 'derp@email.com')
      order_1.offerings << offering
      order_2 = Order.create!(restaurant: restaurant, customer_name: 'Derpina', email: 'derpina@email.com')
      order_2.offerings << offering 
      order_2.pending_kitchen!

      get api_v1_restaurant_orders_path(restaurant.code), params: {status: "pending_kitchen" }
      json_response = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(response.content_type).to include 'application/json'
      expect(json_response.class).to eq Array
      expect(json_response.first.keys).not_to include [:created_at, :updated_at]
      expect(json_response.first["status"]).to eq "pending_kitchen"
      expect(json_response.length).to eq 1
    end

    it 'vazio se restaurante não existe' do 
      user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
      restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                      cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                      city: "Ferraz de Vasconcelos", state: "SP",
                                      zip_code: "11111-111", owner: user,
                                      district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')

      get api_v1_restaurant_orders_path('lasjdnfkln')
      json_response = JSON.parse(response.body)

      expect(response).to have_http_status(404)
    end

    it 'retorna todos os pedidos se status não for especificado' do
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
      order_1 = Order.create!(restaurant: restaurant, customer_name: 'Derp', email: 'derp@email.com')
      order_1.offerings << offering
      order_1.preparing!
      order_2 = Order.create!(restaurant: restaurant, customer_name: 'Derpina', email: 'derpina@email.com')
      order_2.offerings << offering 
      order_2.pending_kitchen!

      get api_v1_restaurant_orders_path(restaurant.code)
      json_response = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(response.content_type).to include 'application/json'
      expect(json_response.first["status"]).to eq "preparing"
      expect(json_response.last["status"]).to eq "pending_kitchen"
      expect(json_response.length).to eq 2
    end

    it 'não recebe pedidos não finalizados' do
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
      order_1 = Order.create!(restaurant: restaurant, customer_name: 'Derp', email: 'derp@email.com')
      order_1.offerings << offering
      order_2 = Order.create!(restaurant: restaurant, customer_name: 'Derpina', email: 'derpina@email.com')
      order_2.offerings << offering 
      order_2.pending_kitchen!

      get api_v1_restaurant_orders_path(restaurant.code)
      json_response = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(response.content_type).to include 'application/json'
      expect(json_response.first["status"]).to eq "pending_kitchen"
      expect(json_response.length).to eq 1
    end
  end

  context 'GET /api/v1/orders/restaurant_code/order_id' do
    it 'sucesso' do
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
      order_1 = Order.create!(restaurant: restaurant, customer_name: 'Derp', email: 'derp@email.com')
      order_1.offerings << offering
      order_offering = order_1.order_offerings.build(offering: offering, quantity: 2, comment: "Sem cebola!")
      order_offering.save
      allow(SecureRandom).to receive(:alphanumeric).and_return("OXPDJZJ4")
      order_1.pending_kitchen!

      get api_v1_restaurant_order_path(restaurant.code, order_1.code)
      json_response = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(response.content_type).to include 'application/json'
      expect(json_response["customer_name"]).to eq 'Derp'
      expect(json_response["order_offerings"].class).to eq Array
      expect(json_response["customer_name"]).to eq "Derp"
      expect(json_response["status"]).to eq "pending_kitchen"
      expect(json_response["code"]).to eq "OXPDJZJ4"
      expect(json_response["order_offerings"][0]["offering"]["offerable"]["name"]).to eq "Hamburguer"
      expect(json_response["order_offerings"][0]["offering"]["description"]).to eq "médio"
      expect(json_response["order_offerings"][0]["comment"]).to be_nil
      expect(json_response["order_offerings"][0]["quantity"]).to eq 1
      expect(json_response["order_offerings"][1]["offering"]["offerable"]["name"]).to eq "Hamburguer"
      expect(json_response["order_offerings"][1]["offering"]["description"]).to eq "médio"
      expect(json_response["order_offerings"][1]["comment"]).to eq "Sem cebola!"
      expect(json_response["order_offerings"][1]["quantity"]).to eq 2
    end

    it 'falha se pedido com o código fornecido não existe' do
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
      order_1 = Order.create!(restaurant: restaurant, customer_name: 'Derp', email: 'derp@email.com')
      order_1.offerings << offering
      order_offering = order_1.order_offerings.build(offering: offering, quantity: 2, comment: "Sem cebola!")
      order_offering.save

      get api_v1_restaurant_order_path(restaurant.code, "OXPDJZJ4")

      expect(response).to have_http_status(404)
    end
  end
end