require 'rails_helper'

describe 'Usuário edita um prato' do
  it 'a partir da página inicial' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'carne, queijo, mostarda', calories: 1200)

    login_as(user)
    visit root_path
    click_on "Quitutes Picantes"
    within("##{dom_id(dish)}-card") do
      click_on 'Editar'
    end

    expect(page).to have_field(id: 'dish_name')
    expect(page).to have_field(id: 'dish_description')
    expect(page).to have_field(id: 'dish_calories')
    expect(page).to have_field(id: 'dish_image')
    expect(page).to have_button("Atualizar Prato")
  end

  it 'e volta à página inicial' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'carne, queijo, mostarda', calories: 1200)

    login_as(user)
    visit root_path
    click_on "Quitutes Picantes"
    within("##{dom_id(dish)}-card") do
      click_on 'Editar'
    end
    click_on "Paleva"

    expect(current_path).to eq restaurants_path

  end

  it 'e volta à página do restaurante' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'carne, queijo, mostarda', calories: 1200)

    login_as(user)
    visit root_path
    click_on "Quitutes Picantes"
    within("##{dom_id(dish)}-card") do
      click_on 'Editar'
    end
    click_on "Quitutes Picantes"

    expect(current_path).to eq restaurant_path(restaurant.id)

  end

  it 'com sucesso' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'carne, queijo, mostarda', calories: 1200)

    login_as(user)
    visit root_path
    click_on "Quitutes Picantes"
    within("##{dom_id(dish)}-card") do
      click_on 'Editar'
    end
    fill_in 'Nome', with: 'Hamburguer Grande'
    click_on 'Atualizar Prato'
    dish.reload

    expect(page).to have_content 'Prato editado com sucesso'
    expect(dish.name).to eq 'Hamburguer Grande' 
  end

  it 'com dados incompletos' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                       cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                       city: "Ferraz de Vasconcelos", state: "SP",
                       zip_code: "11111-111", owner: user,
                       district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'carne, queijo, mostarda', calories: 1200)

    login_as(user)
    visit root_path
    click_on "Quitutes Picantes"
    within("##{dom_id(dish)}-card") do
      click_on 'Editar'
    end
    fill_in 'Nome', with: 'Hamburguer Grande'
    fill_in 'Descrição', with: ""
    click_on 'Atualizar Prato'

    expect(page).to have_content 'Prato não editado'
  end

  it 'com calorias negativas' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                       cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                       city: "Ferraz de Vasconcelos", state: "SP",
                       zip_code: "11111-111", owner: user,
                       district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'carne, queijo, mostarda', calories: 1200)

    login_as(user)
    visit root_path
    click_on "Quitutes Picantes"
    within("##{dom_id(dish)}-card") do
      click_on 'Editar'
    end
    fill_in 'Nome', with: 'Hamburguer Grande'
    fill_in 'Calorias', with: "-1000"
    click_on 'Atualizar Prato'

    expect(page).to have_content 'Prato não editado'
  end

  it 'e não pode editar outro restaurante' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                       cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                       city: "Ferraz de Vasconcelos", state: "SP",
                       zip_code: "11111-111", owner: user,
                       district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'carne, queijo, mostarda', calories: 1200)
    other_user = User.create!(name: 'Zoroastro', email: 'zoroastro@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    Restaurant.create!(registered_name: "Sabores do Brasil LTDA", trade_name: "Sabores do Brasil",
                                          cnpj: CNPJ.generate, street_address: "Rua das Palmeiras, 123", district: 'Santana',
                                          city: "São Paulo", state: "SP", zip_code: "01000-000", owner: other_user,
                                          email: 'saboresdobrasil@email.com', phone_number: '11933301020')
  
    login_as(other_user)
    visit edit_restaurant_dish_path(restaurant.id, dish.id)

    expect(current_path).to eq restaurants_path
  end

  it 'e retorna à página de seu restaurante' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                       cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                       city: "Ferraz de Vasconcelos", state: "SP",
                       zip_code: "11111-111", owner: user,
                       district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'carne, queijo, mostarda', calories: 1200)

    login_as(user)
    visit edit_restaurant_dish_path(restaurant.id, dish.id)
    click_on 'Quitutes Picantes'

    expect(current_path).to eq restaurant_path(restaurant.id)
  end

  it 'e seleciona marcações para um prato' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'carne, queijo, mostarda', calories: 1200)
    tag = Tag.create!(restaurant: restaurant, name: :vegan)
    other_tag = Tag.create!(restaurant: restaurant, name: :gluten_free)

    login_as(user)
    visit root_path
    click_on "Quitutes Picantes"
    within("##{dom_id(dish)}-card") do
      click_on 'Editar'
    end
    fill_in 'Nome', with: 'Hamburguer Grande'
    check "#{dom_id(tag)}"
    check "#{dom_id(other_tag)}"
    click_on 'Atualizar Prato'
    dish.reload

    expect(page).to have_content 'Prato editado com sucesso'
    expect(dish.name).to eq 'Hamburguer Grande'
    expect(dish.tags.first.name).to eq 'vegan'
    expect(dish.tags.last.name).to eq 'gluten_free'
  end

  it 'e remove marcações para um prato' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'carne, queijo, mostarda', calories: 1200)
    tag = Tag.create!(restaurant:restaurant, name: :vegan)
    other_tag = Tag.create!(restaurant: restaurant, name: :gluten_free)
    dish.tags << tag
    dish.tags << other_tag

    login_as(user)
    visit root_path
    click_on "Quitutes Picantes"
    within("##{dom_id(dish)}-card") do
      click_on 'Editar'
    end
    fill_in 'Nome', with: 'Hamburguer Grande'
    uncheck "#{dom_id(tag)}"
    uncheck "#{dom_id(other_tag)}"
    click_on 'Atualizar Prato'
    dish.reload

    expect(page).to have_content 'Prato editado com sucesso'
    expect(dish.name).to eq 'Hamburguer Grande'
    expect(dish.tags).to be_empty
  end

  it 'e não vê marcações de outro restaurante' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'carne, queijo, mostarda', calories: 1200)
    tag = Tag.create!(restaurant:restaurant, name: :vegan)
    other_user = User.create!(name: 'Zoroastro', email: 'zoroastro@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    other_restaurant = Restaurant.create!(registered_name: "Sabores do Brasil LTDA", trade_name: "Sabores do Brasil",
                                          cnpj: CNPJ.generate, street_address: "Rua das Palmeiras, 123", district: 'Santana',
                                          city: "São Paulo", state: "SP", zip_code: "01000-000", owner: other_user,
                                          email: 'saboresdobrasil@email.com', phone_number: '11933301020')
    other_restaurant_tag = Tag.create!(restaurant: other_restaurant, name: :gluten_free)

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    within("##{dom_id(dish)}-card") do
      click_on 'Editar'
    end

    expect(page).to have_field(dom_id(tag), type: :checkbox)
    expect(page).not_to have_field(dom_id(other_restaurant_tag), type: :checkbox)
  end
end