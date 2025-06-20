Feature: TestConocimientoBTHCCC444

  Background:
    * configure ssl = true
    * def urlApi = 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters'

  @id:1 @ConsultaTodosLosPersonajesExitoso
  Scenario: Verifica que se consulten todos los personajes
    Given url urlApi
    When method GET
    Then status 200

  @id:2 @ConsultaPersonajesPorIdExitoso
  Scenario Outline: Verifica que se consulten el personaje por id
    Given url urlApi + '/<id>'
    When method GET
    Then status 200
    And print response
    And match response != { error: 'Character not found' }
    Examples:
      |read('classpath:/data/PersonajesData.csv')|

  @id:3 @ConsultaPersonajesPorIdFallido
  Scenario Outline: Verifica que NO se consulten el personaje por id que no existe
    Given url urlApi + '/<id>'
    When method GET
    Then status 404
    And print response
    And match response == { error: 'Character not found' }
    Examples:
      |read('classpath:/data/PersonajesDataFallo.csv')|

  @id:5 @CrearPersonajeExitoso
  Scenario Outline: Verifica que se cree un personaje exitosamente
    Given url urlApi
    And def requestCreate =  read('classpath:/data/bodyCreate.json')
    And request requestCreate
    And header Content-Type = 'application/json'
    When method POST
    Then status 201
    And print response
    Examples:
    |read('classpath:/data/PersonajesDataCrear.csv')|

  @id:6 @CrearPersonajeFallidoDuplicado
  Scenario Outline: Verifica que no se cree un personaje por nombre duplicado
    Given url urlApi
    And def requestCreate =  read('classpath:/data/bodyCreate.json')
    And request requestCreate
    And header Content-Type = 'application/json'
    When method POST
    Then status 400
    And print response
    And match response == { error: 'Character name already exists' }
    Examples:
      |read('classpath:/data/PersonajesDataCrear.csv')|

  @id:7 @CrearPersonajeFallidoCamposRequeridos
  Scenario: Verifica que no se cree un personaje por falta de campos
    Given url urlApi
    And def requestCreate =  read('classpath:/data/bodyCreateFallo.json')
    And def responseFailed =  read('classpath:/data/bodyCreateFalloResponse.json')
    And request requestCreate
    And header Content-Type = 'application/json'
    When method POST
    Then status 400
    And print response
    And match response == responseFailed

  @id:8 @ActualizarPersonajeExitoso
  Scenario Outline: Verifica que se actualice un personaje dado un id
    Given url urlApi + '/<id>'
    And def requestUpdate =  read('classpath:/data/bodyUpdate.json')
    And request requestUpdate
    And header Content-Type = 'application/json'
    When method PUT
    Then status 200
    And print response
    And match response.name ==  '<name>'
    Examples:
      |read('classpath:/data/PersonajesDataActualizar.csv')|

  @id:9 @ActualizaPersonajesPorIdFallido
  Scenario Outline: Verifica que NO se consulten el personaje por id que no existe
    Given url urlApi + '/<id>'
    And def requestUpdate =  read('classpath:/data/bodyUpdate.json')
    And request requestUpdate
    And header Content-Type = 'application/json'
    When method PUT
    Then status 404
    And print response
    And match response == { error: 'Character not found' }
    Examples:
      |read('classpath:/data/PersonajesDataFallo.csv')|

  @id:10 @EliminarPersonajeExitoso
  Scenario Outline: Verifica que se elimine de manera existosa un personaje
    Given url urlApi + '/<id>'
    When method DELETE
    Then status 204
    Examples:
      |read('classpath:/data/PersonajesDataEliminar.csv')|

  @id:11 @EliminarPersonajeFallido
  Scenario Outline: Verifica que NO se elimine un personaje por id que no existe
    Given url urlApi + '/<id>'
    When method DELETE
    Then status 404
    And print response
    And match response == { error: 'Character not found' }
    Examples:
      |read('classpath:/data/PersonajesDataEliminar.csv')|




