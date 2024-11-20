require 'rails_helper'

describe 'Usuário dono tenta registrar tag em um restaurante de outro usuário' do
  it 'a partir da tela de registro de uma bebida' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    other_user = User.create!(name: 'Zoroastro', email: 'zoroastro@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    Restaurant.create!(registered_name: "Churros LTDA", trade_name: "Churros",
                                    cnpj: CNPJ.generate, street_address: "Avenida dos Churros, 456",
                                    city: "Guarulhos", state: "SP",
                                    zip_code: "22222-222", owner: other_user,
                                    district: "Bairro dos Churros", email: 'churros@email.com', phone_number: '11933301050')

    login_as(other_user)
    post(restaurant_tags_path(restaurant, return_to: new_restaurant_beverage_path(restaurant)), params: { tag: { name: 'poisonous'} })
    
    expect(response).to redirect_to root_path
  end

  it 'a partir da tela de edição de uma bebida' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    other_user = User.create!(name: 'Zoroastro', email: 'zoroastro@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    Restaurant.create!(registered_name: "Churros LTDA", trade_name: "Churros",
                                    cnpj: CNPJ.generate, street_address: "Avenida dos Churros, 456",
                                    city: "Guarulhos", state: "SP",
                                    zip_code: "22222-222", owner: other_user,
                                    district: "Bairro dos Churros", email: 'churros@email.com', phone_number: '11933301050')
    beverage = Beverage.create!(restaurant: restaurant, name: 'Coca-cola', description: '2L', calories: 1200, alcoholic: :no)

    login_as(other_user)
    post(restaurant_tags_path(restaurant, return_to: edit_restaurant_beverage_path(restaurant, beverage)), params: { tag: { name: 'poisonous'} })
    
    expect(response).to redirect_to root_path
  end

  it 'a partir da tela de registro de um prato' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    other_user = User.create!(name: 'Zoroastro', email: 'zoroastro@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    Restaurant.create!(registered_name: "Churros LTDA", trade_name: "Churros",
                                    cnpj: CNPJ.generate, street_address: "Avenida dos Churros, 456",
                                    city: "Guarulhos", state: "SP",
                                    zip_code: "22222-222", owner: other_user,
                                    district: "Bairro dos Churros", email: 'churros@email.com', phone_number: '11933301050')

    login_as(other_user)
    post(restaurant_tags_path(restaurant, return_to: new_restaurant_dish_path(restaurant)), params: { tag: { name: 'poisonous'} })
    
    expect(response).to redirect_to root_path
  end

  it 'a partir da tela de edição de um prato' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    other_user = User.create!(name: 'Zoroastro', email: 'zoroastro@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    Restaurant.create!(registered_name: "Churros LTDA", trade_name: "Churros",
                                    cnpj: CNPJ.generate, street_address: "Avenida dos Churros, 456",
                                    city: "Guarulhos", state: "SP",
                                    zip_code: "22222-222", owner: other_user,
                                    district: "Bairro dos Churros", email: 'churros@email.com', phone_number: '11933301050')
    dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'pão, carne, queijo', calories: 1200)

    login_as(other_user)
    post(restaurant_tags_path(restaurant, return_to: edit_restaurant_dish_path(restaurant, dish)), params: { tag: { name: 'poisonous'} })
    
    expect(response).to redirect_to root_path
  end
end

describe 'Usuário funcionário tenta registrar tag em restaurante' do
  it 'a partir da tela de edição de um prato' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'pão, carne, queijo', calories: 1200)
    cpf = CPF.generate
    new_employee = NewEmployee.create!(email: 'gertrudes@email.com', cpf: cpf, restaurant: restaurant)
    employee = User.create!(email: 'gertrudes@email.com', cpf: cpf, name: 'Gertrudes', password: 'asdfqwerasdfasdfpo')

    login_as(employee)
    post(restaurant_tags_path(restaurant, return_to: edit_restaurant_dish_path(restaurant, dish)), params: { tag: { name: 'poisonous'} })
    expect(response).to redirect_to root_path
  end
end