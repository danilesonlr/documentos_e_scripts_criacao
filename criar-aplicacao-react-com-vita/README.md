# Script de Criação de Projetos React com Vite

Este script é um utilitário automatizado para criar projetos React com Vite, configurando uma estrutura completa com várias tecnologias e ferramentas recomendadas para desenvolvimento moderno.

## Funcionalidades do Script

O script permite criar projetos React com diversas configurações personalizadas através de uma interface interativa que solicita:

1. **Nome do projeto**
2. **Framework**: JavaScript ou TypeScript
3. **Arquitetura**: MVC, Clean Architecture, Feature First ou Clean + DDD
4. **Biblioteca UI**: Material UI, Ant Design, Tailwind CSS ou Bootstrap
5. **Gerenciamento de estado**: Context API, Redux Toolkit, Zustand ou Nenhum
6. **Recursos adicionais**: Autenticação JWT, React Query, Docker e GitHub Actions

## Tecnologias Utilizadas

### 1. React
Framework base para desenvolvimento de interfaces de usuário com componentes reutilizáveis.

### 2. Vite
Ferramenta de build moderna que oferece um ambiente de desenvolvimento rápido com hot module replacement (HMR) e build otimizado para produção.

### 3. React Router DOM
Biblioteca para navegação entre páginas em aplicações React, permitindo criar SPA (Single Page Applications).

### 4. ESLint + Prettier + EditorConfig
- **ESLint**: Ferramenta de linting para manter qualidade e consistência do código
- **Prettier**: Formatador automático de código para padronização visual
- **EditorConfig**: Configuração de estilo de código entre diferentes editores

### 5. Bibliotecas UI
O script permite escolher entre várias bibliotecas UI:
- **Material UI**: Componentes de UI seguindo as diretrizes do Material Design
- **Ant Design**: Biblioteca completa com componentes ricos e customizáveis
- **Tailwind CSS**: Framework Utility-First para estilização rápida
- **Bootstrap**: Framework CSS completo com componentes responsivos

### 6. Gerenciamento de Estado
Diversas opções para gerenciamento de estado (contexto da aplicação):
- **Context API**: Recurso nativo do React para compartilhamento de estado
- **Redux Toolkit**: Biblioteca poderosa para gerenciamento de estado global
- **Zustand**: Alternativa leve e simples para gerenciamento de estado

### 7. Autenticação JWT
Integração opcional com JSON Web Tokens para autenticação segura de usuários.

### 8. React Query
Biblioteca para gerenciamento de dados assíncronos, incluindo cache automático, invalidação e atualização de dados.

### 9. Docker
Opção para criar um Dockerfile para containerização do aplicativo.

### 10. GitHub Actions
Configuração opcional para CI/CD com workflows automatizados de build, testes e deploy.

## Estrutura de Arquitetura

O script implementa uma estrutura de projeto baseada em Clean Architecture:

- `app/` - Camada de aplicação
- `application/` - Lógica de negócios
- `domain/` - Domínio da aplicação
- `infrastructure/` - Componentes infraestruturais
- `presentation/` - Camada de apresentação com:
  - `pages/` - Páginas da aplicação
  - `components/` - Componentes reutilizáveis
  - `layouts/` - Layouts da aplicação
  - `routes/` - Definições de rotas

## Comandos Disponíveis

Após a criação do projeto, os seguintes comandos estão disponíveis:

- `npm run dev` - Iniciar servidor de desenvolvimento
- `npm run build` - Build para produção
- `npm run preview` - Visualizar build localmente
- `npm run lint` - Rodar ESLint

## Personalização

O script foi projetado para ser flexível, permitindo combinar diferentes tecnologias e abordagens de desenvolvimento conforme as necessidades do projeto.