library(tidytext)

sentiments

get_sentiments("afinn")
get_sentiments("nrc")
get_sentiments("bing")

sherlock_works <- gutenberg_download(1661)

sherlock <- sherlock_works %>%
  mutate(story = ifelse(str_detect(text,"ADVENTURE"),text,NA)) %>%
  fill(story) %>%
  filter(story!= "THE ADVENTURES OF SHERLOCK HOLMES") %>%
  mutate(story = factor(story, levels = unique(story)))

td_sherlock <- sherlock %>%
  mutate(line = row_number()) %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words)

nrc_keyword <- get_sentiments("nrc") %>% 
  filter(sentiment == "fear")

td_sherlock %>%
  filter(story == "ADVENTURE I. A SCANDAL IN BOHEMIA") %>%
  inner_join(nrc_keyword) %>%
  count(word, sort = TRUE)


sherlock_sentiment <- td_sherlock %>%
  inner_join(get_sentiments("bing")) %>%
  count(story, index = line %/% 10, sentiment) %>%
  spread(sentiment, n, fill = 0) %>%
  mutate(sentiment = positive - negative)

ggplot(sherlock_sentiment, aes(index, sentiment, fill = story)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~story, ncol = 2, scales = "free_x")




sent_word_counts <- td_sherlock %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort = TRUE) %>%
  ungroup()

sent_word_counts %>%
  group_by(sentiment) %>%
  top_n(10) %>%
  ungroup() %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n, fill = sentiment)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~sentiment, scales = "free_y") +
  labs(y = "Contribution to sentiment",
       x = NULL) +
  coord_flip()


library(wordcloud)

td_sherlock %>%
  anti_join(stop_words) %>%
  count(word) %>%
  with(wordcloud(word, n, max.words = 100))
