#!/bin/bash

# Script para criação do projeto API First
echo "=== Criador de Projeto API First ==="
echo ""

# Pedir o nome do projeto
read -p "Digite o nome do projeto (ex: ms-banking-fee-management): " PROJECT_NAME

if [ -z "$PROJECT_NAME" ]; then
  echo "Erro: O nome do projeto não pode estar vazio"
  exit 1
fi

echo ""
# Pedir o nome do pacote
read -p "Digite o pacote do projeto (ex: br.com.api.first): " PACKAGE_NAME

if [ -z "$PACKAGE_NAME" ]; then
  echo "Erro: O pacote não pode estar vazio"
  exit 1
fi

if [ -z "$PACKAGE_NAME" ]; then
  echo "Erro: O pacote não pode estar vazio"
  exit 1
fi

echo ""
echo "Criando projeto \"$PROJECT_NAME\" com pacote: $PACKAGE_NAME"
echo ""

PACKAGE_PATH=$(echo "$PACKAGE_NAME" | tr '.' '/')

# Criar estrutura básica do projeto
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"


# Criar arquivos top-level
cat > build.gradle.kts <<EOF
import org.gradle.api.plugins.JavaPluginExtension
import org.gradle.api.tasks.testing.Test

plugins {
  id("com.diffplug.spotless") version "6.25.0" apply false
  id("org.sonarqube") version "6.3.1.5724"
  jacoco
}

allprojects {
  group = "$PACKAGE_NAME"
  version = "1.0.0"
}

subprojects {
  apply(plugin = "java-library")
  apply(plugin = "jacoco")

  tasks.withType<JacocoReport> {
    reports {
      xml.required.set(true)
      html.required.set(true)
      html.outputLocation = layout.buildDirectory.dir("reports/jacoco/html")
    }
  }

  extensions.configure<JavaPluginExtension> {
    toolchain.languageVersion.set(JavaLanguageVersion.of(21))
  }

  tasks.withType<Test>().configureEach {
    useJUnitPlatform()
  }

  dependencies {
    "implementation"("org.slf4j:slf4j-api:2.0.13")

    "testImplementation"("org.junit.jupiter:junit-jupiter:5.10.2")
    "testImplementation"("org.mockito:mockito-core:5.12.0")

    "compileOnly"("org.projectlombok:lombok:1.18.32")
    "annotationProcessor"("org.projectlombok:lombok:1.18.32")
    "testCompileOnly"("org.projectlombok:lombok:1.18.32")
    "testAnnotationProcessor"("org.projectlombok:lombok:1.18.32")

    "implementation"("org.mapstruct:mapstruct:1.5.5.Final")
    "annotationProcessor"("org.mapstruct:mapstruct-processor:1.5.5.Final")

    "implementation"("br.com.valecard.cross.utils:lib-cross-utils:1.3.1")
  }

  layout.buildDirectory.set(rootProject.layout.buildDirectory.dir(name))

  pluginManager.withPlugin("java") {
    apply(plugin = "com.diffplug.spotless")
    apply(plugin = "checkstyle")

    extensions.configure<com.diffplug.gradle.spotless.SpotlessExtension> {
      java {
        googleJavaFormat("1.22.0")
        formatAnnotations()
        removeUnusedImports()
        importOrder()
        target("**/*.java")
        targetExclude("src/main/java/**/dto/**/*.java")
      }

      kotlinGradle {
        target("**/*.gradle.kts")
        ktlint()
      }

      format("misc") {
        target("**/*.md", "**/.gitignore", "**/.editorconfig")
        indentWithSpaces(2)
        endWithNewline()
      }
    }

    extensions.configure<CheckstyleExtension> {
      toolVersion = "10.17.0"
      configDirectory.set(rootProject.layout.projectDirectory.dir("config/checkstyle"))
      isIgnoreFailures = false
      maxWarnings = 0
    }

    tasks.named("check") { dependsOn("spotlessCheck") }
  }
}
EOF

cat > settings.gradle.kts <<EOF
pluginManagement {
  repositories {
    gradlePluginPortal()
    mavenCentral()
  }
}

dependencyResolutionManagement {
  repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
  repositories {
    mavenLocal()
    mavenCentral()
    maven {
      url = uri("http://nexus-valecard-new.valecard.com.br:8081/repository/maven-releases/")
      isAllowInsecureProtocol = true
    }
    maven {
      url = uri("http://nexus-valecard-new.valecard.com.br:8081/repository/maven-snapshots/")
      isAllowInsecureProtocol = true
    }
  }
}

rootProject.name = "$PROJECT_NAME"

include(":domain", ":application", ":infrastructure")

project(":domain").projectDir = file("modules/domain")
project(":application").projectDir = file("modules/application")
project(":infrastructure").projectDir = file("modules/infrastructure")
EOF

cat > gradle.properties << 'EOF'
org.gradle.jvmargs=-Xmx2g -Dfile.encoding=UTF-8 --add-opens java.base/java.lang=ALL-UNNAMED
org.gradle.parallel=true
org.gradle.caching=true
EOF

cat > .gitignore << 'EOF'
# IDE
.idea/
*.iml
*.iws

# Gradle
.gradle/
build/
out/
*.jar
*.war
*.ear

# logs
*.log

# OS
.DS_Store
Thumbs.db

# Local config
local.properties
EOF

cat > .gitattributes << 'EOF'
# Set the default behaviour for all text files
* text=auto

# Explicitly declare line endings
*.md eol=lf
*.txt eol=lf
*.properties eol=lf
*.gradle eol=lf
*.xml eol=lf
EOF

# Criar diretórios
mkdir -p modules/domain/src/main/java/$PACKAGE_PATH
mkdir -p modules/application/src/main/java/$PACKAGE_PATH
mkdir -p modules/infrastructure/src/main/java/$PACKAGE_PATH

# Criar arquivos de build dos módulos
cat > modules/domain/build.gradle.kts << 'EOF'
plugins { `java-library` }
EOF

cat > modules/application/build.gradle.kts << 'EOF'
plugins { `java-library` }
dependencies { api(project(":domain")) }
EOF

cat > modules/infrastructure/build.gradle.kts << 'EOF'
import org.springframework.boot.gradle.tasks.bundling.BootJar

plugins {
    id("org.springframework.boot") version "3.3.3"
    id("io.spring.dependency-management") version "1.1.6"
    java
}

val springdocOpenapiVersion = "2.6.0"
val springCloudVersion = "2023.0.3"

dependencies {
    implementation(project(":application"))
    implementation(project(":domain"))

    implementation("org.springframework.boot:spring-boot-starter-web")
    implementation("org.springframework.boot:spring-boot-starter-validation")
    implementation("org.springframework.boot:spring-boot-starter-actuator")
    //implementation("org.springframework.boot:spring-boot-starter-data-jpa")
    implementation("org.springframework:spring-webflux")
    implementation("org.springframework.kafka:spring-kafka")
    //implementation("org.springframework.cloud:spring-cloud-starter-vault-config")
    //implementation(platform("org.springframework.cloud:spring-cloud-dependencies:$springCloudVersion"))

    implementation("org.springdoc:springdoc-openapi-starter-webmvc-ui:${springdocOpenapiVersion}")

    implementation("io.micrometer:micrometer-tracing")
    implementation("io.micrometer:micrometer-tracing-bridge-brave")

    runtimeOnly("com.mysql:mysql-connector-j")

    testImplementation("org.springframework.boot:spring-boot-starter-test")
    testImplementation("org.springframework.kafka:spring-kafka-test")

}

tasks {
    jar {
        enabled = false
    }
    bootJar {
        enabled = true
    }
}

tasks.named<BootJar>("bootJar") {
    archiveBaseName.set(rootProject.name)
    archiveVersion.set(project.version.toString())
    archiveClassifier.set("")
}
EOF

APPLICATION_CLASS=$(echo "$PROJECT_NAME" | \
  sed -r 's/(^|-)([a-z])/\U\2/g')Application

cat > modules/infrastructure/src/main/java/$PACKAGE_PATH/$APPLICATION_CLASS.java <<EOF
package $PACKAGE_NAME;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class $APPLICATION_CLASS {

    public static void main(String[] args) {
        SpringApplication.run($APPLICATION_CLASS.class, args);
    }
}
EOF

# Criar configurações de checkstyle
mkdir -p config/checkstyle
cat > config/checkstyle/checkstyle.xml << 'EOF'
<?xml version="1.0"?>
<!DOCTYPE module PUBLIC
        "-//Checkstyle//DTD Checkstyle Configuration 1.3//EN"
        "https://checkstyle.org/dtds/configuration_1_3.dtd">

<module name="Checker">
    <module name="TreeWalker">

        <!-- Evita imports com * -->
        <module name="AvoidStarImport"/>

        <!-- Impede imports "proibidos" (ajuste conforme empresa) -->
        <module name="IllegalImport">
            <property name="illegalPkgs" value="sun,com.sun"/>
        </module>

        <!-- Nomes consistentes (leve) -->
        <module name="MethodName"/>
        <module name="ParameterName"/>

        <!-- Braces básicos (o formatter já cuida do layout, aqui só sanity) -->
        <module name="NeedBraces"/>

        <!-- Opcional: limite de complexidade muito alto só pra flag outliers -->
        <module name="CyclomaticComplexity">
            <property name="max" value="20"/>
        </module>

        <!-- Evitar classes anônimas excessivas em lambdas simples -->
        <module name="AnonInnerLength">
            <property name="max" value="60"/>
        </module>

        <!-- NÃO colocar regras de whitespace/import order/line length:
             o Spotless/google-java-format já faz -->
    </module>
</module>
EOF

# Criar Makefile
cat > Makefile << 'EOF'
.PHONY: install up down clean help
.SILENT:

# Default target - install
install: ## Install project dependencies (default)
	./gradlew clean build --continue

up: ## Start local environment with Docker Compose
	docker-compose up -d

down: ## Stop and remove containers
	docker-compose down

clean: ## Clean project
	./gradlew clean

help: ## Show this help message
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_0-9.-]+:.*?## / {gsub("\\\\n",sprintf("\n%*s"," ",length(": "))); printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
EOF

# Criar docker-compose.yml
cat > docker-compose.yml << 'EOF'
version: '3.8'
services:
  mysql:
    image: mysql:8.0
    container_name: mysql
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: fee_management_db
    ports:
      - "3306:3306"
    volumes:
      - mysql_data:/var/lib/mysql

  redis:
    image: redis:7-alpine
    container_name: redis
    ports:
      - "6379:6379"

  wiremock:
    image: wiremock/wiremock:2.35.0
    container_name: wiremock
    ports:
      - "8089:8080"
    volumes:
      - ./config/wiremock:/home/wiremock

volumes:
  mysql_data:
EOF

# Criar diretórios de wiremock
mkdir -p config/wiremock/__files
mkdir -p config/wiremock/mappings

echo ""
echo "Projeto criado com sucesso!"
echo "Estrutura do projeto:"
find . -type f -not -path "./.git/*" | sort | sed 's/^/  /'
echo ""
echo "Para começar:"
echo "1. Execute: make install"
echo "2. Execute: make up"
