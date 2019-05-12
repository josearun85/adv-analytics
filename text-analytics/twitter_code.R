library(twitteR)

consumer_key <- ""
consumer_secret <- ""
access_token <- ""
access_secret <- ""

setup_twitter_oauth(consumer_key, consumer_secret, access_token , access_secret)

tw = searchTwitter("#food",n=1000, since="2019-04-01")
df1 <- twListToDF(tw)
df1$source = "food"

tw = searchTwitter("#modi",n=1000, since="2019-04-01")
df2 <- twListToDF(tw)
df2$source = "modi"

df = rbind(df1,df2)

tweet_words <- df[,c("id","text")] %>% 
  unnest_tokens(word,text) %>%
  anti_join(stop_words)


tweet_words <- tweet_words %>% 
  count(id, word, sort = TRUE) %>%
  ungroup() %>% 
  rename(count=n) %>% 
  bind_tf_idf(word, id, count)

bag_of_words_dfm <- tweet_words %>% cast_dfm(id, word, count)
tfidf_dfm <- tweet_words %>% cast_dfm(id, word, tf_idf)

library(quanteda)
# fit mean difference classifier (AKA nearest centroid or nearest mean)

clf <- textmodel_nb(bag_of_words_dfm, df$source)
clf2 <- textmodel_nb(tfidf_dfm, df$source)

# get training predictions
pred1 <- predict(clf)
pred1

pred2 <- predict(clf2)
pred2

table(act=df$source,pred=pred1)
table(act=df$source,pred=pred2)

