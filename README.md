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

### **Chaves**
| Chave       | Tipo   | Descrição                                                               |
|-------------|--------|-------------------------------------------------------------------------|
| `status`    | string | Status do pedido (e.g., `pending_kitchen`, `preparing`, `ready`).       |
| `code`      | string | Código alfanumérico único do pedido.                                    |
| `placed_at` | string | Horário de criação do pedido.                                           |                             |


### **Outros retornos**
A requisição é respondida com status 204 caso não exista pedidos para serem retornados e 400 em caso de parâmetro inválido

### **Endpoint**
`GET /api/v1/restaurants/{restaurant_code}/orders/{order_code}`

---
#### **Descrição** : acessa os detalhes de um pedido

---

#### **Código HTTP**
`200 OK`

### **Parâmetros**
| Parâmetro         | Tipo   | Descrição                                    |
|-------------------|--------|----------------------------------------------|
| `restaurant_code` | string | Código alfanumérico único do restaurante     |
| `order_code`      | string | Código alfanumérico único do pedido          |

---

#### **JSON**
```json
[
  {
  "status": "pending_kitchen",
  "code": "EJRHSSH4",
  "placed_at": "2024-11-21T22:54:37.955Z",
   "items":
            [
               {
                  quantity: 2,
                  comment: "",
                  item_name: 'Coca-cola',
                  offering_description: '2L'
               },
               {
                  quantity: 1,
                  comment: "Sem cebola",
                  item_name: 'Hamburguer',
                  offering_description: 'Grande'
               },
               ...
            ]
  },
  ...
]
```
### **Chaves**
| Field       | Type   | Description                                                             |
|-------------|--------|-------------------------------------------------------------------------|
| `status`    | string | Status do pedido (e.g., `pending_kitchen`, `preparing`, `ready`).       |
| `code`      | string | Código alfanumérico único do pedido.                                    |
| `placed_at` | string | Horário de criação do pedido.                                           | 
| `quantity`  | integer| Quantidade do item                                                      |  
| `comment  ` | string | Observação                                                              |  
| `item_name` | string | Nome do item                                                            |  
| `offering_description` | string | Descrição do item                                            |

### **Outros retornos**
A requisição é respondida com status 404 caso os parâmetros sejam inválidos e 403 caso o pedido não tenha sido finalizado.

## **Cancel Order**

### **Endpoint**
`POST /api/v1/restaurants/{restaurant_code}/orders/{order_code}/cancel`

---

### **Description**
Cancela um pedido. Uma requisição válida deve incluir um `comment`  explicando o motivo do concelamento. Se `comment` não estiver incluso no corpo da requisição, um erro é retornado.

---

### **Parâmetros**
| Parâmetro         | Tipo   | Descrição                                    |
|-------------------|--------|----------------------------------------------|
| `restaurant_code` | string | Código alfanumérico único do restaurante     |
| `order_code`      | string | Código alfanumérico único do pedido          |

### **Body**
| Key      | Tipo   | Obrigatório | Descrição                                              |
|----------|--------|-------------|--------------------------------------------------------|
| `comment`| string | Yes         | Motivo do cancelamento                                 |

### **Retornos**
A requisição é respondida com status 404 caso os parâmetros sejam inválidos e 400 caso o a mensagem não tenha sido informada.
Em caso de sucesso os detalhes do pedido com status alterado são retornado com status 200.

### **Demais endpoints**
 1. `POST /api/v1/restaurants/{restaurant_code}/orders/{order_code}/preparing`
 2. `POST /api/v1/restaurants/{restaurant_code}/orders/{order_code}/ready`

---

### **Descrição**
 1. A cozinha aceita um pedido.
 2. A cozinha infoma um pedido como pronto.

---

### **Parâmetros**
| Parâmetro         | Tipo   | Descrição                                    |
|-------------------|--------|----------------------------------------------|
| `restaurant_code` | string | Código alfanumérico único do restaurante     |
| `order_code`      | string | Código alfanumérico único do pedido          |


### **Retornos**
A requisição é respondida com status 404 caso os parâmetros sejam inválidos e 400 caso a transição de status de pedido seja inválida.
Em caso de sucesso os detalhes do pedido com status alterado são retornado com status 200.


## Licença
  Este projeto está licenciado sob a [Licença MIT](https://mit-license.org/).

   







