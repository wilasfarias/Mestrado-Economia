rm(list = ls())



#-------------------------------------------------------------------------#
?read.csv2
EXP <- subset("EXP_COMPLETA.csv", CO_ANO == "2000")
IMP <- subset(IMP_COMPLETA, CO_ANO == "2000")
setwd("C:/Users/Admin/Documents/MESTRADO/PRÉ-PROJETO/DADOS PRÉ-PROJETO/EXPORTAÇÃO")
setwd("F:/MESTRADO/PRÉ-PROJETO/DADOS PRÉ-PROJETO/EXPORTAÇÃO")

EXP_2000 <- read.csv2("EXP_2000.csv")
View(EXP_2000)
glimpse(EXP_2000)
class(EXP_2000)
summary(EXP_2000)
str(EXP_2000)


#--------------------------------------------------------------------------
# dados das exportações e importações
install.packages("xlsx", dependencies = TRUE)

library(tidyverse)
library(haven)
library(readr)
library(readxl)
library(openxlsx)
library(foreign)
library(readstata13)
library(survey)
library(ggplot2)
library(plogr)
library(descr)
library(readxl)
library(xlsx)


c <- within(c, {
  z <- Recode(a, '4=9; 2="z"', as.factor=TRUE)
})



#-------------------------------------------------------------------------#
options(scipen=999) # desativando notação ciêtífica

(PPI <- read_excel("TABELAS_AUXILIARES.xlsx", sheet = "8"))
(PPI <- PPI %>% select(CO_NCM, NO_NCM_POR))
PPI$CO_NCM <- as.factor(PPI$CO_NCM)
glimpse(PPI)

(PPE <- read_excel("TABELAS_AUXILIARES.xlsx", sheet = "9"))
(PPE <- PPE %>% select(CO_NCM, NO_NCM_POR))
PPE$CO_NCM <- as.factor(PPE$CO_NCM)


#-------------------------------------------------------------------------
# Índice de cada Produto da BC e Produtos Intraindustriais 2000:
# EXPORTAÇÃO
# criando base de dados anos 2000:
EXP_2000 <- read.csv2("EXP_2000.csv")
EXP_2000$CO_NCM <- as.factor(EXP_2000$CO_NCM)

# selecionar os produtos exportados:
EXP <- select(EXP_2000, CO_NCM, VL_FOB)
(EXP <- EXP %>% group_by(CO_NCM) %>% 
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

# renomear
(EXP <- rename(EXP, "EXP_VL_FOB"="VL_FOB"))
(EXP <- inner_join(EXP, PPE, by="CO_NCM"))


#-------------------------------------------#
# IMPORTAÇÕES:
# criando base de dados anos 2000:
IMP_2000 <- read.csv2("IMP_2000.csv")
IMP_2000$CO_NCM <- as.factor(IMP_2000$CO_NC)

# selecionar os produtos importados:
(IMP <- select(IMP_2000, CO_NCM, VL_FOB))
(IMP <- IMP %>% group_by(CO_NCM) %>% 
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

#-------------------------------------------#
# renomear
(IMP <- rename(IMP, "IMP_VL_FOB"="VL_FOB"))
(IMP <- inner_join(IMP, PPI, by="CO_NCM"))


(XM <- inner_join(EXP, IMP, by="CO_NCM"))
(XM <- XM %>% 
    group_by(CO_NCM,NO_NCM_POR.x,EXP_VL_FOB,IMP_VL_FOB) %>% 
    summarise(SOMA = (EXP_VL_FOB + IMP_VL_FOB)) %>% 
    arrange(desc(SOMA)))

rm(EXP_2000,IMP_2000)

#-------------------------------------------------------------------------#
# função para calcular o índice GL:
GL <- function(a,b){
  m <- data.frame(abs(a-b))       # modulo de "a" menos "b";
  s <- data.frame(a+b)            # soma de "a" mais "b";
  gl <- data.frame(((s-m)/s)*100)
  return(gl)
}

# calcular o índice de Grubel-Lloid (GL) 

(GL <- XM %>% group_by(CO_NCM) %>% 
    summarise(gl = (1-(abs(EXP_VL_FOB-IMP_VL_FOB)/SOMA))*100) %>% 
    arrange(desc(gl)))

(XM <- inner_join(XM, GL, by="CO_NCM"))

(XM <- XM %>% arrange(desc(EXP_VL_FOB)))

distinct(XM)
dim(XM)

XM <- as.data.frame(XM)

# exportar para o Excel:
## Exportando para um arquivo Excel:

write.xlsx(XM, "Índice GL Intraindustriais-2000.xlsx")

rm(EXP,GL,IMP,hs,XM)


#-------------------------------------------------------------------------
# Índice de cada Produto da BC e Produtos Intraindustriais 2005:
# EXPORTAÇÃO
# criando base de dados anos 2005:
EXP_2005 <- read.csv2("EXP_2005.csv")
EXP_2005$CO_NCM <- as.factor(EXP_2005$CO_NCM)

# selecionar os produtos exportados:
EXP <- select(EXP_2005, CO_NCM, VL_FOB)
(EXP <- EXP %>% group_by(CO_NCM) %>% 
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

# renomear
(EXP <- rename(EXP, "EXP_VL_FOB"="VL_FOB"))
(EXP <- inner_join(EXP, PPE, by="CO_NCM"))


#-------------------------------------------#
# IMPORTAÇÕES:
# criando base de dados anos 2005:
IMP_2005 <- read.csv2("IMP_2005.csv")
IMP_2005$CO_NCM <- as.factor(IMP_2005$CO_NC)

# selecionar os produtos importados:
(IMP <- select(IMP_2005, CO_NCM, VL_FOB))
(IMP <- IMP %>% group_by(CO_NCM) %>% 
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

#-------------------------------------------#
# renomear
(IMP <- rename(IMP, "IMP_VL_FOB"="VL_FOB"))
(IMP <- inner_join(IMP, PPI, by="CO_NCM"))


(XM <- inner_join(EXP, IMP, by="CO_NCM"))
(XM <- XM %>% 
    group_by(CO_NCM,NO_NCM_POR.x,EXP_VL_FOB,IMP_VL_FOB) %>% 
    summarise(SOMA = (EXP_VL_FOB + IMP_VL_FOB)) %>% 
    arrange(desc(SOMA)))

rm(EXP_2005,IMP_2005)

#-------------------------------------------------------------------------#
# função para calcular o índice GL:
GL <- function(a,b){
  m <- data.frame(abs(a-b))       # modulo de "a" menos "b";
  s <- data.frame(a+b)            # soma de "a" mais "b";
  gl <- data.frame(((s-m)/s)*100)
  return(gl)
}

# calcular o índice de Grubel-Lloid (GL) 

(GL <- XM %>% group_by(CO_NCM) %>% 
    summarise(gl = (1-(abs(EXP_VL_FOB-IMP_VL_FOB)/SOMA))*100) %>% 
    arrange(desc(gl)))

(XM <- inner_join(XM, GL, by="CO_NCM"))

(XM <- XM %>% arrange(desc(EXP_VL_FOB)))

distinct(XM)
dim(XM)

XM <- as.data.frame(XM)

# exportar para o Excel:
## Exportando para um arquivo Excel:

write.xlsx(XM, "Índice GL Intraindustriais-2005.xlsx")

rm(EXP,GL,IMP,XM)



#-------------------------------------------------------------------------
# Índice de cada Produto da BC e Produtos Intraindustriais 2010:
# EXPORTAÇÃO
# criando base de dados anos 2010:
EXP_2010 <- read.csv2("EXP_2010.csv")
EXP_2010$CO_NCM <- as.factor(EXP_2010$CO_NCM)

# selecionar os produtos exportados:
EXP <- select(EXP_2010, CO_NCM, VL_FOB)
(EXP <- EXP %>% group_by(CO_NCM) %>% 
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

# renomear
(EXP <- rename(EXP, "EXP_VL_FOB"="VL_FOB"))
(EXP <- inner_join(EXP, PPE, by="CO_NCM"))


#-------------------------------------------#
# IMPORTAÇÕES:
# criando base de dados anos 2010:
IMP_2010 <- read.csv2("IMP_2010.csv")
IMP_2010$CO_NCM <- as.factor(IMP_2010$CO_NC)

# selecionar os produtos importados:
(IMP <- select(IMP_2010, CO_NCM, VL_FOB))
(IMP <- IMP %>% group_by(CO_NCM) %>% 
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

#-------------------------------------------#
# renomear
(IMP <- rename(IMP, "IMP_VL_FOB"="VL_FOB"))
(IMP <- inner_join(IMP, PPI, by="CO_NCM"))


(XM <- inner_join(EXP, IMP, by="CO_NCM"))
(XM <- XM %>% 
    group_by(CO_NCM,NO_NCM_POR.x,EXP_VL_FOB,IMP_VL_FOB) %>% 
    summarise(SOMA = (EXP_VL_FOB + IMP_VL_FOB)) %>% 
    arrange(desc(SOMA)))

rm(EXP_2010,IMP_2010)

#-------------------------------------------------------------------------#
# função para calcular o índice GL:
GL <- function(a,b){
  m <- data.frame(abs(a-b))       # modulo de "a" menos "b";
  s <- data.frame(a+b)            # soma de "a" mais "b";
  gl <- data.frame(((s-m)/s)*100)
  return(gl)
}

# calcular o índice de Grubel-Lloid (GL) 

(GL <- XM %>% group_by(CO_NCM) %>% 
    summarise(gl = (1-(abs(EXP_VL_FOB-IMP_VL_FOB)/SOMA))*100) %>% 
    arrange(desc(gl)))

(XM <- inner_join(XM, GL, by="CO_NCM"))

(XM <- XM %>% arrange(desc(EXP_VL_FOB)))

distinct(XM)
dim(XM)

XM <- as.data.frame(XM)

# exportar para o Excel:
## Exportando para um arquivo Excel:

write.xlsx(XM, "Índice GL Intraindustriais-2010.xlsx")

rm(EXP,GL,IMP,XM)


#-------------------------------------------------------------------------
# Índice de cada Produto da BC e Produtos Intraindustriais 2015:
# EXPORTAÇÃO
# criando base de dados anos 2015:
EXP_2015 <- read.csv2("EXP_2015.csv")
EXP_2015$CO_NCM <- as.factor(EXP_2015$CO_NCM)

# selecionar os produtos exportados:
EXP <- select(EXP_2015, CO_NCM, VL_FOB)
(EXP <- EXP %>% group_by(CO_NCM) %>% 
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

# renomear
(EXP <- rename(EXP, "EXP_VL_FOB"="VL_FOB"))
(EXP <- inner_join(EXP, PPE, by="CO_NCM"))


#-------------------------------------------#
# IMPORTAÇÕES:
# criando base de dados anos 2015:
IMP_2015 <- read.csv2("IMP_2015.csv")
IMP_2015$CO_NCM <- as.factor(IMP_2015$CO_NC)

# selecionar os produtos importados:
(IMP <- select(IMP_2015, CO_NCM, VL_FOB))
(IMP <- IMP %>% group_by(CO_NCM) %>% 
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

#-------------------------------------------#
# renomear
(IMP <- rename(IMP, "IMP_VL_FOB"="VL_FOB"))
(IMP <- inner_join(IMP, PPI, by="CO_NCM"))


(XM <- inner_join(EXP, IMP, by="CO_NCM"))
(XM <- XM %>% 
    group_by(CO_NCM,NO_NCM_POR.x,EXP_VL_FOB,IMP_VL_FOB) %>% 
    summarise(SOMA = (EXP_VL_FOB + IMP_VL_FOB)) %>% 
    arrange(desc(SOMA)))

rm(EXP_2015,IMP_2015)

#-------------------------------------------------------------------------#
# função para calcular o índice GL:
GL <- function(a,b){
  m <- data.frame(abs(a-b))       # modulo de "a" menos "b";
  s <- data.frame(a+b)            # soma de "a" mais "b";
  gl <- data.frame(((s-m)/s)*100)
  return(gl)
}

# calcular o índice de Grubel-Lloid (GL) 

(GL <- XM %>% group_by(CO_NCM) %>% 
    summarise(gl = (1-(abs(EXP_VL_FOB-IMP_VL_FOB)/SOMA))*100) %>% 
    arrange(desc(gl)))

(XM <- inner_join(XM, GL, by="CO_NCM"))

(XM <- XM %>% arrange(desc(EXP_VL_FOB)))

distinct(XM)
dim(XM)

XM <- as.data.frame(XM)

# exportar para o Excel:
## Exportando para um arquivo Excel:

write.xlsx(XM, "Índice GL Intraindustriais-2015.xlsx")

rm(EXP,GL,IMP,XM)


#-------------------------------------------------------------------------
# Índice de cada Produto da BC e Produtos Intraindustriais 2020:
# EXPORTAÇÃO
# criando base de dados anos 2020:
EXP_2020 <- read.csv2("EXP_2020.csv")
EXP_2020$CO_NCM <- as.factor(EXP_2020$CO_NCM)

# selecionar os produtos exportados:
EXP <- select(EXP_2020, CO_NCM, VL_FOB)
(EXP <- EXP %>% group_by(CO_NCM) %>% 
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

# renomear
(EXP <- rename(EXP, "EXP_VL_FOB"="VL_FOB"))
(EXP <- inner_join(EXP, PPE, by="CO_NCM"))


#-------------------------------------------#
# IMPORTAÇÕES:
# criando base de dados anos 2020:
IMP_2020 <- read.csv2("IMP_2020.csv")
IMP_2020$CO_NCM <- as.factor(IMP_2020$CO_NC)

# selecionar os produtos importados:
(IMP <- select(IMP_2020, CO_NCM, VL_FOB))
(IMP <- IMP %>% group_by(CO_NCM) %>% 
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

#-------------------------------------------#
# renomear
(IMP <- rename(IMP, "IMP_VL_FOB"="VL_FOB"))
(IMP <- inner_join(IMP, PPI, by="CO_NCM"))


(XM <- inner_join(EXP, IMP, by="CO_NCM"))
(XM <- XM %>% 
    group_by(CO_NCM,NO_NCM_POR.x,EXP_VL_FOB,IMP_VL_FOB) %>% 
    summarise(SOMA = (EXP_VL_FOB + IMP_VL_FOB)) %>% 
    arrange(desc(SOMA)))

rm(EXP_2020,IMP_2020)

#-------------------------------------------------------------------------#
# função para calcular o índice GL:
GL <- function(a,b){
  m <- data.frame(abs(a-b))       # modulo de "a" menos "b";
  s <- data.frame(a+b)            # soma de "a" mais "b";
  gl <- data.frame(((s-m)/s)*100)
  return(gl)
}

# calcular o índice de Grubel-Lloid (GL) 

(GL <- XM %>% group_by(CO_NCM) %>% 
    summarise(gl = (1-(abs(EXP_VL_FOB-IMP_VL_FOB)/SOMA))*100) %>% 
    arrange(desc(gl)))

(XM <- inner_join(XM, GL, by="CO_NCM"))

(XM <- XM %>% arrange(desc(EXP_VL_FOB)))

distinct(XM)
dim(XM)

XM <- as.data.frame(XM)

# exportar para o Excel:
## Exportando para um arquivo Excel:

write.xlsx(XM, "Índice GL Intraindustriais-2020.xlsx")

rm(EXP,GL,IMP,XM)


#-------------------------------FIM-------------------------------#



