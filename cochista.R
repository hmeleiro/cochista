cochista <- function(ruta = "~/coches.csv", paginas) {
  start <- Sys.time()
  
  list.of.packages <- c("tidyverse", "rvest", "httr")
  new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
  if(length(new.packages)>0) {install.packages(new.packages)}
  
  library(tidyverse)
  library(rvest)
  library(httr)
  
  
  desktop_agents <-  c('Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.99 Safari/537.36',
                       'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.99 Safari/537.36',
                       'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.99 Safari/537.36',
                       'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/602.2.14 (KHTML, like Gecko) Version/10.0.1 Safari/602.2.14',
                       'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36',
                       'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.98 Safari/537.36',
                       'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.98 Safari/537.36',
                       'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36',
                       'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.99 Safari/537.36',
                       'Mozilla/5.0 (Windows NT 10.0; WOW64; rv:50.0) Gecko/20100101 Firefox/50.0')
  
  
  line <- data.frame("Titulo", "Marca", "Precio", "Provincia", "Motor", "Año", "Kilometros", "Fecha subida","Link")
  write.table(line, file = ruta, sep = ",", append = TRUE, quote = TRUE, col.names = FALSE, row.names = FALSE, na = "")
  
  
  for (counter in (1:paginas)) {
    url <- paste0("https://www.coches.net/segunda-mano/?pg=", as.character(counter))
    print(url)
    
    x <- GET(url, add_headers('user-agent' = desktop_agents[sample(1:10, 1)]))
    bloque <- x %>% read_html() %>% html_nodes(".mt-Card-body")
    
    for (p in (1:length(bloque))) {
      titulo <- bloque[p] %>% html_nodes(".mt-CardAd-title .mt-CardAd-titleHiglight") %>% html_text()
      marca <- str_split(string = titulo, pattern = " ")[[1]][1]
      
      precio <- bloque[p] %>% html_nodes(".mt-CardAd-price .mt-CardAd-titleHiglight") %>% html_text()
      precio <- str_replace(string = precio, pattern = " €", replacement = "")
      precio <- str_replace(string = precio, pattern = "\\.", replacement = "")
      precio <- as.numeric(precio)
      
      info <- bloque[p] %>% html_nodes(".mt-CardAd-attribute") %>% html_text()
      prov <- info[1]
      motor <- info[2]
      año <- info[3]
      
      km <- info[4]
      km <- str_replace(string = km, pattern = "\\.", replacement = "")
      km <- as.numeric((str_replace(string = km, pattern = " km", replacement = "")))
      
      fechasubida <- bloque[p] %>% html_nodes(".mt-CardAdDate-time") %>% html_text()
      
      link <- bloque[p] %>% html_nodes(".mt-CardAd-link") %>% html_attr(name = "href")
      link <- paste0("https://www.coches.net", link[1])
      
      print(paste(titulo, marca, precio, prov, motor, año, km, fechasubida, link))
      line <- data.frame(titulo, marca, precio, prov, motor, año, km, fechasubida, link)
      write.table(line, file = ruta, sep = ",", append = TRUE, quote = TRUE, col.names = FALSE, row.names = FALSE, na = "")
    }
  }
  
  end <- Sys.time()
  diff <- end - start
  print(paste("Cochisto ha descargado el 100% de los anuncios en", diff))
}
