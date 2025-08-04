############################
# BOT E LOCALE (pt_BR)
############################
resource "aws_lexv2models_bot" "bot" {
  name                        = var.bot_name
  role_arn                    = aws_iam_role.lex_runtime.arn
  description                 = "Bot de agendamento criado via Terraform"
  idle_session_ttl_in_seconds = 300

  data_privacy {
    child_directed = false
  }

  # test_bot_alias_settings { enabled = true } # não suportado atualmente
}

resource "aws_lexv2models_bot_locale" "ptbr" {
  bot_id      = aws_lexv2models_bot.bot.id
  bot_version = "DRAFT"
  locale_id   = "pt_BR"
  n_lu_intent_confidence_threshold = 0.4

  voice_settings {
    voice_id = "Camila"
  }
}

############################
# INTENT PRINCIPAL
############################
resource "aws_lexv2models_intent" "schedule" {
  bot_id      = aws_lexv2models_bot.bot.id
  bot_version = "DRAFT"
  locale_id   = aws_lexv2models_bot_locale.ptbr.locale_id
  name        = "AgendarHorario"
  description = "Coleta data, horário e local e aciona a Lambda"
  

  sample_utterance {
    utterance = "Quero agendar para {date} às {time} em {location}"
  }
  sample_utterance {
    utterance = "Agende {date} às {time} no {location}"
  }

  fulfillment_code_hook {
    enabled = true
  }
}

###############################################
# SLOT - DATE
###############################################
resource "aws_lexv2models_slot" "date" {
  name         = "date"
  bot_id       = aws_lexv2models_bot.bot.id
  bot_version  = "DRAFT"
  locale_id    = aws_lexv2models_bot_locale.ptbr.locale_id
  intent_id    = aws_lexv2models_intent.schedule.intent_id
  slot_type_id = "AMAZON.Date"

  value_elicitation_setting {
    slot_constraint = "Required"

    prompt_specification {
      allow_interrupt            = true
      max_retries                = 2
      message_selection_strategy = "Ordered"

      message_group {
        message {
          plain_text_message {
            value = "Qual data deseja?"
          }
        }
      }
    }
  }
}

###############################################
# SLOT - TIME
###############################################
resource "aws_lexv2models_slot" "time" {
  name         = "time"
  bot_id       = aws_lexv2models_bot.bot.id
  bot_version  = "DRAFT"
  locale_id    = aws_lexv2models_bot_locale.ptbr.locale_id
  intent_id    = aws_lexv2models_intent.schedule.intent_id
  slot_type_id = "AMAZON.Time"

  value_elicitation_setting {
    slot_constraint = "Required"

    prompt_specification {
      allow_interrupt            = true
      max_retries                = 2
      message_selection_strategy = "Ordered"

      message_group {
        message {
          plain_text_message {
            value = "Qual horário deseja?"
          }
        }
      }
    }
  }
}

###############################################
# SLOT - LOCATION
###############################################
resource "aws_lexv2models_slot" "location" {
  name         = "location"
  bot_id       = aws_lexv2models_bot.bot.id
  bot_version  = "DRAFT"
  locale_id    = aws_lexv2models_bot_locale.ptbr.locale_id
  intent_id    = aws_lexv2models_intent.schedule.intent_id
  slot_type_id = "AMAZON.City"

  value_elicitation_setting {
    slot_constraint = "Required"

    prompt_specification {
      allow_interrupt            = true
      max_retries                = 2
      message_selection_strategy = "Ordered"

      message_group {
        message {
          plain_text_message {
            value = "Qual cidade será o agendamento?"
          }
        }
      }
    }
  }
}


############################
# PUBLICAÇÃO (sem alias)
############################
# resource "aws_lexv2models_bot_version" "v1" {
#   bot_id = aws_lexv2models_bot.bot.id

#   locale_specification = {
#     "pt_BR" = {
#       source_bot_version = "DRAFT"
#     }
#   }

#   description = "Versão 1 publicada via Terraform"
# }

############################
# PERMISSÃO PARA INVOCAR LAMBDA
############################
resource "aws_lambda_permission" "allow_lex" {
  statement_id  = "AllowExecutionFromLex"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_arn
  principal     = "lex.amazonaws.com"
  # Dica: após publicar uma versão e criar alias manual no console, atualize o source_arn:
  # source_arn = "arn:aws:lex:us-east-1:123456789012:bot-alias/ALIAS_ID"
}