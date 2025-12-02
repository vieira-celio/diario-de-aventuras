# Especificação Técnica: Diário de Aventuras

## 1. Visão Geral e Objetivo do Projeto

O objetivo deste projeto é desenvolver um aplicativo móvel denominado **"Diário de Aventuras"** que permita aos usuários registrar e catalogar suas experiências e atividades de forma simples e intuitiva. O aplicativo deve focar na captura de dados essenciais, como título, descrição, data, localização e uma foto, utilizando a infraestrutura do **Google Firebase** para armazenamento e sincronização.

O código-fonte gerado pelo Agente de IA deve ser modular, bem comentado e seguir as melhores práticas de arquitetura, sendo adequado para fins didáticos e de fácil manutenção.

## 2. Requisitos Funcionais Detalhados

### 2.1. Usuário e Autenticação

O sistema deve gerenciar o ciclo de vida do usuário com segurança e privacidade.

| ID | Requisito Funcional | Detalhes Técnicos |
| :--- | :--- | :--- |
| RF-001 | **Criação de Conta** | Permitir que novos usuários se cadastrem utilizando um endereço de e-mail e uma senha. Deve utilizar o **Firebase Authentication**. |
| RF-002 | **Login** | Permitir que usuários existentes façam login com suas credenciais de e-mail e senha. |
| RF-003 | **Logout** | Fornecer uma funcionalidade de logout acessível a partir da interface principal do aplicativo. |
| RF-004 | **Proteção de Dados** | Implementar regras de segurança no **Firebase Firestore** e **Firebase Storage** para garantir que cada usuário possa apenas ler, escrever e modificar seus próprios registros de atividades e arquivos. |
| RF-005 | **Recuperação de Senha** | Implementar a funcionalidade de recuperação de senha via e-mail, utilizando o recurso nativo do Firebase Auth. |

### 2.2. Registro de Atividades (CRUD)0

O núcleo do aplicativo é o registro e a gestão das aventuras do usuário.

| ID | Requisito Funcional | Detalhes Técnicos |
| :--- | :--- | :--- |
| RF-006 | **Inserir Novo Registro** | Tela dedicada para a criação de um novo registro de aventura. |
| RF-007 | **Título da Atividade** | Campo de texto obrigatório para o título (máximo 100 caracteres). |
| RF-008 | **Descrição Opcional** | Campo de texto opcional para a descrição detalhada. |
| RF-009 | **Data e Hora** | Campo para seleção da data e hora da atividade. Deve ser preenchido automaticamente com a data e hora atuais, mas permitindo edição. |
| RF-010 | **Upload de Foto** | Permitir que o usuário selecione uma foto da galeria ou capture uma nova foto pela câmera. A foto deve ser enviada para o **Firebase Storage**. |
| RF-011 | **Registro de Localização** | Capturar automaticamente a localização (latitude e longitude) no momento da criação do registro. O dado deve ser armazenado no **Firebase Firestore** no formato `GeoPoint`. |
| RF-012 | **Listagem de Registros** | Exibir todos os registros do usuário em uma lista paginada ou com *lazy loading*. Cada item da lista deve mostrar o título, a data e uma miniatura da foto. |
| RF-013 | **Visualização de Detalhes** | Ao tocar em um item da lista, navegar para uma tela de detalhes que exiba todas as informações do registro, incluindo a foto em tamanho maior e a localização em um mapa (se possível, um mapa interativo). |
| RF-014 | **Edição de Registro** | Permitir a edição de todos os campos de texto (Título, Descrição, Data/Hora) de um registro existente. A edição da localização e da foto deve ser opcional. |
| RF-015 | **Exclusão de Registro** | Permitir a exclusão de um registro, incluindo a remoção da foto associada do **Firebase Storage**. |

## 3. Arquitetura e Tecnologias

### 3.1. Plataforma e Framework

* **Plataforma Android**
*   **Flutter (Dart)**


### 3.2. Estrutura de Dados (Firebase Firestore)

Todos os dados textuais e de localização devem ser armazenados em uma coleção principal no Firestore.

**Coleção:** `adventures`

| Campo | Tipo | Descrição | Regras de Segurança |
| :--- | :--- | :--- | :--- |
| `uid` | String | ID do usuário (do Firebase Auth). **Chave para proteção de dados.** | `request.auth.uid == resource.data.uid` |
| `title` | String | Título da aventura. | |
| `description` | String | Descrição detalhada (opcional). | |
| `timestamp` | Timestamp | Data e hora do registro. | |
| `location` | GeoPoint | Latitude e longitude da atividade. | |
| `photoUrl` | String | URL da foto no Firebase Storage. | |
| `createdAt` | Timestamp | Timestamp de criação do documento. | |

### 3.3. Armazenamento de Mídia (Firebase Storage)

As fotos devem ser armazenadas em um *bucket* dedicado, com a estrutura de pastas organizada por ID de usuário.

**Estrutura de Caminho:** `users/{uid}/adventures/{adventure_id}.jpg`

**Regras de Segurança:** Apenas o usuário proprietário (`uid`) pode ler, escrever e deletar arquivos dentro de sua pasta.

### 3.4. Boas Práticas e Arquitetura de Código

O código deve ser construído seguindo um padrão de arquitetura que promova a separação de responsabilidades, facilitando a manutenção e o entendimento didático.

*   **Separação de Camadas:**
    *   **UI/Views:** Responsável apenas pela renderização e captura de eventos do usuário.
    *   **Controller/ViewModel/Presenter:** Responsável pela lógica de apresentação, formatação de dados e gerenciamento de estado.
    *   **Repository/Service:** Responsável pela comunicação com o **Firebase (Firestore e Storage)**, abstraindo a fonte de dados da camada de lógica de negócios.
*   **Tratamento de Erros e Estados de Rede:**
    *   Implementar estados de UI claros para **Loading** (indicador de progresso), **Sucesso** (confirmação visual) e **Erro** (mensagens informativas ao usuário).
    *   O repositório de dados deve tratar exceções do Firebase e retornar resultados claros para a camada de *ViewModel*.
*   **Modularidade e Comentários:**
    *   O código deve ser dividido em módulos lógicos (e.g., `auth`, `adventures`, `core`).
    *   Todas as classes, métodos e funções complexas devem ser acompanhadas de comentários (`docstrings` ou similar) explicando sua finalidade, parâmetros de entrada e saída.

## 4. Requisitos Não Funcionais

| ID | Requisito Não Funcional | Descrição |
| :--- | :--- | :--- |
| RNF-001 | **Performance** | As operações de listagem de registros e upload de fotos devem ser otimizadas para garantir uma experiência fluida, mesmo com grandes volumes de dados. |
| RNF-002 | **Segurança** | As chaves de API e credenciais do Firebase devem ser tratadas de forma segura, sem exposição no código-fonte. As regras de segurança do Firebase devem ser rigorosamente testadas. |
| RNF-003 | **Sincronização** | A sincronização de dados entre o aplicativo e o Firestore deve ser automática e em tempo real (ou quase real), utilizando *listeners* do Firestore. |
| RNF-004 | **Testabilidade** | As camadas de lógica de negócios e repositório devem ser projetadas para serem facilmente testáveis (e.g., injeção de dependência). |
| RNF-005 | **Usabilidade** | A interface do usuário deve ser limpa, moderna e seguir as diretrizes de design da plataforma escolhida (Material Design ou Human Interface Guidelines). |

## 5. Tarefas do Agente de IA

O Agente de IA deve entregar:

1.  **Código-Fonte Completo** do aplicativo móvel, seguindo a arquitetura e os requisitos especificados.
2.  **Regras de Segurança do Firebase** (Firestore e Storage) prontas para serem aplicadas.
3.  **Documentação** de como configurar o ambiente Firebase e rodar o projeto.
4.  Um breve **Relatório de Arquitetura**, justificando a escolha da plataforma (Flutter ou React Native) e detalhando a estrutura de pastas implementada.


