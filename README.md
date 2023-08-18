# api-serve-ret-modulo4-curso-Maya
parte de API curso da May Fernandes: https://www.udemy.com/course/automacao-de-testes-com-robot-framework-basico/learn/lecture/35315446#overview


# Itens necessários:
- **Library**: 
    - [HTTP RequestsLibrary (Python)](https://github.com/MarketSquare/robotframework-requests#readme)
    - [Collections](https://robotframework.org/robotframework/latest/libraries/Collections.html) - faz conferência de dicionários (json) e listas (array)


# Estrutura dos arquivos:
- **tests\api_testing_usuarios.robot**: regra de negócio do teste
- **resources\api_testing_usuarios.resource**: resource

## Link com todas as possíveis respostas para quando usa a lib request:
- [Properties and Methods](https://www.w3schools.com/python/ref_requests_response.asp)
    - coloquei alguns exemplos lá na KW `Consultar os dados do novo usuário`

**Para rodar um teste**: `robot -d ./results tests/api_testing_usuarios.robot` ou pelo "run"