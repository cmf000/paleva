require 'rails_helper'

describe 'Usuário edita uma bebida' do
  it 'a partir da página inicial' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    beverage = Beverage.create!(restaurant: restaurant, name: 'Coca-cola', description: 'delicioso tônico', calories: 1200, alcoholic: :no)

    login_as(user)
    visit root_path
    click_on "Quitutes Picantes"
    within("##{dom_id(beverage)}-card") do
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
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    beverage = Beverage.create!(restaurant: restaurant, name: 'Coca-cola', description: 'delicioso tônico', calories: 1200, alcoholic: :no)

    login_as(user)
    visit root_path
    click_on "Quitutes Picantes"
    within("##{dom_id(beverage)}-card") do
      click_on 'Editar'
    end
    click_on 'Quitutes Picantes'

    expect(current_path).to eq restaurant_path(restaurant.id)

  end

  it 'com sucesso' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    beverage = Beverage.create!(restaurant: restaurant, name: 'Coca-cola', description: '2L', calories: 1200, alcoholic: :no)

    login_as(user)
    visit root_path
    click_on "Quitutes Picantes"
    within("##{dom_id(beverage)}-card") do
      click_on 'Editar'
    end
    choose 'beverage_alcoholic_yes'
    click_on 'Atualizar Bebida'
    beverage.reload

    expect(page).to have_content 'Bebida editada com sucesso'
    expect(beverage.alcoholic).to eq "yes"
  end

  it 'com dados incompletos' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                       cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                       city: "Ferraz de Vasconcelos", state: "SP",
                       zip_code: "11111-111", owner: user,
                       district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    beverage = Beverage.create!(restaurant: restaurant, name: 'Coca-cola', description: '2L', calories: 1200, alcoholic: :no)

    login_as(user)
    visit root_path
    click_on "Quitutes Picantes"
    within("##{dom_id(beverage)}-card") do
      click_on 'Editar'
    end
    fill_in 'Nome', with: ''
    fill_in 'Descrição', with: ""
    click_on 'Atualizar Bebida'

    expect(page).to have_content 'Bebida não editada'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Descrição não pode ficar em branco'
  end

  it 'com calorias negativas' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                       cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                       city: "Ferraz de Vasconcelos", state: "SP",
                       zip_code: "11111-111", owner: user,
                       district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'carne, queijo, mostarda', calories: 1200)

    beverage = Beverage.create!(restaurant: restaurant, name: 'Coca-cola', description: '2L', calories: 1200, alcoholic: :no)

    login_as(user)
    visit root_path
    click_on "Quitutes Picantes"
    within("##{dom_id(beverage)}-card") do
      click_on 'Editar'
    end
    fill_in 'Calorias', with: "-1000"
    click_on 'Atualizar Bebida'

    expect(page).to have_content 'Bebida não editada'
    expect(page).to have_content 'Calorias deve ser maior ou igual a 0'
  end

  it 'e não pode editar outro restaurante' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                       cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                       city: "Ferraz de Vasconcelos", state: "SP",
                       zip_code: "11111-111", owner: user,
                       district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    other_user = User.create!(name: 'Zoroastro', email: 'zoroastro@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    Restaurant.create!(registered_name: "Sabores do Brasil LTDA", trade_name: "Sabores do Brasil",
                                          cnpj: CNPJ.generate, street_address: "Rua das Palmeiras, 123", district: 'Santana',
                                          city: "São Paulo", state: "SP", zip_code: "01000-000", owner: other_user,
                                          email: 'saboresdobrasil@email.com', phone_number: '11933301020')
    beverage = Beverage.create!(restaurant: restaurant, name: 'Coca-cola', description: '2L', calories: 1200, alcoholic: :no)


    login_as(other_user)
    visit edit_restaurant_beverage_path(restaurant.id, beverage.id)

    expect(current_path).to eq restaurants_path
  end

  it 'e escolhe marcações' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    beverage = Beverage.create!(restaurant: restaurant, name: 'Coca-cola', description: '2L', calories: 1200, alcoholic: :no)
    tag = Tag.create!(restaurant: restaurant, name: :vegan)
    other_tag = Tag.create!(restaurant: restaurant, name: :gluten_free)

    login_as(user)
    visit root_path
    click_on "Quitutes Picantes"
    within("##{dom_id(beverage)}-card") do
      click_on 'Editar'
    end
    check "#{dom_id(tag)}"
    check "#{dom_id(other_tag)}"
    choose 'beverage_alcoholic_yes'
    click_on 'Atualizar Bebida'
    beverage.reload

    expect(page).to have_content 'Bebida editada com sucesso'
    expect(beverage.alcoholic).to eq "yes"
    expect(beverage.tags.first.name).to eq 'vegan'
    expect(beverage.tags.last.name).to eq 'gluten_free'
  end

  it 'e remove marcações' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    beverage = Beverage.create!(restaurant: restaurant, name: 'Coca-cola', description: '2L', calories: 1200, alcoholic: :no)
    tag = Tag.create!(restaurant: restaurant, name: :vegan)
    beverage.tags << tag
    other_tag = Tag.create!(restaurant: restaurant, name: :gluten_free)

    login_as(user)
    visit root_path
    click_on "Quitutes Picantes"
    within("##{dom_id(beverage)}-card") do
      click_on 'Editar'
    end
    uncheck "#{dom_id(tag)}"
    check "#{dom_id(other_tag)}"
    choose 'beverage_alcoholic_yes'
    click_on 'Atualizar Bebida'
    beverage.reload

    expect(page).to have_content 'Bebida editada com sucesso'
    expect(beverage.alcoholic).to eq "yes"
    expect(beverage.tags.first.name).to eq 'gluten_free'
  end

  it 'e remove todas as marcações' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    beverage = Beverage.create!(restaurant: restaurant, name: 'Coca-cola', description: '2L', calories: 1200, alcoholic: :no)
    tag = Tag.create!(restaurant: restaurant, name: :vegan)
    beverage.tags << tag
    other_tag = Tag.create!(restaurant: restaurant, name: :gluten_free)

    login_as(user)
    visit root_path
    click_on "Quitutes Picantes"
    within("##{dom_id(beverage)}-card") do
      click_on 'Editar'
    end
    uncheck "#{dom_id(tag)}"
    uncheck "#{dom_id(other_tag)}"
    choose 'beverage_alcoholic_yes'
    click_on 'Atualizar Bebida'
    beverage.reload

    expect(page).to have_content 'Bebida editada com sucesso'
    expect(beverage.alcoholic).to eq "yes"
    expect(beverage.tags).to be_empty
  end

  it 'e não vê marcações de outros restaurantes' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    beverage = Beverage.create!(restaurant: restaurant, name: 'Coca-cola', description: '2L', calories: 1200, alcoholic: :no)
    tag = Tag.create!(restaurant: restaurant, name: :vegan)
    other_user = User.create!(name: 'Zoroastro', email: 'zoroastro@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    other_restaurant = Restaurant.create!(registered_name: "Sabores do Brasil LTDA", trade_name: "Sabores do Brasil",
                                          cnpj: CNPJ.generate, street_address: "Rua das Palmeiras, 123", district: 'Santana',
                                          city: "São Paulo", state: "SP", zip_code: "01000-000", owner: other_user,
                                          email: 'saboresdobrasil@email.com', phone_number: '11933301020')
    other_restaurant_tag = Tag.create!(restaurant: other_restaurant, name: :gluten_free)

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    within("##{dom_id(beverage)}-card") do
      click_on 'Editar'
    end

    expect(page).to have_field(dom_id(tag))
    expect(page).not_to have_field(dom_id(other_restaurant_tag))
  end
  
end