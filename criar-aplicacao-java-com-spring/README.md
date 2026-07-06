# Script de Criação de Projeto API First

Este script é um utilitário para automatizar a criação de estruturas de projeto baseadas em API First, com suporte a Gradle e uma estrutura de módulos bem definida.

## O que o script faz

O script `create-project.sh` permite criar automaticamente uma estrutura de projeto Java/Gradle seguindo boas práticas e práticas recomendadas da empresa Valecard. Ele cria:

- Estrutura de diretórios com módulos domain, application e infrastructure
- Arquivos de configuração Gradle para todos os módulos
- Configurações de checkstyle com regras específicas
- Arquivo Makefile com comandos úteis
- Docker Compose com serviços padrão (MySQL, Redis, WireMock)

## Como usar

1. Execute o script: `./create-project.sh`
2. Informe o nome do projeto (ex: ms-banking-fee-management)
3. Informe o pacote do projeto (ex: br.com.api.first)

## Estrutura de diretórios criada

```
<nome_do_projeto>/
├── build.gradle.kts
├── settings.gradle.kts
├── gradle.properties
├── .gitignore
├── .gitattributes
├── Makefile
├── docker-compose.yml
├── config/
│   └── checkstyle/
│       └── checkstyle.xml
├── modules/
│   ├── domain/
│   │   └── build.gradle.kts
│   ├── application/
│   │   └── build.gradle.kts
│   └── infrastructure/
│       ├── build.gradle.kts
│       └── src/main/java/<pacote>/
│           └── <ApplicationClass>.java
└── config/
    └── wiremock/
        ├── __files/
        └── mappings/
```

## Configurações incluídas

- Java 21 com toolchain
- Gradle com plugins: spotless, sonarqube, jacoco
- Dependências padrão:
  - Lombok
  - MapStruct
  - SLF4J
  - JUnit e Mockito
  - Spring Boot
  - Spring WebFlux
  - Spring Kafka
  - SpringDoc OpenAPI
  - MySQL Connector
- Checkstyle com regras específicas
- Configuração de formatação com Spotless (Google Java Format)
- Makefile com comandos: install, up, down, clean, help

## Comandos úteis após a criação do projeto

1. `make install` - Instala dependências e compila o projeto
2. `make up` - Inicia o ambiente local com Docker Compose
3. `make down` - Para e remove containers
4. `make clean` - Limpa o projeto
5. `make help` - Mostra todos os comandos disponíveis