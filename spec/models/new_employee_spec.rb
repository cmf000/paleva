require 'rails_helper'

RSpec.describe NewEmployee, type: :model do
  describe '#valid' do 
    context 'presence' do
      it 'cpf é obrigatório' do
        user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
        restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                        cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                        city: "Ferraz de Vasconcelos", state: "SP",
                                        zip_code: "11111-111", user: user,
                                        district: "Pimentas", email: 'picante@email.com', phone_number: '11933301030')
        new_employee = NewEmployee.new(restaurant: restaurant, cpf: CPF.generate(strict: true), email: 'novofuncionario@email.com')

        expect(new_employee).not_to be_valid
      end
    end
  end
end
