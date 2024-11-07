require 'rails_helper'

RSpec.describe PriceHistory, type: :model do
  describe "#valid?" do 
    context 'presence' do
      it 'preço deve ser obrigatório' do 
        user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
        restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                        cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                        city: "Ferraz de Vasconcelos", state: "SP",
                                        zip_code: "11111-111", owner: user,
                                        district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
        beverage = Beverage.create!(name: 'Coca-cola', restaurant: restaurant, description: 'delicioso tônico de Atlanta', alcoholic: :no)
        offering = Offering.new(offerable: beverage, description: '2 L', effective_at: DateTime.now)
        price_history = PriceHistory.new(offering: offering, effective_at: DateTime.now)
        
        expect(price_history).not_to be_valid
      end

      it 'data deve ser obrigatória' do 
        user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
        restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                        cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                        city: "Ferraz de Vasconcelos", state: "SP",
                                        zip_code: "11111-111", owner: user,
                                        district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
        beverage = Beverage.create!(name: 'Coca-cola', restaurant: restaurant, description: 'delicioso tônico de Atlanta', alcoholic: :no)
        offering = Offering.new(offerable: beverage, description: '2 L')
        price_history = PriceHistory.new(offering: offering, price: 8.5)
    
        expect(price_history).not_to be_valid
      end
      
      it 'data deve ser obrigatória' do 
        price_history = PriceHistory.new(price: 8.5, effective_at: DateTime.now)
        expect(price_history.save).not_to be true 
      end 
    end
  end
end
