*** Settings ***
Library    RequestsLibrary
Library    String
Library    Collections

*** Keywords ***
Criar um usuário novo
    ${palavra_aleatoria}    Generate Random String    length=4    chars=[LETTERS]
    ${palavra_aleatoria}    Convert To Lower Case     ${palavra_aleatoria}
    Set Test Variable       ${EMAIL_TEST}             ${palavra_aleatoria}@yopmail.com

Cadastrar o usuário criado na ServeRest
    [Arguments]    ${email}    ${status_code_desejado}
    ${body}        Create Dictionary    
    ...            nome=Carol Teste API Maya    
    ...            email=${EMAIL_TEST}    
    ...            password=Password123@    
    ...            administrador=true
    
    Criar Sessão na ServeRest

    ${resposta}    POST On Session    #usa a post on session porque criou uma sessão e aqui o post vai ser feito nela
    ...            alias=ServeRest
    ...            url=/usuarios
    ...            json=${body}
    ...            expected_status=${status_code_desejado}
    Log            ${resposta.json()}
    Set Test Variable    ${RESPOSTA}    ${resposta.json()}


Criar Sessão na ServeRest    #itens comuns para todas as requisções
    ${headers}     Create Dictionary    accept=application/json    Content-Type=application/json
    # Para pegar as informações para passar no headers, usou o curl do "POST - cadastrar usuários"
    #    curl -X 'POST' \
    #   'https://serverest.dev/usuarios' \
    #   -H 'accept: application/json' \
    #   -H 'Content-Type: application/json' \
    #   -d '{
    #   "nome": "Fulano da Silva",
    #   "email": "beltrano2@qa.com.br",
    #   "password": "teste",
    #   "administrador": "true"
    # }'
    Create Session    alias=ServeRest    url=https://serverest.dev    headers=${headers}    #aqui aponta apeenas a URL base

Conferir se o usuário foi cadastrado corretamente
    Log                               ${RESPOSTA}
    Dictionary Should Contain Item    ${RESPOSTA}    message    Cadastro realizado com sucesso    #conferindo o resultado da resposta
    Dictionary Should Contain Key     ${RESPOSTA}    _id    #como é uma chave aleatória, valida assim

Repetir o cadastro do usuário
    Cadastrar o usuário criado na ServeRest    ${EMAIL_TEST}    400
    #aqui vai dar erro "400 Client Error: Bad Request for url: https://serverest.dev/usuarios", mas é exatamente isso que queremos testar
    #pra isso, vai precisar de um "expected status" na resposta
Verificar se a API não permitiu o cadastro repetido
    Dictionary Should Contain Item    ${RESPOSTA}    message    Este email já está sendo usado
    