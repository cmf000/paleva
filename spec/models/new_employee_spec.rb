require 'rails_helper'

RSpec.describe NewEmployee, type: :model do
  describe '#valid' do 
    context 'presence' do
      it 'cpf é obrigatório' do
        user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
        restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                        cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                        city: "Ferraz de Vasconcelos", state: "SP",
                                        zip_code: "11111-111", owner: user,
                                        district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
        new_employee = NewEmployee.new(restaurant: restaurant, email: 'novofuncionario@email.com')

        expect(new_employee).not_to be_valid
      end

      it 'email é obrigarório' do 
        user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
        restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                        cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                        city: "Ferraz de Vasconcelos", state: "SP",
                                        zip_code: "11111-111", owner: user,
                                        district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
        new_employee = NewEmployee.new(restaurant: restaurant, cpf: CPF.generate)

        expect(new_employee).not_to be_valid
      end
    end
    context 'uniqueness' do 
      it 'cpf deve ser único' do 
        user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
        restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                        cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                        city: "Ferraz de Vasconcelos", state: "SP",
                                        zip_code: "11111-111", owner: user,
                                        district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
        cpf = CPF.generate
        new_employee_1 = NewEmployee.create!(restaurant: restaurant, cpf: cpf, email: 'novofuncionario1@email.com')
        new_employee_2 = NewEmployee.new(restaurant: restaurant, cpf: cpf, email: 'novofuncionario2@email.com')

        expect(new_employee_2).not_to be_valid
      end

      it 'email deve ser único' do 
        user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
        restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                        cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                        city: "Ferraz de Vasconcelos", state: "SP",
                                        zip_code: "11111-111", owner: user,
                                        district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
        new_employee_1 = NewEmployee.create!(restaurant: restaurant, cpf: CPF.generate, email: 'novofuncionario1@email.com')
        new_employee_2 = NewEmployee.new(restaurant: restaurant, cpf: CPF.generate, email: 'novofuncionario1@email.com')

        expect(new_employee_2).not_to be_valid
      end
    end

    it 'cpf deve ser único em users' do
      cpf = CPF.generate
      user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: cpf)
      restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                      cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                      city: "Ferraz de Vasconcelos", state: "SP",
                                      zip_code: "11111-111", owner: user,
                                      district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
      new_employee = NewEmployee.new(restaurant: restaurant, cpf: cpf, email: 'novofuncionario@email.com')

      expect(new_employee).not_to be_valid
    end

    it 'email deve ser único em users' do
      user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
      restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                      cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                      city: "Ferraz de Vasconcelos", state: "SP",
                                      zip_code: "11111-111", owner: user,
                                      district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
      new_employee = NewEmployee.new(restaurant: restaurant, cpf: CPF.generate, email: 'amarildo@email.com')

      expect(new_employee).not_to be_valid
    end

    it 'email deve ser válido' do 
      user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
      restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                      cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                      city: "Ferraz de Vasconcelos", state: "SP",
                                      zip_code: "11111-111", owner: user,
                                      district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
      new_employee = NewEmployee.new(restaurant: restaurant, cpf: CPF.generate, email: 'amarildoemail.com')

      expect(new_employee).not_to be_valid
    end

    it 'email deve ser válido' do 
      user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
      restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                      cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                      city: "Ferraz de Vasconcelos", state: "SP",
                                      zip_code: "11111-111", owner: user,
                                      district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
      new_employee = NewEmployee.new(restaurant: restaurant, cpf: '28346', email: 'amarildo@email.com')

      expect(new_employee).not_to be_valid
    end
  end
end
