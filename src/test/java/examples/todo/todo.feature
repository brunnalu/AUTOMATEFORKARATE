@regression
Feature: Testes da API Todo

  Scenario: Criar um novo todo (POST)
    Given url 'https://jsonplaceholder.typicode.com/todos'
    And request { userId: 1, title: 'Novo Todo', completed: false }
    When method post
    Then status 201
    And match response.title == 'Novo Todo'
    And match response.completed == false

  Scenario: Buscar todos os todos (GET)
    Given url 'https://jsonplaceholder.typicode.com/todos'
    When method get
    Then status 200
    And match response[0].id != null

  Scenario: Buscar um todo existente por ID (GET)
    Given url 'https://jsonplaceholder.typicode.com/todos/1'
    When method get
    Then status 200
    And match response.id == 1

  Scenario: Atualizar um todo existente (PUT)
    Given url 'https://jsonplaceholder.typicode.com/todos/1'
    And request { title: 'Atualizado', completed: true }
    When method put
    Then status 200
    And match response.title == 'Atualizado'
    And match response.completed == true

  Scenario: Deletar um todo existente (DELETE)
    Given url 'https://jsonplaceholder.typicode.com/todos/1'
    When method delete
    Then status 200