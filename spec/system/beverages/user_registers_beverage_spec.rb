require 'rails_helper'

describe 'Usuário cadastra uma nova bebida' do
  it 'a partir da página inicial' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                       cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                       city: "Ferraz de Vasconcelos", state: "SP",
                       zip_code: "11111-111", owner: user,
                       district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    Tag.create!(restaurant: restaurant, name: :vegan)

    login_as(user)
    visit root_path
    click_on "Quitutes Picantes"
    click_on 'Cadastrar nova bebida'

    expect(page).to have_content 'Nome'
    expect(page).to have_content 'Descrição'
    expect(page).to have_content 'Calorias'
    expect(page).to have_content 'Descrição'
    expect(page).to have_content 'Alcoólica'
    expect(page).to have_content 'Imagem'
    expect(page).to have_content 'Vegano'
    expect(page).to have_button 'Criar Bebida'
  end

  it 'e volta à página inicial' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                       cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                       city: "Ferraz de Vasconcelos", state: "SP",
                       zip_code: "11111-111", owner: user,
                       district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    Tag.create!(restaurant: restaurant, name: :vegan)

    login_as(user)
    visit root_path
    click_on "Quitutes Picantes"
    click_on 'Cadastrar nova bebida'
    click_on 'Paleva'

    expect(current_path).to eq restaurants_path
  end

  it 'e volta à página do restaurante' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                       cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                       city: "Ferraz de Vasconcelos", state: "SP",
                       zip_code: "11111-111", owner: user,
                       district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')

    login_as(user)
    visit root_path
    click_on "Quitutes Picantes"
    click_on 'Cadastrar nova bebida'
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
    tag = Tag.create!(restaurant: restaurant, name: :vegan)

    login_as(user)
    visit root_path
    click_on "Quitutes Picantes"
    click_on 'Cadastrar nova bebida'
    fill_in 'Nome', with: 'Coca-cola'
    fill_in 'Descrição', with: '2L'
    fill_in 'Calorias', with: '1200'
    choose 'beverage_alcoholic_no'
    check "#{dom_id(tag)}"
    click_on 'Criar Bebida'

    expect(page).to have_content 'Bebida criada com sucesso'
    expect(restaurant.beverages.last.tags.last.name).to eq "vegan"
    expect(restaurant.beverages.last.name).to eq "Coca-cola"
    expect(restaurant.beverages.last.description).to eq "2L"
    expect(restaurant.beverages.last).to be_no
  end

  it 'com dados incompletos' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                       cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                       city: "Ferraz de Vasconcelos", state: "SP",
                       zip_code: "11111-111", owner: user,
                       district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    
    login_as(user)
    visit root_path
    click_on "Quitutes Picantes"
    click_on 'Cadastrar nova bebida'
    fill_in 'Nome', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Calorias', with: ''
    click_on 'Criar Bebida'

    expect(page).to have_content 'Bebida não cadastrada'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Descrição não pode ficar em branco'
    expect(page).to have_content 'Alcoólica deve ser sim/não'
  end

  it 'com calorias negativas' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                       cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                       city: "Ferraz de Vasconcelos", state: "SP",
                       zip_code: "11111-111", owner: user,
                       district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    
    login_as(user)
    visit root_path
    click_on "Quitutes Picantes"
    click_on 'Cadastrar nova bebida'
    fill_in 'Nome', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Calorias', with: '-1000'
    click_on 'Criar Bebida'

    expect(page).to have_content 'Bebida não cadastrada'
    expect(page).to have_content 'Calorias deve ser maior ou igual a 0'
  end

  it 'e só pode cadastrar pratos no seu restaurante' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                       cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                       city: "Ferraz de Vasconcelos", state: "SP",
                       zip_code: "11111-111", owner: user,
                       district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    beverage = Beverage.create!(restaurant: restaurant, name: 'Coca-cola', description: '2L', calories: 1200, alcoholic: :no)
    other_user = User.create!(name: 'Zoroastro', email: 'zoroastro@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    Restaurant.create!(registered_name: "Sabores do Brasil LTDA", trade_name: "Sabores do Brasil",
                                          cnpj: CNPJ.generate, street_address: "Rua das Palmeiras, 123", district: 'Santana',
                                          city: "São Paulo", state: "SP", zip_code: "01000-000", owner: other_user,
                                          email: 'saboresdobrasil@email.com', phone_number: '11933301020')
    
                                        
    login_as(other_user)
    visit new_restaurant_beverage_path(restaurant.id, beverage.id)

    expect(current_path).to eq restaurants_path
  end

  it 'e não vê marcações de outro restaurante' do
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
    click_on 'Cadastrar nova bebida'

    expect(page).to have_field(dom_id(tag))
    expect(page).not_to have_field(dom_id(other_restaurant_tag))
  end
end