# install.packages("openai")
# install.packages("gptstudio")

#### gptstudio ----

# this is needed both for gptstudio and the openai API calls:
Sys.setenv(
  OPENAI_API_KEY = ''
)

#### OpenAI API ----

library(openai)

output <- create_chat_completion(
  model = "gpt-3.5-turbo",
  temperature = 1,
  max_tokens = 5,
  messages = list(
    list(
      "role" = "user",
      "content" = "Classify this tweet as toxic or non-toxic. Tweet: \"Yo mama is stupid\" Label:"
    )
  )
)

#### OpenAI API using custom httr calls ----

library(tidyverse)
library(httr)
library(jsonlite)


# GPT API call setup
base_url <- "https://api.openai.com/v1/chat/completions"

headers <- c(Authorization = paste("Bearer", Sys.getenv("OPENAI_API_KEY")), 
             `Content-Type` = "application/json")
body <- list()

body[["model"]] <- "gpt-3.5-turbo"
body[["max_tokens"]] <- 4
body[["temperature"]] <- 0.7

prompt <- "Label as \"politics\" or \"entertainment\". \nText: \"I love watching TV!\"
                   Label:"
messages <- list(list(role = "user", content = prompt))

body[["messages"]] <- messages

# this looks like this now:
body

# request and store response
response <- POST(url = base_url, 
                 add_headers(.headers = headers), 
                 body = toJSON(body, auto_unbox = T), encode = "json")
# format response:
completion <- response %>% 
  content(as = "text", encoding = "UTF-8") %>% 
  fromJSON(flatten = TRUE)

completion$choices["message.content"]

  