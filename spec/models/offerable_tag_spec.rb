require 'rails_helper'

RSpec.describe OfferableTag, type: :model do
  describe '#valid?' do
    context 'uniqueness' do 
      it 'cada tag só se associa a um item uma vez' do
        user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
        restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
        dish = Dish.create!(restaurant: restaurant, name: 'Hamburguer', description: 'pão, carne, queijo', calories: 1200)
        tag = Tag.create!(restaurant: restaurant, name: :vegan)
        offerable_tag = OfferableTag.create!(tag: tag, offerable: dish)
        offerable_tag = OfferableTag.new(tag: tag, offerable: dish)

        expect(offerable_tag).not_to be_valid
      end
    end

    it 'tags e item devem estar associados ao mesmo restaurante' do 
      user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
    beverage = Beverage.create!(restaurant: restaurant, name: 'Coca-cola', description: '2L', calories: 1200, alcoholic: :no)
    other_user = User.create!(name: 'Zoroastro', email: 'zoroastro@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
    other_restaurant = Restaurant.create!(registered_name: "Sabores do Brasil LTDA", trade_name: "Sabores do Brasil",
                                          cnpj: CNPJ.generate, street_address: "Rua das Palmeiras, 123", district: 'Santana',
                                          city: "São Paulo", state: "SP", zip_code: "01000-000", owner: other_user,
                                          email: 'saboresdobrasil@email.com', phone_number: '11933301020')
    other_restaurant_tag = Tag.create!(restaurant: other_restaurant, name: :gluten_free)
    offerable_tag = OfferableTag.new(offerable: beverage, tag: other_restaurant_tag)

    expect(offerable_tag).not_to be_valid
    end
  end
end
