require 'rails_helper'

describe 'Usuário visita página do seu restaurante' do 
  it 'e vê os horários de funcionamento' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                city: "Ferraz de Vasconcelos", state: "SP",
                                zip_code: "11111-111", user: user,
                                district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    time = Time.zone.local(1000, 1, 1, 17, 0, 0)
    Shift.create!(weekday: :sunday, restaurant: restaurant, opening_time: time, closing_time: time + 3.hours)
    other_user = User.create!(name: 'Zoroastro', email: 'zoroastro@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    Restaurant.create!(registered_name: "Sabores do Brasil LTDA", trade_name: "Sabores do Brasil",
                       cnpj: CNPJ.generate, street_address: "Rua das Palmeiras, 123", district: 'Santana',
                       city: "São Paulo", state: "SP", zip_code: "01000-000", user: other_user,
                       email: 'saboresdobrasil@email.com', phone_number: '11933301020')
    
    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'

    expect(current_path).to eq restaurant_path(restaurant.id)
    within('#sunday') do
      expect(page).to have_content('17:00 às 20:00')
    end
    within('#monday') do
      expect(page).to have_content('fechado')
    end
    expect(page).to have_content 'Não há bebidas cadastradas'
    expect(page).to have_content 'Não há pratos cadastrados'
  end

  it 'e volta à página inicial' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                       cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                       city: "Ferraz de Vasconcelos", state: "SP",
                       zip_code: "11111-111", user: user,
                       district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    
    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    within('nav') do
      click_on 'Paleva'
    end

    expect(current_path).to eq restaurants_path
  end

  it 'e vê pratos cadastrados' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                       cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                       city: "Ferraz de Vasconcelos", state: "SP",
                       zip_code: "11111-111", user: user,
                       district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'carne, queijo, mostarda', calories: 1200)

    login_as(user)
    visit restaurant_path(user.restaurant)

    expect(page).to have_content 'Hamburguer'
    expect(page).to have_content 'carne, queijo, mostarda'
    expect(page).to have_content '1200 kcal'
  end

  it 'e vê a opção para editar os pratos' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                       cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                       city: "Ferraz de Vasconcelos", state: "SP",
                       zip_code: "11111-111", user: user,
                       district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'carne, queijo, mostarda', calories: 1200)

    login_as(user)
    visit restaurant_path(user.restaurant)

    within('#Hamburguer') do
      expect(page).to have_content 'Editar'
    end
  end
end

describe 'Usuário visita página do restaurante de outro usuário' do 
  it 'a vê os horários de funcionamento' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                city: "Ferraz de Vasconcelos", state: "SP",
                                zip_code: "11111-111", user: user,
                                district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    other_user = User.create!(name: 'Zoroastro', email: 'zoroastro@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    other_restaurant = Restaurant.create!(registered_name: "Sabores do Brasil LTDA", trade_name: "Sabores do Brasil",
                       cnpj: CNPJ.generate, street_address: "Rua das Palmeiras, 123", district: 'Santana',
                       city: "São Paulo", state: "SP", zip_code: "01000-000", user: other_user,
                       email: 'saboresdobrasil@email.com', phone_number: '11933301020')
    time = Time.zone.local(1000, 1, 1, 17, 0, 0)
    Shift.create!(weekday: :sunday, restaurant: other_restaurant, opening_time: time, closing_time: time + 3.hours)
    
    login_as(user)
    visit root_path
    click_on 'Sabores do Brasil'

    expect(current_path).to eq restaurant_path(other_restaurant.id)
    within('#sunday') do
      expect(page).to have_content('17:00 às 20:00')
    end
    within('#monday') do
      expect(page).to have_content('fechado')
    end
    expect(page).to have_content 'Não há bebidas cadastradas'
    expect(page).to have_content 'Não há pratos cadastrados'
  end

  it 'e volta à página inicial' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                       cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                       city: "Ferraz de Vasconcelos", state: "SP",
                       zip_code: "11111-111", user: user,
                       district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    other_user = User.create!(name: 'Zoroastro', email: 'zoroastro@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    Restaurant.create!(registered_name: "Sabores do Brasil LTDA", trade_name: "Sabores do Brasil",
                       cnpj: CNPJ.generate, street_address: "Rua das Palmeiras, 123", district: 'Santana',
                       city: "São Paulo", state: "SP", zip_code: "01000-000", user: other_user,
                       email: 'saboresdobrasil@email.com', phone_number: '11933301020')
    
    login_as(user)
    visit root_path
    click_on 'Sabores do Brasil'
    within('nav') do
      click_on 'Paleva'
    end

    expect(current_path).to eq restaurants_path
  end

  it 'e vê pratos cadastrados' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                       cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                       city: "Ferraz de Vasconcelos", state: "SP",
                       zip_code: "11111-111", user: user,
                       district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    other_user = User.create!(name: 'Zoroastro', email: 'zoroastro@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    other_restaurant = Restaurant.create!(registered_name: "Sabores do Brasil LTDA", trade_name: "Sabores do Brasil",
                                          cnpj: CNPJ.generate, street_address: "Rua das Palmeiras, 123", district: 'Santana',
                                          city: "São Paulo", state: "SP", zip_code: "01000-000", user: other_user,
                                          email: 'saboresdobrasil@email.com', phone_number: '11933301020')
    Dish.create!(restaurant: other_restaurant, name: 'Hamburguer', description: 'carne, queijo, mostarda', calories: 1200)

    login_as(user)
    visit restaurant_path(other_user.restaurant)

    expect(page).to have_content 'Hamburguer'
    expect(page).to have_content 'carne, queijo, mostarda'
    expect(page).to have_content '1200 kcal'
  end

  it 'e não vê a opção para editar os pratos' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                       cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                       city: "Ferraz de Vasconcelos", state: "SP",
                       zip_code: "11111-111", user: user,
                       district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    other_user = User.create!(name: 'Zoroastro', email: 'zoroastro@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    other_restaurant = Restaurant.create!(registered_name: "Sabores do Brasil LTDA", trade_name: "Sabores do Brasil",
                                          cnpj: CNPJ.generate, street_address: "Rua das Palmeiras, 123", district: 'Santana',
                                          city: "São Paulo", state: "SP", zip_code: "01000-000", user: other_user,
                                          email: 'saboresdobrasil@email.com', phone_number: '11933301020')
    Dish.create!(restaurant: other_restaurant, name: 'Hamburguer', description: 'carne, queijo, mostarda', calories: 1200)

    login_as(user)
    visit restaurant_path(other_user.restaurant.id)

    within('#Hamburguer') do
      expect(page).not_to have_content 'Editar'
    end
  end

  it 'e não vê a opção para cadastrar pratos' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                       cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                       city: "Ferraz de Vasconcelos", state: "SP",
                       zip_code: "11111-111", user: user,
                       district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    other_user = User.create!(name: 'Zoroastro', email: 'zoroastro@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    other_restaurant = Restaurant.create!(registered_name: "Sabores do Brasil LTDA", trade_name: "Sabores do Brasil",
                                          cnpj: CNPJ.generate, street_address: "Rua das Palmeiras, 123", district: 'Santana',
                                          city: "São Paulo", state: "SP", zip_code: "01000-000", user: other_user,
                                          email: 'saboresdobrasil@email.com', phone_number: '11933301020')
    Dish.create!(restaurant: other_restaurant, name: 'Hamburguer', description: 'carne, queijo, mostarda', calories: 1200)

    login_as(user)
    visit restaurant_path(other_user.restaurant.id)

    expect(page).not_to have_content 'Cadastrar novo prato'
    end
end