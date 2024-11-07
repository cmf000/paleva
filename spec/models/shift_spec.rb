require 'rails_helper'

RSpec.describe Shift, type: :model do
  describe '#valid' do
    context 'presence' do
      it 'deve ter um dia da semana' do
        user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
        restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301020')
        time = Time.now.change(year: 1000, month: 1, day: 1, hour: 9, min: 0, sec: 0)
        shift = Shift.new(opening_time: time, closing_time: time + 1.hour, restaurant: restaurant)

        expect(shift).not_to be_valid
      end
    
      it 'deve ter horário de início' do
        user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
        restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301020')
        time = Time.now.change(year: 1000, month: 1, day: 1, hour: 9, min: 0, sec: 0)
        shift = Shift.new(weekday: :monday, closing_time: time + 1.hour, restaurant: restaurant)

        expect(shift).not_to be_valid
      end

      it 'deve ter horário de encerramento' do
        user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
        restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301020')
        time = Time.now.change(year: 1000, month: 1, day: 1, hour: 9, min: 0, sec: 0)
        shift = Shift.new(weekday: :monday, opening_time: time, restaurant: restaurant)

        expect(shift).not_to be_valid
      end

      it 'deve ter um restaurante' do
        time = Time.now.change(year: 1000, month: 1, day: 1, hour: 18, min: 0, sec: 0)
        shift = Shift.new(weekday: :monday, opening_time: time, closing_time: time + 1.hour)

        expect(shift).not_to be_valid
      end
    end

    it 'deve encerrar após iniciar' do
      user = User.create!(name: 'Amarildo', email: 'amarildo@email.com', password: 'alqpw-od#k82', cpf: CPF.generate)
      restaurant = Restaurant.create!(registered_name: "Picante LTDA", trade_name: "Quitutes Picantes",
                                    cnpj: CNPJ.generate, street_address: "Avenida Quente, 456",
                                    city: "Ferraz de Vasconcelos", state: "SP",
                                    zip_code: "11111-111", owner: user,
                                    district: "Pimentas", email: 'picante@email.com', phone_number: '11933301020')
      time = Time.now.change(year: 1000, month: 1, day: 1, hour: 18, min: 0, sec: 0)
      shift = Shift.new(weekday: :monday, opening_time: time, closing_time: time - 1.hour, restaurant: restaurant)

      expect(shift).not_to be_valid
    end
  end
end
