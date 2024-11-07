require 'rails_helper'

RSpec.describe User, type: :model do
  describe "#valid?" do
    context presence do
      it 'deve ter um nome' do
        user = User.new(email: 'email@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
        
        expect(user).not_to be_valid
      end

      it 'deve ter um cpf' do
        user = User.new(name: 'Zoroastro', email: 'email@email.com', password: 'alqpw-od#k82')
        
        expect(user).not_to be_valid
      end

      it 'deve ter um email' do
        user = User.new(name: 'Zoroastro', password: 'alqpw-od#k82', cpf: CPF.generate)
        
        expect(user).not_to be_valid
      end

      it 'cpf e e-mail de um funcionário pré-cadastrado devem pertencer ao mesmo registro' do 
        user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
        restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
        cpf = CPF.generate
        other_cpf = CPF.generate
        new_employee = NewEmployee.create!(restaurant: restaurant, cpf: cpf, email: 'gertrudes@email.com')
        other_new_employee = NewEmployee.create!(restaurant: restaurant, cpf: other_cpf, email: 'domestaquio@email.com')
        employee = User.new(cpf: cpf, email: 'domestaquio@email.com', password: 'asdfhalskjdfhçlança')

        expect(employee).not_to be_valid
      end
    end

    context 'uniqueness' do
      it 'CPF deve ser único' do
        cpf = CPF.generate
        User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: cpf)
        user = User.new(name: 'Zoroastro', email: 'zoroastro@email.com', password: 'vn3@sot8*#09', cpf: cpf)
        
        expect(user).not_to be_valid
      end

      it 'E-mail deve ser único' do 
        User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
        user = User.new(name: 'Zoroastro', email: 'amarildo@email.com', password: 'vn3@sot8*#09', cpf: CPF.generate)

        expect(user).not_to be_valid
      end
    end

    it 'CPF deve ser válido' do 
      user = User.new(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: '1234')
      
      expect(user).not_to be_valid
    end

    it 'Senha deve ter no mínimo 12 caracteres' do
      user = User.new(name: 'Amarildo', email: 'amarildo@email.com', password: 'asdfasdfasd', cpf: CPF.generate)

      expect(user).not_to be_valid
    end

    it 'E-mail deve ser válido' do
      user = User.new(name: 'Amarildo', email: '@email.com', password: 'asdfasdsdfasd', cpf: CPF.generate)

      expect(user).not_to be_valid
    end

    it 'É registrado como dono' do
      user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)

      expect(user.user_type).to eq "owner"
    end

    it 'Dono de restaurante não pode trabalhar em outro restaurante' do
      user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
      restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
      other_user = User.create!(name: 'Zoroastro', email: 'zoroastro@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
      other_restaurant = Restaurant.create!(registered_name: "Churros LTDA", trade_name: "Churros",
                                    cnpj: CNPJ.generate, street_address: "Avenida Doce, 456",
                                    city: "Guarulhos", state: "SP",
                                    zip_code: "33333-333", owner: other_user,
                                    district: "Doces", email: 'churros@email.com', phone_number: '11933301040')
      user.works_at_restaurant = other_restaurant

      expect(user).not_to be_valid
    end

    it 'Funcionário não pode ser dono de outro restaurante' do
      user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
      restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
      cpf = CPF.generate
      new_employee = NewEmployee.create!(restaurant: restaurant, cpf: cpf, email: 'gertrudes@email.com')
      employee = User.create!(cpf: cpf, email: 'gertrudes@email.com', name: 'Gertrudes', password: 'asdfqwerasdf')
      Restaurant.create!(registered_name: "Churros LTDA", trade_name: "Churros",
                                    cnpj: CNPJ.generate, street_address: "Avenida Doce, 456",
                                    city: "Guarulhos", state: "SP",
                                    zip_code: "33333-333", owner: employee,
                                    district: "Doces", email: 'churros@email.com', phone_number: '11933301040')

      expect(employee).not_to be_valid
    end
  end
end
