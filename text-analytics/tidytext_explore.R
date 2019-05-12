library(gutenbergr)
library(dplyr)
library(tidyr)
library(stringr)
library(tidytext)
library(ggplot2)
library(stm)
library(quanteda)
library(twitteR)
library(quanteda)



works <- gutenberg_works()
unique(works$author)


sherlock_works <- gutenberg_download(1661)

sherlock_works %>%
  mutate(stry = ifelse(str_detect(text,"ADVENTURE"),text,NA)) %>%
  count(stry)

sherlock <- sherlock_works %>%
  mutate(story = ifelse(str_detect(text,"ADVENTURE"),text,NA)) %>%
  fill(story) %>%
  filter(story!= "THE ADVENTURES OF SHERLOCK HOLMES") %>%
  mutate(story = factor(story, levels = unique(story)))

td_sherlock <- sherlock %>%
  mutate(line = row_number()) %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words)

td_sherlock %>% count(word, sort=T)
td_sherlock <- td_sherlock %>% filter(word != "holmes")
td_sherlock %>% count(word, sort=T)
td_sherlock %>% count(story, word, sort=T)

tf_idf <- td_sherlock %>%
  count(story, word, sort=T) %>%
  bind_tf_idf(word, story, n) %>%
  group_by(story) %>%
  top_n(10) %>%
  ungroup %>%
  mutate(word = reorder(word, tf_idf))

ggplot(tf_idf,aes(word, tf_idf, fill = story)) + 
  geom_col(show.legend = F) +
  facet_wrap(~ story, scales= "free")+
  coord_flip()


sherlock_dfm <- td_sherlock %>%
  count(story, word, sort = T) %>%
  cast_dfm(story, word, n)


topic_model <- stm(sherlock_dfm, K=6, init.type = "Spectral")
summary(topic_model)


td_beta <- tidy(topic_model)

topic <- td_beta %>%
  group_by(topic) %>%
  top_n(10) %>%
  ungroup %>%
  mutate(term = reorder(term, beta))
  
ggplot(topic, aes(term, beta, fill=topic))+
  geom_col(show.legend = F)+
  facet_wrap(~topic, scales = "free")+
  coord_flip()


td_gamma <- tidy(topic_model, matrix="gamma",
                 document_names = rownames(sherlock_dfm))

ggplot(td_gamma, aes(gamma, fill=as.factor(topic)))+
  geom_histogram(show.legend = F)+
  facet_wrap(~ topic, ncol=3)
