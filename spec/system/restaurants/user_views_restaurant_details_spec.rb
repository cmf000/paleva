require 'rails_helper'

describe 'Usuário dono visita página do seu restaurante' do 
  it 'e vê os horários de funcionamento' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                city: "Ferraz de Vasconcelos", state: "SP",
                                zip_code: "11111-111", owner: user,
                                district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    time = Time.zone.local(1000, 1, 1, 17, 0, 0)
    Shift.create!(weekday: :sunday, restaurant: restaurant, opening_time: time, closing_time: time + 3.hours)
    other_user = User.create!(name: 'Zoroastro', email: 'zoroastro@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    Restaurant.create!(registered_name: "Sabores do Brasil LTDA", trade_name: "Sabores do Brasil",
                       cnpj: CNPJ.generate, street_address: "Rua das Palmeiras, 123", district: 'Santana',
                       city: "São Paulo", state: "SP", zip_code: "01000-000", owner: other_user,
                       email: 'saboresdobrasil@email.com', phone_number: '11933301020')
    
    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'

    within("##{dom_id restaurant}-address") do
      expect(page).to have_content 'Avenida Quente, 456'
      expect(page).to have_content 'Pimentas'
      expect(page).to have_content 'Ferraz de Vasconcelos - SP'
      expect(page).to have_content '11111-111'
    end
    within("##{dom_id restaurant}-contact") do
      expect(page).to have_content '11933301030'
    end
    expect(current_path).to eq restaurant_path(restaurant.id)
    expect(page).to have_content 'Não há bebidas cadastradas'
    expect(page).to have_content 'Não há pratos cadastrados'
  end

  it 'e volta à página inicial' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                       cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                       city: "Ferraz de Vasconcelos", state: "SP",
                       zip_code: "11111-111", owner: user,
                       district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    
    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    within('nav') do
      click_on 'Paleva'
    end

    expect(current_path).to eq restaurants_path
  end

  it 'e vê pratos e bebidas cadastrados' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                       cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                       city: "Ferraz de Vasconcelos", state: "SP",
                       zip_code: "11111-111", owner: user,
                       district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    tag = Tag.create!(restaurant: restaurant, name: :vegan)
    other_tag = Tag.create!(restaurant: restaurant, name: :gluten_free)
    dish_1 = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'carne, queijo, mostarda', calories: 1200)
    dish_1.tags << tag
    dish_2 = Dish.create!(restaurant: restaurant, name: 'Cachorro quente', description: 'salsicha, pão, molhos', calories: 1200, status: :inactive)
    beverage_1 = Beverage.create!(restaurant: restaurant, name: 'Coca-cola', description: 'Delicioso tônico', calories: 1200, alcoholic: :no, status: :inactive)
    beverage_1.tags << tag
    beverage_1.tags << other_tag
    beverage_2 = Beverage.create!(restaurant: restaurant, name: 'Fanta', description: 'Bebida natural sabor laranja', calories: 1200, alcoholic: :no)
    beverage_2.tags << tag
    beverage_3 = Beverage.create!(restaurant: restaurant, name: 'Cerveja', description: 'Bebida fermentada de cerais maltados', calories: 1200, alcoholic: :yes, status: :inactive)

    login_as(user)
    visit restaurant_path(user.owned_restaurant)

    within("##{dom_id(dish_1)}-card") do
      expect(page).to have_content 'Hamburguer'
      expect(page).to have_content 'carne, queijo, mostarda'
      expect(page).to have_content '1200 kcal'
      expect(page).to have_content 'Ativo'
      expect(page).to have_content 'Vegano'
    end

    within("##{dom_id(dish_2)}-card") do
      expect(page).to have_content 'Cachorro quente'
      expect(page).to have_content 'salsicha, pão, molhos'
      expect(page).to have_content '1200 kcal'
      expect(page).to have_content 'Inativo'
    end

    within("##{dom_id(beverage_1)}-card") do
      expect(page).to have_content 'Coca-cola'
      expect(page).to have_content 'Delicioso tônico'
      expect(page).to have_content '1200 kcal'
      expect(page).to have_content 'Não-alcoólica'
      expect(page).to have_content 'Inativo'
      expect(page).to have_content 'Vegano'
      expect(page).to have_content 'Sem glútem'
    end

    within("##{dom_id(beverage_2)}-card") do
      expect(page).to have_content 'Fanta'
      expect(page).to have_content 'Bebida natural sabor laranja'
      expect(page).to have_content '1200 kcal'
      expect(page).to have_content 'Não-alcoólica'
      expect(page).to have_content 'Ativo'
    end

    within("##{dom_id(beverage_3)}-card") do
      expect(page).to have_content 'Cerveja'
      expect(page).to have_content 'Bebida fermentada de cerais maltados'
      expect(page).to have_content '1200 kcal'
      expect(page).to have_content 'Alcoólica'
      expect(page).to have_content 'Inativo'
    end
  end

  it 'e vê a opção para editar pratos e bebidas' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                       cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                       city: "Ferraz de Vasconcelos", state: "SP",
                       zip_code: "11111-111", owner: user,
                       district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'carne, queijo, mostarda', calories: 1200)
    beverage = Beverage.create!(restaurant: restaurant, name: 'Coca-cola', description: 'Delicioso tônico', calories: 1200, alcoholic: :no)

    login_as(user)
    visit restaurant_path(user.owned_restaurant)

    within("##{dom_id(dish)}-card") do
      expect(page).to have_content 'Editar'
    end

    within("##{dom_id(beverage)}-card") do
      expect(page).to have_content 'Editar'
    end
  end

  it 'e vê os menus cadastrados' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    dish_1 = Dish.create!(restaurant: restaurant, name: 'Pão de queijo', description: 'quitute de polvilho com queijo', calories: 1200)
    dish_2 = Dish.create!(restaurant: restaurant, name: 'Misto quente', description: 'pão de forma, presunto, queijo', calories: 1200)
    beverage_1 = Beverage.create!(restaurant: restaurant, name: 'Café expresso', description: 'Extraído de grãos 100% arábica', calories: 1200, alcoholic: :no, status: :inactive)
    beverage_2 = Beverage.create!(restaurant: restaurant, name: 'Capuccino', description: 'Café, chocolate, leite', calories: 1200, alcoholic: :no, status: :inactive)
    tag = Tag.create!(restaurant: restaurant, name: :gluten_free)
    dish_1.tags << tag
    beverage_1.tags << tag
    beverage_2.tags << tag
    menu_1 = Menu.create!(restaurant: restaurant, name: 'Café da Manhã')
    menu_1.dishes << dish_1
    menu_1.beverages << beverage_1
    beverage_2.menus << menu_1
    menu_2 = Menu.create!(restaurant: restaurant, name: 'Jantar')

    login_as(user)
    visit root_path
    click_on 'Quitutes Picantes'
    save_page

    within("##{dom_id(menu_1)}-card") do 
      expect(page).to have_content 'Pão de queijo'
      expect(page).to have_content 'Café expresso'
      expect(page).to have_content 'Capuccino'
    end

    within("##{dom_id(menu_2)}-card") do 
      expect(page).to have_content 'Não há itens cadastrados'
    end
  end
end

describe 'Usuário dono visita página do restaurante de outro usuário' do 
  it 'a vê os horários de funcionamento' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                city: "Ferraz de Vasconcelos", state: "SP",
                                zip_code: "11111-111", owner: user,
                                district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    other_user = User.create!(name: 'Zoroastro', email: 'zoroastro@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    other_restaurant = Restaurant.create!(registered_name: "Sabores do Brasil LTDA", trade_name: "Sabores do Brasil",
                       cnpj: CNPJ.generate, street_address: "Rua das Palmeiras, 123", district: 'Santana',
                       city: "São Paulo", state: "SP", zip_code: "01000-000", owner: other_user,
                       email: 'saboresdobrasil@email.com', phone_number: '11933301020')
    time = Time.zone.local(1000, 1, 1, 17, 0, 0)
    Shift.create!(weekday: :sunday, restaurant: other_restaurant, opening_time: time, closing_time: time + 3.hours)
    
    login_as(user)
    visit root_path
    click_on 'Sabores do Brasil'

    expect(current_path).to eq restaurant_path(other_restaurant.id)
    within('#weekday-sunday') do
      expect(page).to have_content('17:00 às 20:00')
    end
    within('#weekday-monday') do
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
                       zip_code: "11111-111", owner: user,
                       district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    other_user = User.create!(name: 'Zoroastro', email: 'zoroastro@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    Restaurant.create!(registered_name: "Sabores do Brasil LTDA", trade_name: "Sabores do Brasil",
                       cnpj: CNPJ.generate, street_address: "Rua das Palmeiras, 123", district: 'Santana',
                       city: "São Paulo", state: "SP", zip_code: "01000-000", owner: other_user,
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
                       zip_code: "11111-111", owner: user,
                       district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    other_user = User.create!(name: 'Zoroastro', email: 'zoroastro@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    other_restaurant = Restaurant.create!(registered_name: "Sabores do Brasil LTDA", trade_name: "Sabores do Brasil",
                                          cnpj: CNPJ.generate, street_address: "Rua das Palmeiras, 123", district: 'Santana',
                                          city: "São Paulo", state: "SP", zip_code: "01000-000", owner: other_user,
                                          email: 'saboresdobrasil@email.com', phone_number: '11933301020')
    Dish.create!(restaurant: other_restaurant, name: 'Hamburguer', description: 'carne, queijo, mostarda', calories: 1200)

    login_as(user)
    visit restaurant_path(other_user.owned_restaurant)

    expect(page).to have_content 'Hamburguer'
    expect(page).to have_content 'carne, queijo, mostarda'
    expect(page).to have_content '1200 kcal'
  end

  it 'e não vê a opção para editar os pratos' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                       cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                       city: "Ferraz de Vasconcelos", state: "SP",
                       zip_code: "11111-111", owner: user,
                       district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    other_user = User.create!(name: 'Zoroastro', email: 'zoroastro@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    other_restaurant = Restaurant.create!(registered_name: "Sabores do Brasil LTDA", trade_name: "Sabores do Brasil",
                                          cnpj: CNPJ.generate, street_address: "Rua das Palmeiras, 123", district: 'Santana',
                                          city: "São Paulo", state: "SP", zip_code: "01000-000", owner: other_user,
                                          email: 'saboresdobrasil@email.com', phone_number: '11933301020')
    dish = Dish.create!(restaurant: other_restaurant, name: 'Hamburguer', description: 'carne, queijo, mostarda', calories: 1200)

    login_as(user)
    visit restaurant_path(other_user.owned_restaurant)

    within("##{dom_id(dish)}-card") do
      expect(page).not_to have_content 'Editar'
    end
  end

  it 'e não vê a opção para cadastrar pratos' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                       cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                       city: "Ferraz de Vasconcelos", state: "SP",
                       zip_code: "11111-111", owner: user,
                       district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    other_user = User.create!(name: 'Zoroastro', email: 'zoroastro@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    other_restaurant = Restaurant.create!(registered_name: "Sabores do Brasil LTDA", trade_name: "Sabores do Brasil",
                                          cnpj: CNPJ.generate, street_address: "Rua das Palmeiras, 123", district: 'Santana',
                                          city: "São Paulo", state: "SP", zip_code: "01000-000", owner: other_user,
                                          email: 'saboresdobrasil@email.com', phone_number: '11933301020')
    Dish.create!(restaurant: other_restaurant, name: 'Hamburguer', description: 'carne, queijo, mostarda', calories: 1200)

    login_as(user)
    visit restaurant_path(other_user.owned_restaurant)

    expect(page).not_to have_content 'Cadastrar novo prato'
    end

  it 'e não vê pratos e bebidas inativas' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                       cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                       city: "Ferraz de Vasconcelos", state: "SP",
                       zip_code: "11111-111", owner: user,
                       district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    Beverage.create!(restaurant: restaurant, name: 'Coca-cola', description: 'Delicioso tônico', calories: 1200, alcoholic: :no, status: :inactive)
    Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'carne, queijo, mostarda', calories: 1200, status: :inactive)

    other_user = User.create!(name: 'Zoroastro', email: 'zoroastro@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    other_restaurant = Restaurant.create!(registered_name: "Sabores do Brasil LTDA", trade_name: "Sabores do Brasil",
                                          cnpj: CNPJ.generate, street_address: "Rua das Palmeiras, 123", district: 'Santana',
                                          city: "São Paulo", state: "SP", zip_code: "01000-000", owner: other_user,
                                          email: 'saboresdobrasil@email.com', phone_number: '11933301020')

    login_as(other_user)
    visit restaurant_path(user.owned_restaurant)

    expect(page).not_to have_content 'Coca-cola'
    expect(page).not_to have_content 'Hamburguer'
  end

  
end

describe 'Usuário funcionário visita página de restaurante' do
  it 'e vê os horários de funcionamento' do
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    cpf = CPF.generate
    new_employee = NewEmployee.create!(restaurant: restaurant, cpf: cpf, email: 'gertrudes@email.com')
    employee = User.create!(cpf: cpf, email: 'gertrudes@email.com', name: 'Gertrudes', password: 'asdfqwerasdf')
    time = Time.zone.local(1000, 1, 1, 17, 0, 0)
    Shift.create!(weekday: :sunday, restaurant: restaurant, opening_time: time, closing_time: time + 3.hours)
    
    login_as(employee)
    visit root_path

    expect(current_path).to eq restaurant_path(restaurant.id)
    within('#weekday-sunday') do
      expect(page).to have_content('17:00 às 20:00')
    end
    within('#weekday-monday') do
      expect(page).to have_content('fechado')
    end
  end

  it 'e não vê pratos e bebidas avulsos' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                       cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                       city: "Ferraz de Vasconcelos", state: "SP",
                       zip_code: "11111-111", owner: user,
                       district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    cpf = CPF.generate
    new_employee = NewEmployee.create!(restaurant: restaurant, cpf: cpf, email: 'gertrudes@email.com')
    employee = User.create!(cpf: cpf, email: 'gertrudes@email.com', name: 'Gertrudes', password: 'asdfqwerasdf')
    tag = Tag.create!(restaurant: restaurant, name: :vegan)
    other_tag = Tag.create!(restaurant: restaurant, name: :gluten_free)
    dish_1 = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'carne, queijo, mostarda', calories: 1200)
    dish_1.tags << tag
    dish_2 = Dish.create!(restaurant: restaurant, name: 'Cachorro quente', description: 'salsicha, pão, molhos', calories: 1200, status: :inactive)
    beverage_1 = Beverage.create!(restaurant: restaurant, name: 'Coca-cola', description: 'Delicioso tônico', calories: 1200, alcoholic: :no, status: :inactive)
    beverage_1.tags << tag
    beverage_1.tags << other_tag
    beverage_2 = Beverage.create!(restaurant: restaurant, name: 'Cerveja', description: 'Bebida fermentada de cerais maltados', calories: 1200, alcoholic: :yes, status: :inactive)

    login_as(employee)
    visit root_path

    expect(page).not_to have_content 'Hamburguer'
    expect(page).not_to have_content 'Cachorro quente'
    expect(page).not_to have_content 'Coca-cola'
    expect(page).not_to have_content 'Cerveja'
  end

  it 'e não consegue cadastrar pratos e bebidas' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    cpf = CPF.generate
    new_employee = NewEmployee.create!(restaurant: restaurant, cpf: cpf, email: 'gertrudes@email.com')
    employee = User.create!(cpf: cpf, email: 'gertrudes@email.com', name: 'Gertrudes', password: 'asdfqwerasdf')
    
    login_as(employee)
    visit root_path

    expect(current_path).to eq restaurant_path(restaurant.id)
    expect(page).not_to have_content 'Cadastrar nova bebida'
    expect(page).not_to have_content 'Cadastrar novo prato'
  end

  it 'e não consegue editar o restaurante' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    cpf = CPF.generate
    new_employee = NewEmployee.create!(restaurant: restaurant, cpf: cpf, email: 'gertrudes@email.com')
    employee = User.create!(cpf: cpf, email: 'gertrudes@email.com', name: 'Gertrudes', password: 'asdfqwerasdf')
    
    login_as(employee)
    visit root_path

    within("##{dom_id(restaurant)}-options") do
      expect(page).not_to have_content 'Editar'
    end
  end

  it 'e não consegue gerenciar funcionários' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    cpf = CPF.generate
    new_employee = NewEmployee.create!(restaurant: restaurant, cpf: cpf, email: 'gertrudes@email.com')
    employee = User.create!(cpf: cpf, email: 'gertrudes@email.com', name: 'Gertrudes', password: 'asdfqwerasdf')
    
    login_as(employee)
    visit root_path

    within("##{dom_id(restaurant)}-options") do
      expect(page).not_to have_content 'Gestão de funcionários'
    end
  end
  it 'e não vê pratos e bebidas inativos' do 
    user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    dish_1 = Dish.create!(restaurant: restaurant, name: 'Pão de queijo', description: 'quitute de polvilho com queijo', calories: 1200)
    dish_2 = Dish.create!(restaurant: restaurant, name: 'Misto quente', description: 'pão de forma, presunto, queijo', calories: 1200)
    beverage_1 = Beverage.create!(restaurant: restaurant, name: 'Café expresso', description: 'Extraído de grãos 100% arábica', calories: 1200, alcoholic: :no)
    beverage_2 = Beverage.create!(restaurant: restaurant, name: 'Capuccino', description: 'Café, chocolate, leite', calories: 1200, alcoholic: :no)
    cpf = CPF.generate
    new_employee = NewEmployee.create!(restaurant: restaurant, cpf: cpf, email: 'gertrudes@email.com')
    employee = User.create!(cpf: cpf, email: 'gertrudes@email.com', name: 'Gertrudes', password: 'asdfqwerasdf')
    tag = Tag.create!(restaurant: restaurant, name: :gluten_free)

    dish_1.tags << tag
    dish_2.tags << tag
    beverage_1.tags << tag
    beverage_2.tags << tag
    menu_1 = Menu.create!(restaurant: restaurant, name: 'Café da Manhã')
    menu_1.dishes << dish_1
    menu_1.dishes << dish_2
    menu_1.beverages << beverage_1
    menu_1.beverages << beverage_2
    dish_1.inactive!
    beverage_1.inactive!

    login_as(employee)
    visit root_path

    within("##{dom_id(menu_1)}-card") do 
      expect(page).not_to have_content 'Pão de queijo'
      expect(page).not_to have_content 'Café expresso'
      expect(page).to have_content 'Misto quente'
      expect(page).to have_content 'Capuccino'
    end

  end
end