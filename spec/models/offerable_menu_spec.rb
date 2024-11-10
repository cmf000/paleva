require 'rails_helper'

RSpec.describe OfferableMenu, type: :model do
  describe '#valid?' do
    context 'uniqueness' do 
      it 'itens no menu devem ser únicos' do
        user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
        restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
        menu = Menu.create!(restaurant: restaurant, name: 'Jantar')
        dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'pão, carne, queijo', calories: 1200)
        offerable_menu = OfferableMenu.create!(menu: menu, offerable: dish)
        offerable_menu_1 = OfferableMenu.new(menu: menu, offerable: dish)

        expect(offerable_menu_1).not_to be_valid
      end
    end
  end
end
