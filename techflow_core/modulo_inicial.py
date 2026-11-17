
# ==============================================================================
# PROJETO TECHFLOW CORE - MODULO DE AUTENTICACAO E REQUISICOES
# Boas Praticas: Nomenclatura expressiva e PEP 8
# ==============================================================================

def executar_sistema():
    print("--- SISTEMA TECHFLOW CORE - PAINEL INICIAL ---")

    # 1. Declaracao de Variaveis e Tipos Primitivos
    tentativas_maximas = 3
    tentativas_atuais = 0
    usuario_autenticado = False

    usuario_correto = "admin_techflow"
    senha_correta = "senha123"

    # 2. Estrutura de Repeticao para Autenticacao
    while tentativas_atuais < tentativas_maximas and not usuario_autenticado:

        print(f"\n[Tentativa {tentativas_atuais + 1} de {tentativas_maximas}]")

        usuario_input = input("Informe o nome de usuario: ").strip()
        senha_input = input("Informe a senha de acesso: ").strip()

        # 3. Estruturas Condicionais
        if not usuario_input or not senha_input:
            print("Aviso: Nenhum campo pode ficar em branco!")
            tentativas_atuais += 1

        elif usuario_input == usuario_correto and senha_input == senha_correta:
            usuario_autenticado = True
            print("\nSucesso: Acesso concedido! Bem-vindo ao TechFlow Core.")

        else:
            print("Erro: Usuario ou senha incorretos.")
            tentativas_atuais += 1

    # 4. Fluxo Pos-Autenticacao
    if usuario_autenticado:
        executar_menu_principal()
    else:
        print("\nBloqueio: Excedeu o numero maximo de tentativas de acesso.")


def executar_menu_principal():
    executando = True

    # Estrutura de Repeticao para o Menu
    while executando:

        print("\n=== MENU DE OPCOES TECHFLOW ===")
        print("1 - Registrar Novo Chamado")
        print("2 - Listar Chamados Ativos")
        print("3 - Sair do Sistema")

        opcao = input("Selecione uma opcao (1-3): ").strip()

        if opcao == "1":
            titulo_chamado = input("Digite o titulo do chamado: ").strip()

            if len(titulo_chamado) >= 5:
                print(f"Sucesso: Chamado '{titulo_chamado}' registrado!")
            else:
                print("Aviso: O titulo deve ter pelo menos 5 caracteres.")

        elif opcao == "2":
            print("\nCarregando lista de chamados...")

            # Laco for simulando registros
            for i in range(1, 4):
                print(f" -> Chamado #00{i}: [Em Andamento]")

        elif opcao == "3":
            print("Encerrando sessao no TechFlow Core. Ate breve!")
            executando = False

        else:
            print("Aviso: Opcao invalida! Escolha um numero entre 1 e 3.")


# Execucao do Programa
if __name__ == "__main__":
    executar_sistema()
