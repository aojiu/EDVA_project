library(rvest)
library(stringr)
library(robotstxt)

opentable_data<-data.frame(
  "restaurant_name"=c(),
  "price"=c(),
  "rating"=c(),
  "num_reviews"=c(),
  "cuisine_type"=c()
)

for (i in 1:2){
  num=toString(i)
  
  url="https://www.opentable.com/lolz-view-all/H4sIAAAAAAAAAKtWMlKyUjIyMDLQNTTUNTQPMTC1MjG3MjBQ0lEyRpEBCpgABQyNrYwNIPKmSlZGOkpmQEETAz1zEwtzQx1dc2M9SwtTc1MLoLwFUCbANSjY38_RxzPKNSg-MNQ1KBIoYQmUUPYvLUnJzy9yyczLzEsHChoCrYuOBdJAW9ISc4pTawGM9sgdnAAAAA==?originid=29312f32-b784-4bee-bc02-4b9f1a4d605b&page=#&corrid=c5eedacc-3be6-448a-b6c6-a86d59f570a6"
  
  str_replace(url,"[#]",num)
  paths_allowed(url)
  webpage <- read_html(url)
  
  restaurant_name <- read_html(url)%>% 
    html_nodes('.k8o46Bca35RzHNtQFy3bH') %>% 
    html_text() %>% 
    substring(first=5)
  
  
  cuisine_type <- read_html(url)%>% 
    html_nodes('._2p0jcmKJSDjEh-wNrLIpzJ') %>% 
    html_text()
  
  
  # get reverse price
  # 4-reverse price gives the true price($$$$)
  price <- 4-read_html(url)%>% 
    html_nodes('._1s81GB3gesncA-230LO-_w')%>%
    html_text()%>%
    str_length()
  
  rating <- read_html(url)%>% 
    html_nodes('._3vuCAUg_pskwYkQfEGhnPy')%>%
    html_text()
  
  
  num_reviews <- read_html(url)%>% 
    html_nodes('._37NqKSTDkDYtsJrAU287ai')%>%
    html_text()
  num_reviews <- substring(num_reviews, first=2, last=str_length(num_reviews)-1)
  
  
  
  sub_opentable_data<-data.frame(
    "restaurant_name"=restaurant_name,
    "price"=price,
    "rating"=rating,
    "num_reviews"=num_reviews,
    "cuisine_type"=cuisine_type
  )
  
  opentable_data<-rbind(opentable_data, sub_opentable_data)
}

write.csv(opentable_data, "./opentable.csv")