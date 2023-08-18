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
    IF    '_id' in ${resposta.json()}
        Set Test Variable    ${ID_USUARIO}    ${resposta.json()["_id"]}    #aqui vai pegar a chave da resposta que tem o campo "id" e armazenar na variável "ID_USUARIO"
    END
    Set Test Variable    ${RESPOSTA}      ${resposta.json()}


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

Consultar os dados do novo usuário
    ${resposta_consulta}        GET On Session    alias=ServeRest    url=/usuarios/${ID_USUARIO}

    Log                         ${resposta_consulta.json()}
    Log                         ${resposta_consulta.reason}
    Log                         ${resposta_consulta.status_code}
    Log                         ${resposta_consulta.headers}
    Log                         ${resposta_consulta.text}
    Log                         ${resposta_consulta.url}
    Log                         ${resposta_consulta.elapsed}

    Set Test Variable           ${RESPOSTA_CONSULTA}        ${resposta_consulta.json()}

Conferir os dados retornados
    Log        ${RESPOSTA_CONSULTA}
    Dictionary Should Contain Key    ${RESPOSTA_CONSULTA}    nome            Carol Teste API Maya
    Dictionary Should Contain Key    ${RESPOSTA_CONSULTA}    email           ${EMAIL_TEST}
    Dictionary Should Contain Key    ${RESPOSTA_CONSULTA}    password        Password123@
    Dictionary Should Contain Key    ${RESPOSTA_CONSULTA}    administrador   true
    Dictionary Should Contain Key    ${RESPOSTA_CONSULTA}    _id             ${ID_USUARIO}

Realizar Login com o usuário
    ${body}  Create Dictionary
    ...      email=${EMAIL_TEST}
    ...      password=Password123@
    
    Log    ${body}
    Criar Sessão na ServeRest

    ${resposta}  POST On Session
    ...          alias=ServeRest
    ...          url=/login
    ...          json=${body}
    ...          expected_status=200
    
    Log     ${resposta.json()}

    Set Test Variable    ${RESPOSTA_LOGIN}    ${resposta.json()}

Conferir se o Login ocorreu com sucesso
    Dictionary Should Contain Item    ${RESPOSTA_LOGIN}    message            Login realizado com sucesso
    Dictionary Should Contain Key     ${RESPOSTA_LOGIN}    authorization
    