---
trigger: always_on
---

Este guia define as diretrizes para desenvolvimento e manutenção de projetos Flutter baseados na arquitetura personalizada de Fernando Schmatz.

1. Contexto Geral do Projeto
   Framework: Flutter (Foco exclusivo em Android).
   Gerenciamento de Estado: async_redux.
   Banco de Dados: sqflite (Padrão DAO).
   Estilo de UI: Material 3, focado em dispositivos móveis, com suporte a temas dinâmicos (easy_dynamic_theme).

2. Estrutura de Pastas e Responsabilidades
   lib/dao/: Contém as classes DAO (ex: MovieDAO). Deve focar em consultas SQL puras e mapeamento Map<String, dynamic>.
   lib/service/: Camada intermediária que chama o DAO e converte dados brutos em Objetos de Entidade.
   lib/entity/: Modelos de dados (ex: Movie).
   lib/redux/: Contém app_state.dart, actions.dart, selectors.dart.
   lib/page/: Telas principais da aplicação.
   lib/widget/: Componentes reutilizáveis de UI.
   lib/util/: Constantes, strings globais e funções auxiliares.

3. Regras de Codificação - Redux (async_redux)
   Actions: Devem estender AppAction. Utilize os métodos before() para estados de loading, reduce() para a lógica principal e after() para finalizar processos.
   State: O AppState deve ser imutável, utilizando o método copyWith e possuir um initialState().
   UI Integration: Prefira usar o StoreConnector<AppState, VM> para conectar a UI ao estado. Use vm (view model) ou viewData (records) para passar dados ao builder.
   Selectors: Toda lógica de acesso ao estado que envolva filtros ou cálculos deve estar em selectors.dart.

4. Regras de Banco de Dados (sqflite)
   DAO Pattern: Implemente como Singleton (instance).
   Mapeamento: Entidades devem ter métodos fromMap e toMap.
   SQL: Consultas complexas devem ser feitas via db.rawQuery.
   Backups: Sempre mantenha métodos utilitários para exportação/importação de dados (geralmente em util/backup_utils.dart).

5. Estilo de UI e Widgets
   Material 3: Use Theme.of(context).colorScheme e tokens modernos como surfaceContainerHigh.
   Componentização: Widgets pequenos e específicos em lib/widget/ (ex: RuntimeChip, MovieCard).
   Animações: Use AnimatedSwitcher para transições de estado (ex: de Loading para Lista).
   Feedback: Use fluttertoast para notificações rápidas ao usuário.

6. Manipulação de Datas e Strings
   Datas: Use obrigatoriamente a biblioteca jiffy para formatação (dd/MM/yyyy) e cálculos de datas.
   Strings: Centralize nomes de apps e chaves fixas em lib/util/app_details.dart e app_constants.dart.

7. Importações
   Prefira importações relativas (../redux/actions.dart) para arquivos dentro da pasta lib, exceto quando referenciando o main.dart ou packages externos.
