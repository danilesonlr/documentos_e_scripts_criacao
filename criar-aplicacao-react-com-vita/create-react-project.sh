#!/bin/bash

# Script para criação de projeto React com Vite
echo "=== React Project Generator ==="
echo ""

# Pedir o nome do projeto
read -p "Nome do projeto: " PROJECT_NAME

if [ -z "$PROJECT_NAME" ]; then
  echo "Erro: O nome do projeto não pode estar vazio"
  exit 1
fi

# Perguntar sobre o framework
echo ""
echo "Qual framework?"
echo "1 - React + JavaScript"
echo "2 - React + TypeScript"
read -p "Escolha (padrão 1): " FRAMEWORK_CHOICE

case $FRAMEWORK_CHOICE in
  2)
    FRAMEWORK="typescript"
    ;;
  *)
    FRAMEWORK="javascript"
    ;;
esac

# Perguntar sobre a arquitetura
echo ""
echo "Qual arquitetura?"
echo "1 - MVC"
echo "2 - Clean Architecture"
echo "3 - Feature First"
echo "4 - Clean + DDD (Recomendado)"
read -p "Escolha (padrão 2): " ARCHITECTURE_CHOICE

case $ARCHITECTURE_CHOICE in
  1)
    ARCHITECTURE="mvc"
    ;;
  3)
    ARCHITECTURE="feature-first"
    ;;
  4)
    ARCHITECTURE="clean-ddd"
    ;;
  *)
    ARCHITECTURE="clean"
    ;;
esac

# Perguntar sobre a biblioteca de UI
echo ""
echo "Qual biblioteca de UI?"
echo "1 - Material UI"
echo "2 - Ant Design"
echo "3 - Tailwind CSS"
echo "4 - Bootstrap"
read -p "Escolha (padrão 3): " UI_CHOICE

case $UI_CHOICE in
  1)
    UI_LIBRARY="material-ui"
    ;;
  2)
    UI_LIBRARY="ant-design"
    ;;
  3)
    UI_LIBRARY="tailwind"
    ;;
  4)
    UI_LIBRARY="bootstrap"
    ;;
  *)
    UI_LIBRARY="tailwind"
    ;;
esac

# Perguntar sobre o gerenciamento de estado
echo ""
echo "Gerenciamento de estado?"
echo "1 - Context API"
echo "2 - Redux Toolkit"
echo "3 - Zustand"
echo "4 - Nenhum"
read -p "Escolha (padrão 1): " STATE_MANAGEMENT_CHOICE

case $STATE_MANAGEMENT_CHOICE in
  2)
    STATE_MANAGEMENT="redux"
    ;;
  3)
    STATE_MANAGEMENT="zustand"
    ;;
  4)
    STATE_MANAGEMENT="none"
    ;;
  *)
    STATE_MANAGEMENT="context"
    ;;
esac

# Perguntar sobre autenticação JWT
echo ""
read -p "Instalar autenticação JWT? [S/n] " JWT_CHOICE
JWT_INSTALL=${JWT_CHOICE:-S}

# Perguntar sobre React Query
echo ""
read -p "Instalar React Query? [S/n] " QUERY_CHOICE
QUERY_INSTALL=${QUERY_CHOICE:-S}

# Perguntar sobre Docker
echo ""
read -p "Criar Dockerfile? [S/n] " DOCKER_CHOICE
DOCKER_INSTALL=${DOCKER_CHOICE:-S}

# Perguntar sobre GitHub Actions
echo ""
read -p "Criar GitHub Actions? [S/n] " GITHUB_CHOICE
GITHUB_INSTALL=${GITHUB_CHOICE:-S}

echo ""
echo "Criando projeto \"$PROJECT_NAME\" com as seguintes configurações:"
echo "- Framework: $FRAMEWORK"
echo "- Arquitetura: $ARCHITECTURE"
echo "- UI Library: $UI_LIBRARY"
echo "- Gerenciamento de estado: $STATE_MANAGEMENT"
echo "- JWT: ${JWT_INSTALL:-S}"
echo "- React Query: ${QUERY_INSTALL:-S}"
echo "- Docker: ${DOCKER_INSTALL:-S}"
echo "- GitHub Actions: ${GITHUB_INSTALL:-S}"
echo ""

# Criar o diretório do projeto
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

# Criar projeto com Vite usando o framework escolhido
if [ "$FRAMEWORK" = "typescript" ]; then
  echo "Criando projeto React TypeScript com Vite..."
  npm create vite@latest . -- --template react-ts --skip-typescript-prompt
else
  echo "Criando projeto React JavaScript com Vite..."
  npm create vite@latest . -- --template react --skip-typescript-prompt
fi

# Instalar dependências padrão
echo "Instalando dependências..."
npm install

# Instalar dependências de UI
case $UI_LIBRARY in
  "material-ui")
    npm install @mui/material @emotion/react @emotion/styled
    ;;
  "ant-design")
    npm install antd
    ;;
  "tailwind")
    npm install -D tailwindcss postcss autoprefixer
    npx tailwindcss init -p
    ;;
  "bootstrap")
    npm install bootstrap
    ;;
esac

# Instalar dependências de estado
case $STATE_MANAGEMENT in
  "redux")
    npm install @reduxjs/toolkit react-redux
    ;;
  "zustand")
    npm install zustand
    ;;
  *)
    # Nenhum gerenciamento de estado adicional necessário
    ;;
esac

# Instalar dependências adicionais se solicitadas
if [ "${JWT_INSTALL:-S}" = "S" ]; then
  npm install jsonwebtoken axios
fi

if [ "${QUERY_INSTALL:-S}" = "S" ]; then
  npm install @tanstack/react-query
fi

# Criar a estrutura de pastas da arquitetura
echo "Criando estrutura de pastas..."
mkdir -p src/{app,application,domain,infrastructure,presentation/{pages,components,layouts,routes},shared}

# Criar arquivos base
echo "Criando arquivos base..."

# Criar main.jsx
cat > src/main.jsx <<EOF
import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App.jsx'
import './index.css'

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
)
EOF

# Criar App.jsx
cat > src/App.jsx <<EOF
import React from 'react'
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom'
import { Layout } from './presentation/layouts/Layout'
import Home from './presentation/pages/Home'
import About from './presentation/pages/About'

function App() {
  return (
    <Router>
      <Layout>
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/about" element={<About />} />
        </Routes>
      </Layout>
    </Router>
  )
}

export default App
EOF

# Criar arquivo de estilo global
cat > src/index.css <<EOF
/* Estilos globais */
body {
  margin: 0;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen',
    'Ubuntu', 'Cantarell', 'Fira Sans', 'Droid Sans', 'Helvetica Neue',
    sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  background-color: #f5f5f5;
}

code {
  font-family: source-code-pro, Menlo, Monaco, Consolas, 'Courier New',
    monospace;
}
EOF

# Criar estrutura de arquivos para Layout
mkdir -p src/presentation/layouts
cat > src/presentation/layouts/Layout.jsx <<EOF
import React from 'react'
import './Layout.css'

export const Layout = ({ children }) => {
  return (
    <div className="layout">
      <header className="layout-header">
        <h1>Meu Projeto</h1>
      </header>
      <main className="layout-main">
        {children}
      </main>
      <footer className="layout-footer">
        <p>&copy; 2026 Meu Projeto</p>
      </footer>
    </div>
  )
}
EOF

cat > src/presentation/layouts/Layout.css <<EOF
.layout {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.layout-header {
  background-color: #282c34;
  padding: 1rem;
  color: white;
  text-align: center;
}

.layout-main {
  flex: 1;
  padding: 2rem;
}

.layout-footer {
  background-color: #282c34;
  padding: 1rem;
  color: white;
  text-align: center;
}
EOF

# Criar páginas de exemplo
mkdir -p src/presentation/pages
cat > src/presentation/pages/Home.jsx <<EOF
import React from 'react'
import './Home.css'

export const Home = () => {
  return (
    <div className="home">
      <h2>Página Inicial</h2>
      <p>Bem-vindo ao projeto React com Vite!</p>
    </div>
  )
}
EOF

cat > src/presentation/pages/Home.css <<EOF
.home {
  text-align: center;
}
EOF

cat > src/presentation/pages/About.jsx <<EOF
import React from 'react'
import './About.css'

export const About = () => {
  return (
    <div className="about">
      <h2>Sobre</h2>
      <p>Este é um projeto criado com o script de geração automática.</p>
    </div>
  )
}
EOF

cat > src/presentation/pages/About.css <<EOF
.about {
  text-align: center;
}
EOF

# Criar componentes de exemplo
mkdir -p src/presentation/components
cat > src/presentation/components/Button.jsx <<EOF
import React from 'react'
import './Button.css'

export const Button = ({ children, onClick, variant = 'primary' }) => {
  return (
    <button className={`btn btn-${variant}`} onClick={onClick}>
      {children}
    </button>
  )
}
EOF

cat > src/presentation/components/Button.css <<EOF
.btn {
  padding: 0.5rem 1rem;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 1rem;
}

.btn-primary {
  background-color: #007bff;
  color: white;
}

.btn-secondary {
  background-color: #6c757d;
  color: white;
}
EOF

# Criar configurações ESLint, Prettier e EditorConfig
echo "Configurando ESLint, Prettier e EditorConfig..."

# Instalar dependências do ESLint
npm install -D eslint eslint-plugin-react eslint-plugin-react-hooks eslint-plugin-import eslint-plugin-jsx-a11y --save-exact

# Criar arquivo .eslintrc.json
cat > .eslintrc.json <<EOF
{
  "extends": [
    "eslint:recommended",
    "plugin:react/recommended",
    "plugin:react-hooks/recommended"
  ],
  "settings": {
    "react": {
      "version": "detect"
    }
  },
  "rules": {
    "react/react-in-jsx-scope": "off"
  }
}
EOF

# Criar arquivo .prettierrc
cat > .prettierrc <<EOF
{
  "semi": true,
  "singleQuote": true,
  "trailingComma": "es5",
  "printWidth": 80,
  "tabWidth": 2,
  "useTabs": false,
  "bracketSpacing": true,
  "arrowParens": "avoid"
}
EOF

# Criar arquivo .editorconfig
cat > .editorconfig <<EOF
root = true

[*]
charset = utf-8
end_of_line = lf
indent_size = 2
indent_style = space
insert_final_newline = true
trim_trailing_whitespace = true
max_line_length = 80

[*.md]
trim_trailing_whitespace = false
EOF

# Criar aliases no vite.config.js
echo "Configurando aliases..."

# Adicionar alias ao arquivo vite.config.js existente
if [ -f "vite.config.js" ]; then
  sed -i '1i import { defineConfig } from \"vite\"\nimport react from \"@vitejs/plugin-react\"\nimport path from \"path\"\n\n// https://vitejs.dev/config/' vite.config.js
  
  # Adicionar o alias do projeto
  sed -i '/defineConfig/s/)/,\n  resolve: {\n    alias: {\n      \"@\": path.resolve(__dirname, \"src\"),\n      \"@\/components\": path.resolve(__dirname, \"src\/presentation\/components\"),\n      \"@\/pages\": path.resolve(__dirname, \"src\/presentation\/pages\"),\n      \"@\/layouts\": path.resolve(__dirname, \"src\/presentation\/layouts\"),\n      \"@\/routes\": path.resolve(__dirname, \"src\/presentation\/routes\")\n    }\n  }\n})/' vite.config.js
fi

# Criar arquivo README.md
cat > README.md <<EOF
# $PROJECT_NAME

Este projeto foi criado com Vite e segue uma estrutura de arquitetura baseada em Clean Architecture para React.

## Estrutura do Projeto

- \`src/\` - Código fonte principal
  - \`app/\` - Camada de aplicação
  - \`application/\` - Lógica de negócios
  - \`domain/\` - Domínio da aplicação
  - \`infrastructure/\` - Componentes infraestruturais
  - \`presentation/\` - Camada de apresentação
    - \`pages/\` - Páginas da aplicação
    - \`components/\` - Componentes reutilizáveis
    - \`layouts/\` - Layouts da aplicação
    - \`routes/\` - Definições de rotas

## Dependências Instaladas

- React
- React Router DOM
- ESLint
- Prettier
- EditorConfig

## Scripts Disponíveis

- \`npm run dev\` - Iniciar servidor de desenvolvimento
- \`npm run build\` - Build para produção
- \`npm run preview\` - Visualizar build localmente
- \`npm run lint\` - Rodar ESLint

## Configurações

- ESLint configurado com regras recomendadas para React
- Prettier configurado com padrão de estilo
- EditorConfig com configurações padrão

## Comandos Úteis

Para executar o projeto:

\`\`\`bash
npm run dev
\`\`\`

Para build:

\`\`\`bash
npm run build
\`\`\`

Para lint:

\`\`\`bash
npm run lint
\`\`\`
EOF

# Criar arquivo .gitignore
cat > .gitignore <<EOF
# Logs
logs
*.log
npm-debug.log
yarn-debug.log
yarn-error.log
pnpm-debug.log

# Runtime data
pids
*.pid
*.seed
*.dat

# Dependency directories
node_modules/
jspm_packages/

# Optional npm cache directory
.npm

# Optional eslint cache
.eslintcache

# Optional type definition files
*.d.ts

# Build directory
dist/

# Environment variables
.env.local
.env.*.local

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Package
package-lock.json
yarn.lock

# Editor
*.tmp
EOF

# Inicializar repositório Git e fazer o primeiro commit
echo "Inicializando repositório Git..."
git init
git add .
git commit -m "feat: inicializa projeto React com Vite"

# Criar Dockerfile se solicitado
if [ "${DOCKER_INSTALL:-S}" = "S" ]; then
  echo "Criando Dockerfile..."
  cat > Dockerfile <<EOF
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 5173

CMD ["npm", "run", "dev"]
EOF
fi

# Criar GitHub Actions se solicitado
if [ "${GITHUB_INSTALL:-S}" = "S" ]; then
  echo "Criando GitHub Actions..."
  mkdir -p .github/workflows
  
  cat > .github/workflows/main.yml <<EOF
name: CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v3

    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'
        cache: 'npm'

    - name: Install dependencies
      run: npm install

    - name: Build project
      run: npm run build

    - name: Run tests
      run: npm test
EOF
fi

echo ""
echo "Projeto criado com sucesso!"
echo "Estrutura do projeto:"
find . -type f -not -path "./.git/*" | sort | sed 's/^/  /'
echo ""
echo "Para começar:"
echo "1. Execute: npm run dev"
echo "2. Acesse: http://localhost:5173/"