<h1>Palevá</h1>

Aplicação Ruby on Rails para gerenciamento de um restaurante que vende na modalidade <i>takeout</i>. O sistema oferece recursos para integração com um app disponível para a cozinha do restaurante por uma API e gerenciar produtos, cardápios, pedidos, o acesso de funcionários.

Este projeto foi desenvolvido durante o programa Treinadev 13, oferecido pela Campus Code.

## Funcionalidades

### Contas de Usuário
- Registro e login seguro usando [Devise](https://github.com/heartcombo/devise).

### Gerenciamento de Restaurantes
- Registre e gerencie seu restaurante.

### Pratos e Bebidas
- Adicione pratos e bebidas ao seu restaurante.
- Crie e gerencie porções com preços.

### Histórico de Preços
- Visualize o histórico de alterações de preços de qualquer porção.

### Menus
- As porções cadastradas estão disponíveis através de menus.
- Somente porções de pratos e bebidas ativos podem ser adicionadas aos pedidos.

### Gestão de Pedidos
- Adicione porções cadastradas em menus aos pedidos.
- Suporte para aplicativo complementar para recuperar pedidos.

## Gems Utilizadas
- **Devise**: Sistema de autenticação.
- **cpf_cnpj**: Validação de valores CPF/CNPJ.
- **RSpec**: Framework de testes.
- **Capybara**: Testes de interação web.
- **Rack-CORS**: Permite configurações de CORS para comunicação local com o aplicativo complementar.

## Integração com API
Este aplicativo fornece uma API para um aplicativo complementar, que recupera dados de pedidos. Certifique-se de configurar as definições de CORS necessárias em `config/initializers/cors.rb`.

### Pré-requisitos
- Ruby >= 3.0.0
- Rails >= 7.0
- SQLite3

## Instalação
1. Clone o repositório:

   ```bash
   git clone https://[github.com/cmf000/paleva](https://github.com/cmf000/paleva)
   cd paleva
   ```
2. Instale as dependências

   ```bash
     bundle install
   ```
3. Crie um banco de dados

   ```bash
      rails db:setup
   ```

4. Start the application on a local server

   ```bash
    ./bin/dev
   ```
  Acesse a aplicação no navegador em http://localhost:3000


## API de pedidos

### **Endpoint** : pedidos de um restaurante
`GET /api/v1/restaurants/{restaurant_code}/orders`

---
#### **Descrição** : acessa os pedidos de um restaurante pelo código
---

### **Parâmetros**
| Par               | Tipo   | Descrição                                    |
|-------------------|--------|----------------------------------------------|
| `restaurant_code` | string | Código alfanumérico único do restaurante     |

---

### **Response**

#### **Código HTTP**
`200 OK`

#### **JSON**
```json
[
  {
  "status": "pending_kitchen",
  "code": "EJRHSSH4",
  "placed_at": "2024-11-21T22:54:37.955Z",
  },
  {
  "status": "preparing",
  "code": "GJYHE6H5",
  "placed_at": "2024-11-21T20:50:30.955Z",
  },
  ...
]
```

## **JSON**

### **Top-Level Fields**
| Field       | Type   | Description                                                             |
|-------------|--------|-------------------------------------------------------------------------|
| `status`    | string | Status do pedido (e.g., `pending_kitchen`, `preparing`, `ready`).       |
| `code`      | string | Código alfanumérico único do pedido.                                    |
| `placed_at` | string | Horário de criação do pedido.                                           |                             |


### **Outros retornos**
A requisição é respondida com status 204 caso não exista pedidos para serem retornados e 400 em caso de dados inválidos

### **Endpoint** : pedidos de um restaurante
`GET /api/v1/restaurants/{restaurant_code}/orders`

## Licença
  Este projeto está licenciado sob a [Licença MIT](https://mit-license.org/).

   







