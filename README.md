# 🤖 Bot de Agendamento de Lutas – It's On Fight

Este projeto provisiona um bot conversacional Amazon Lex V2 com suporte ao idioma **Português (pt-BR)**, projetado para **agendar lutas** no sistema *It’s On Fight*. O bot coleta **data**, **horário** e **cidade** e aciona uma função Lambda para processar o agendamento.

> ⚙️ Automatizado com Terraform – infraestrutura como código

---

## 📦 Recursos provisionados

- **Bot principal Lex V2** (`aws_lexv2models_bot`)
- **Locale pt_BR com voz Camila** (`aws_lexv2models_bot_locale`)
- **Intent personalizada**: `AgendarHorario`
  - Ex: “Quero agendar para amanhã às 19h em São Paulo”
- **Slots obrigatórios**
  - `date` – tipo `AMAZON.Date`
  - `time` – tipo `AMAZON.Time`
  - `location` – tipo `AMAZON.City`
- **Ordem de preenchimento dos slots** via `aws_lexv2models_intent_slot`
- **Fulfillment com AWS Lambda**
- **Permissão para o Lex invocar a Lambda**
- **Versão publicada do bot Lex** (`v1`)

---

## 🧭 Estrutura do repositório

```
provisionar-lex/
├── lex.tf                   # Definição do bot, intents, slots e publicação
├── variables.tf             # Declaração das variáveis utilizadas
├── variables/hml.tfvars     # Variáveis para ambiente de homologação
├── backend.tf               # (se utilizado) configuração do backend remoto
├── README.md                # Documentação e instruções
```

---

## 🚀 Como executar (Terraform)

> ⚠️ Pré-requisitos:
> - AWS CLI configurado
> - Terraform ≥ 1.3.0
> - Lambda já provisionada (seu ARN será passado via `tfvars`)

### 1. Inicialize o Terraform

```bash
terraform init
```

### 2. Valide a sintaxe

```bash
terraform validate
```

### 3. Planeje a execução

```bash
terraform plan -var-file="./variables/hml.tfvars"
```

### 4. Aplique a infraestrutura

```bash
terraform apply -var-file="./variables/hml.tfvars"
```

---

## ✅ Próximos passos após provisionamento

1. **Criar manualmente um alias para testes no console do Lex**
   - Vá até o bot no console da AWS
   - Crie um alias com nome `test` (ou `hml`) apontando para a versão `v1`

2. **Teste o bot via console Lex**
   - Exemplo de comando:
     ```
     Quero agendar para amanhã às 20h em Belo Horizonte
     ```

3. **Verifique se a Lambda está sendo invocada**
   - Cheque os logs no **Amazon CloudWatch Logs**

4. **Integração futura**
   - O bot pode ser conectado com canais como Amazon Connect, Telegram, etc
