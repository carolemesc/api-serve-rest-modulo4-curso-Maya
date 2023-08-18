*** Settings ***
Resource    ../resources/api_testing_usuarios.resource

*** Variables ***


*** Test Cases ***
Cadastrar um novo usuário com sucesso na ServeRest
    Criar um usuário novo
    Cadastrar o usuário criado na ServeRest    ${EMAIL_TEST}    201
    Conferir se o usuário foi cadastrado corretamente

Cadastrar um usuário já existente
# esse é um teste que sabemos que vai falhar, ele tem que falhar na verdade, já que nesse caso não pode repetir usuário e para testar esse caso, é só conferir o status code
    Criar um usuário novo
    Cadastrar o usuário criado na ServeRest    ${EMAIL_TEST}    201
    Repetir o cadastro do usuário              #aqui eu estou mandando o status 400 (de erro) lá dentro da KW
    Verificar se a API não permitiu o cadastro repetido

Consultar os dados de um novo usuário
    Criar um usuário novo
    Cadastrar o usuário criado na ServeRest    ${EMAIL_TEST}    201
    Consultar os dados do novo usuário
    Conferir os dados retornados

Logar com o novo usuário criado
    Criar um usuário novo
    Cadastrar o usuário criado na ServeRest    ${EMAIL_TEST}    201
    Realizar Login com o usuário
    Conferir se o Login ocorreu com sucesso