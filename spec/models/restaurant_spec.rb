require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'deve ter uma razão social' do
        user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
        restaurant = Restaurant.new(registered_name: "", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301020')
        
        restaurant.valid?
        expect(restaurant.errors.include? :registered_name).to be true
        expect(restaurant.errors[:registered_name]).to include 'não pode ficar em branco'
      end

      it 'deve ter um nome fantasia' do
        user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
        restaurant = Restaurant.new(registered_name: "Picante LTDA", trade_name: "",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301020')
        
        restaurant.valid?
        expect(restaurant.errors.include? :trade_name).to be true
        expect(restaurant.errors[:trade_name]).to include 'não pode ficar em branco'
      end

      it 'deve ter um CNPJ' do
        user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
        restaurant = Restaurant.new(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: "", street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301020')
        
        restaurant.valid?
        expect(restaurant.errors.include? :cnpj).to be true
        expect(restaurant.errors[:cnpj]).to include 'não pode ficar em branco'
      end

      it 'deve ter uma linha de endereço' do
        user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
        restaurant = Restaurant.new(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301020')
        
        restaurant.valid?
        expect(restaurant.errors.include? :street_address).to be true
        expect(restaurant.errors[:street_address]).to include 'não pode ficar em branco'
      end

      it 'deve ter uma cidade' do
        user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
        restaurant = Restaurant.new(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301020')
        
        restaurant.valid?
        expect(restaurant.errors.include? :city).to be true
        expect(restaurant.errors[:city]).to include 'não pode ficar em branco'
      end

      it 'deve ter um estado' do
        user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
        restaurant = Restaurant.new(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301020')
        
        restaurant.valid?
        expect(restaurant.errors.include? :state).to be true
        expect(restaurant.errors[:state]).to include 'não pode ficar em branco'
      end

      it 'deve ter uma CEP' do
        user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
        restaurant = Restaurant.new(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301020')
        
        restaurant.valid?
        expect(restaurant.errors.include? :zip_code).to be true
        expect(restaurant.errors[:zip_code]).to include 'não pode ficar em branco'
      end

      it 'deve ter um usuário' do
        restaurant = Restaurant.new(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111",
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301020')
        
        restaurant.valid?
        expect(restaurant.errors.include? :user_id).to be true
        expect(restaurant.errors[:user_id]).to include 'não pode ficar em branco'
      end

      it 'deve ter uma bairro' do
        user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
        restaurant = Restaurant.new(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "", email: 'picante@email.com', phone_number: '11933301020')
        
        restaurant.valid?
        expect(restaurant.errors.include? :district).to be true
        expect(restaurant.errors[:district]).to include 'não pode ficar em branco'
      end

      it 'deve ter um email' do
        user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
        restaurant = Restaurant.new(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: '', phone_number: '11933301020')
        
        restaurant.valid?
        expect(restaurant.errors.include? :email).to be true
        expect(restaurant.errors[:email]).to include 'não pode ficar em branco'
      end

      it 'deve ter um código' do
        user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
        restaurant = Restaurant.new(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301020')
        
        restaurant.valid?
        expect(restaurant.errors.include? :code).to be false
        expect(restaurant).to be_valid
      end

      it 'deve ter um telefone' do
        user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
        restaurant = Restaurant.new(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com')
        
        restaurant.valid?
        expect(restaurant.errors.include? :phone_number).to be true
        expect(restaurant.errors[:phone_number]).to include 'não pode ficar em branco'
      end
    end

    context 'uniqueness' do
      it 'o código deve ser único' do
        allow(SecureRandom).to receive(:alphanumeric).with(6).and_return('ABC123')
        user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
        Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301020')
        other_user = User.create!(name: 'Zoroastro', email: 'zoroastro@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
        other_restaurant = Restaurant.new(registered_name: "Doces Delicias LTDA", trade_name: "Doces Delicias",
                                    cnpj: CNPJ.generate, street_address: "Avenida das Sobremesas, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "22222-222", owner: other_user,
                                    district: "Caldas", email: 'doces@email.com', phone_number: '11933301020')
        
        other_restaurant.valid?
        expect(other_restaurant.errors.include? :code).to be true
        expect(other_restaurant.errors[:code]).to include 'já existe'
      end

      it 'o email deve ser único' do
        user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
        Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301020')
        other_user = User.create!(name: 'Zoroastro', email: 'zoroastro@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
        other_restaurant = Restaurant.new(registered_name: "Doces Delicias LTDA", trade_name: "Doces Delicias",
                                    cnpj: CNPJ.generate, street_address: "Avenida das Sobremesas, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "22222-222", owner: other_user,
                                    district: "Caldas", email: 'picante@email.com', phone_number: '11933301020')
        
        other_restaurant.valid?
        expect(other_restaurant.errors.include? :email).to be true
        expect(other_restaurant.errors[:email]).to include 'já existe'
      end
    end

    it 'deve ter um email válido' do
      user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
      restaurant = Restaurant.new(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                     cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                     city: "Ferraz de Vasconcelos", state: "SP",
                     zip_code: "11111-111", owner: user,
                     district: "Pimentas", email: 'email.com', phone_number: '11933301020')

      restaurant.valid?
      expect(restaurant.errors.include? :email).to be true
      expect(restaurant.errors[:email]).to include 'não é válido'
    end
    
    it 'deve ter um cnpj válido' do
      user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
      restaurant = Restaurant.new(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                     cnpj: "12.345.678/0001-90", street_address: "Avenida Quente, 456",
                     city: "Ferraz de Vasconcelos", state: "SP",
                     zip_code: "11111-111", owner: user,
                     district: "Pimentas", email: 'picante@email.com', phone_number: '11933301020')

      restaurant.valid?
      expect(restaurant.errors.include? :cnpj).to be true
      expect(restaurant.errors[:cnpj]).to include 'não é válido'
    end

    it 'deve ter um telefone válido' do
      user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
      restaurant = Restaurant.new(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                  cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                  city: "Ferraz de Vasconcelos", state: "SP",
                                  zip_code: "11111-111", owner: user,
                                  district: "Pimentas", email: 'picante@email.com', phone_number: '119333020')
      
      restaurant.valid?
      expect(restaurant.errors.include? :phone_number).to be true
      expect(restaurant.errors[:phone_number]).to include 'é muito curto (mínimo: 10 caracteres)'
    end

    it 'o telefone deve ser numérico' do
      user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
      restaurant = Restaurant.new(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                  cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                  city: "Ferraz de Vasconcelos", state: "SP",
                                  zip_code: "11111-111", owner: user,
                                  district: "Pimentas", email: 'picante@email.com', phone_number: 'abcdfghijlm')
      
      expect(restaurant).not_to be_valid
      restaurant.valid?
      expect(restaurant.errors.include? :phone_number).to be true
      expect(restaurant.errors[:phone_number]).to include 'não é válido'
    end

    it 'código deve ter 6 caracteres' do
      user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
      restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                  cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                  city: "Ferraz de Vasconcelos", state: "SP",
                                  zip_code: "11111-111", owner: user,
                                  district: "Pimentas", email: 'picante@email.com', phone_number: '11933301020')
        
      expect(restaurant.code.length).to eq 6
      restaurant.valid?
      expect(restaurant.errors.include? :code).to be false
    end
  end
end
