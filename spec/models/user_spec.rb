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
  end
end
