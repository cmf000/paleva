require 'rails_helper'

describe "Order API" do
  context 'GET /api/v1/restaurants/restaurant_code/orders' do
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
      order_1.pending_kitchen!
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

    it 'vazio se não há pedidos finalizados' do
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

      get api_v1_restaurant_orders_path(restaurant.code)

      expect(response).to have_http_status(204)
      expect(response.body).to be_empty 
    end
  end

  context 'GET /api/v1/restaurants/restaurant_code/orders/order_id' do
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
      expect(json_response["items"].class).to eq Array
      expect(json_response["status"]).to eq "pending_kitchen"
      expect(json_response["code"]).to eq "OXPDJZJ4"
      expect(json_response["items"][0]["item_name"]).to eq "Hamburguer"
      expect(json_response["items"][0]["offering_description"]).to eq "médio"
      expect(json_response["items"][0]["comment"]).to be_nil
      expect(json_response["items"][0]["quantity"]).to eq 1
      expect(json_response["items"][1]["item_name"]).to eq "Hamburguer"
      expect(json_response["items"][1]["offering_description"]).to eq "médio"
      expect(json_response["items"][1]["comment"]).to eq "Sem cebola!"
      expect(json_response["items"][1]["quantity"]).to eq 2
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

    it 'falha se pedido não pertence a restaurante' do 
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
      other_user = User.create!(name: 'Zoroastro', email: 'zoroastro@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
      allow(SecureRandom).to receive(:alphanumeric).and_return("BCD456")
      other_restaurant = Restaurant.create!(registered_name: "churros LTDA", trade_name: "churros",
                                      cnpj: CNPJ.generate, street_address: "Avenida dos Churros, 456",
                                      city: "Guarulhos", state: "SP",
                                      zip_code: "22222-222", owner: other_user,
                                      district: "Churros", email: 'churros@email.com', phone_number: '11933301080')

      get api_v1_restaurant_order_path(other_restaurant.code, "OXPDJZJ4")

      expect(response).to have_http_status 404
    end
  end

  context '/api/v1/restaurants/:restaurant_code/orders/:code/preparing' do
    it 'sucesso' do 
      user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
      allow(SecureRandom).to receive(:alphanumeric).and_return("ABC123")
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
      allow(SecureRandom).to receive(:alphanumeric).and_return("OXPDJZJ4")
      order_1.pending_kitchen!

      patch "/api/v1/restaurants/ABC123/orders/OXPDJZJ4/preparing"

      expect(response).to have_http_status 200
      order_1.reload
      expect(order_1).to be_preparing
    end

    it 'falha se pedido não tiver status de aguardando confirmação da cozinha' do 
      user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
      allow(SecureRandom).to receive(:alphanumeric).and_return("ABC123")
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
      allow(SecureRandom).to receive(:alphanumeric).and_return("OXPDJZJ4")
      order_1.pending_kitchen!
      order_1.preparing!
      order_1.ready!

      patch "/api/v1/restaurants/ABC123/orders/OXPDJZJ4/preparing"

      order_1.reload
      expect(response).to have_http_status 400
      expect(order_1).to be_ready
      json_response = JSON.parse(response.body)
      expect(json_response["errors"]["status"].first).to include 'não pode mudar'
    end
  end

  context '/api/v1/restaurants/:restaurant_code/orders/:code/ready' do
    it 'sucesso' do 
      user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
      allow(SecureRandom).to receive(:alphanumeric).and_return("ABC123")
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
      allow(SecureRandom).to receive(:alphanumeric).and_return("OXPDJZJ4")
      order_1.pending_kitchen!
      order_1.preparing!

      patch "/api/v1/restaurants/ABC123/orders/OXPDJZJ4/ready"

      expect(response).to have_http_status 200
      order_1.reload
      expect(order_1).to be_ready
    end

    it 'falha se pedido não tiver status de em preparo' do
      user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
      allow(SecureRandom).to receive(:alphanumeric).and_return("ABC123")
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
      allow(SecureRandom).to receive(:alphanumeric).and_return("OXPDJZJ4")
      order_1.pending_kitchen!

      patch "/api/v1/restaurants/ABC123/orders/OXPDJZJ4/ready"

      expect(response).to have_http_status(400)
      json_response = JSON.parse(response.body)
      expect(json_response["errors"]["status"].first).to include 'não pode mudar'
    end
  end

  context '/api/v1/restaurants/:restaurant_code/orders/:code/cancelled' do
    it 'sucesso' do 
      user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
      allow(SecureRandom).to receive(:alphanumeric).and_return("ABC123")
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
      allow(SecureRandom).to receive(:alphanumeric).and_return("OXPDJZJ4")
      order_1.pending_kitchen!

      patch cancelled_api_v1_restaurant_order_path(restaurant.code, order_1.code), params: { order: { cancellation_note: 'Acabou o queijo' } }

      expect(response).to have_http_status 200
      order_1.reload
      expect(order_1).to be_cancelled
    end

    it 'falha se motivo não tiver sido informado' do 
      user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
      allow(SecureRandom).to receive(:alphanumeric).and_return("ABC123")
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
      allow(SecureRandom).to receive(:alphanumeric).and_return("OXPDJZJ4")
      order_1.pending_kitchen!

      patch cancelled_api_v1_restaurant_order_path(restaurant.code, order_1.code)

      expect(response).to have_http_status 400
      expect(order_1).to be_pending_kitchen
    end
  end
end