# Limpa objetos da memória
rm(list=ls(all=TRUE))

# Definir limite de memoria para compilação do programa:
aviso <- getOption("warn")
options(warn=-1)
memory.limit(size=20000)
options(warn=aviso)
rm(aviso)

# Definir opcao de codificacao dos caracteres e linguagem:
aviso <- getOption("warn")
options(warn=-1)
options(encoding="latin1")
options(warn=aviso)
rm(aviso)

# Definir opcao de exibicao de numero sem exponencial:
aviso <- getOption("warn")
options(warn=-1)
options(scipen=999)
options(warn=aviso)
rm(aviso)

# Definir opcao de repositorio para instalacao dos pacotes necessarios:
aviso <- getOption("warn")
options(warn=-1)
options(repos=structure(c(cran="https://cran.r-project.org/")))
options(warn=aviso)
rm(aviso)

options(scipen=999) # desativando notacao cientifica

#---------------------------------------------------------------------------------
# PACOTES NECESSARIOS
install.packages("readr")
install.packages("readxl")
install.packages("openxlsx")
install.packages("foreign", lib.loc = "C:/Program Files/R/R-3.6.1/library")
install.packages("readstata13")
install.packages("survey")
install.packages("haven")
install.packages("ggplot2")
install.packages("plogr")
install.packages("dplyr")
install.packages("descr")
install.packages("tidyr")
install.packages("tidyverse", dependencies = TRUE)
install.packages("nycflights13")
install.packages("backports")
install.packages("xlsx", dependencies = TRUE)
install.packages("rnaturalearth")
install.packages("devtools", dependencies = TRUE, force = TRUE)
install.packages("gridExtra", force = TRUE)

library(tidyverse)
library(rnaturalearth)
library(devtools)
devtools::install_github("AndySouth/rnaturalearthhires")
library(rnaturalearthhires)
library(esquisse)
library(ggspatial)
library(readr)
library(readxl)
library(openxlsx)
library(foreign)
library(readstata13)
library(survey)
library(haven)
library(ggplot2)
library(plogr)
library(dplyr)
library(descr)
library(tidyr)
library(nycflights13)
library(gridExtra)

#---------------------------------------------------------------------------------
# especificando diretorio (pasta em que os dados estao salvos):
setwd("F:/MESTRADO/PRE_PROJETO/DADOS PRE_PROJETO")

#-------------------------------------------------------------------------------#
# importar tabela auxiliar: dicionario dos produtos
## importando o nome dos produtos - PPE
TABELAS_AUXILIARES9 <- read_excel("TABELAS_AUXILIARES.xlsx", 
                                 sheet = "9") %>% 
  select("CO_NCM", "NO_NCM_POR", "NO_PPE")

glimpse(TABELAS_AUXILIARES9)

TABELAS_AUXILIARES9$CO_NCM <- as.factor(TABELAS_AUXILIARES9$CO_NCM)
TABELAS_AUXILIARES9 <- rename(TABELAS_AUXILIARES9, "PPE" = "NO_PPE")

#-------------------------------------------------------------------------------#
## importando o nome dos produtos - PPI
TABELAS_AUXILIARES8 <- read_excel("TABELAS_AUXILIARES.xlsx", 
                                  sheet = "8") %>% 
  select("CO_NCM", "NO_NCM_POR", "NO_PPI")

glimpse(TABELAS_AUXILIARES8)

TABELAS_AUXILIARES8$CO_NCM <- as.factor(TABELAS_AUXILIARES8$CO_NCM)
TABELAS_AUXILIARES8 <- rename(TABELAS_AUXILIARES8, "PPI" = "NO_PPI")

#-------------------------------------------------------------------------------#
# importar tabela auxiliar - 3 (CGCE):
TABELAS_AUXILIARES3 <- read_excel("TABELAS_AUXILIARES.xlsx", 
                                 sheet = "3") %>% 
  select("CO_NCM", "NO_CGCE_N1")

TABELAS_AUXILIARES3$CO_NCM <- as.factor(TABELAS_AUXILIARES3$CO_NCM)
TABELAS_AUXILIARES3 <- rename(TABELAS_AUXILIARES3, "CGCE" = "NO_CGCE_N1")

#-------------------------------------------------------------------------------#
# importar tabela auxiliar - 4 (ISIC):
TABELAS_AUXILIARES4 <- read_excel("TABELAS_AUXILIARES.xlsx", 
                                  sheet = "4", range = "A1:P13109") %>% 
  select("CO_NCM", "NO_ISIC_SECAO")

TABELAS_AUXILIARES4$CO_NCM <- as.factor(TABELAS_AUXILIARES4$CO_NCM)
TABELAS_AUXILIARES4 <- rename(TABELAS_AUXILIARES4, "ISIC" = "NO_ISIC_SECAO")

#-------------------------------------------------------------------------------#
# importar tabela auxiliar - 5 (ISIC):
TABELAS_AUXILIARES5 <- read_excel("TABELAS_AUXILIARES.xlsx", 
                                  sheet = "5", range = "A1:D13109") %>% 
  select("CO_NCM", "NO_SIIT")

TABELAS_AUXILIARES5$CO_NCM <- as.factor(TABELAS_AUXILIARES5$CO_NCM)
TABELAS_AUXILIARES5 <- rename(TABELAS_AUXILIARES5, "SIIT" = "NO_SIIT")

# importar tabela auxiliar - 7 (FAT_AGREG):
TABELAS_AUXILIARES7 <- read_excel("TABELAS_AUXILIARES.xlsx", 
                                  sheet = "7", range = "A1:D13109") %>% 
  select("CO_NCM", "NO_FAT_AGREG")

TABELAS_AUXILIARES7$CO_NCM <- as.factor(TABELAS_AUXILIARES7$CO_NCM)
TABELAS_AUXILIARES7 <- rename(TABELAS_AUXILIARES7, "FAT_AGREG" = "NO_FAT_AGREG")


#---------------------------------------------------------------------------------
# DADOS DE IMPORTACAO:
## importar planilha de importacao e selecionando as variaveis estudadas:
EXP <- read.csv2("F:/MESTRADO/PRE_PROJETO/DADOS PRE_PROJETO/EXP_COMPLETA.csv") %>% 
  select(CO_ANO, CO_MES, SG_UF_NCM, CO_NCM, VL_FOB) %>%
  filter(CO_ANO >= 2000)

#-------------------------------------------------------------------------------#
## transformar os valores dos produtos em fatores:
EXP$CO_NCM <- as.factor(EXP$CO_NCM)
EXP$CO_MES <- as.factor(EXP$CO_MES)

#-------------------------------------------------------------------------------#
## criando variavel pauta de produtos:
EXP$PAUTA <- "EXPORTACAO"

#-------------------------------------------------------------------------------#
## renomear variavel a partir da tabela auxiliar:
EXP <- EXP %>% inner_join(TABELAS_AUXILIARES3, by = c("CO_NCM" = "CO_NCM"))

EXP <- EXP %>% inner_join(TABELAS_AUXILIARES4, by = c("CO_NCM" = "CO_NCM"))

EXP <- EXP %>% inner_join(TABELAS_AUXILIARES5, by = c("CO_NCM" = "CO_NCM"))

EXP <- EXP %>% inner_join(TABELAS_AUXILIARES7, by = c("CO_NCM" = "CO_NCM"))

EXP <- EXP %>% inner_join(TABELAS_AUXILIARES9, by = c("CO_NCM" = "CO_NCM"))

#-------------------------------------------------------------------------------#
## remove linhas

EXP <- EXP %>% filter(CGCE != "BENS NÃO ESPECIFICADOS ANTERIORMENTE")
EXP <- EXP %>% filter(CGCE != "COMBUSTÍVEIS E LUBRIFICANTES")
EXP <- EXP %>% filter(FAT_AGREG != "REEXPORTACAO")
EXP <- EXP %>% filter(FAT_AGREG != "TRANSACOES ESPECIAIS")
EXP <- EXP %>% filter(FAT_AGREG != "CONSUMO DE BORDO")
EXP <- EXP %>% filter(PPE != "TRANSACOES ESPECIAIS - DEMAIS")
EXP <- EXP %>% filter(SG_UF_NCM != "ND")
EXP <- EXP %>% filter(SG_UF_NCM != "CB")
EXP <- EXP %>% filter(SG_UF_NCM != "MN")
EXP <- EXP %>% filter(SG_UF_NCM != "RE")
EXP <- EXP %>% filter(SG_UF_NCM != "ED")
EXP <- EXP %>% filter(SG_UF_NCM != "EX")
EXP <- EXP %>% filter(SG_UF_NCM != "ZN")

#-------------------------------------------------------------------------------#
## organizando base de dados:
EXP <- EXP %>% select("CO_ANO":"FAT_AGREG", "PPE")


glimpse(EXP)
class(EXP)
summary(EXP)
str(EXP)

#-------------------------------------------------------------------------------#
## PREPARAR E EXPORTAR DADOS PARA EXCEL:
### PREPARANDO OS DADOS
EXP_2000 <- subset(EXP, CO_ANO == "2000")
EXP_2005 <- subset(EXP, CO_ANO == "2005")
EXP_2010 <- subset(EXP, CO_ANO == "2010")
EXP_2015 <- subset(EXP, CO_ANO == "2015")
EXP_2020 <- subset(EXP, CO_ANO == "2020")


### EXPORTANDO
write.csv2(EXP_2000, "mestrado_script/EXP_2000.csv")
write.csv2(EXP_2005, "mestrado_script/EXP_2005.csv")
write.csv2(EXP_2010, "mestrado_script/EXP_2010.csv")
write.csv2(EXP_2015, "mestrado_script/EXP_2015.csv")
write.csv2(EXP_2020, "mestrado_script/EXP_2020.csv")


# write.csv(EXP, "mestrado_script/EXP.csv")
rm(EXP, EXP_2000, EXP_2005, EXP_2010, 
   EXP_2015, EXP_2020)


#---------------------------------------------------------------------------------
# DADOS DE IMPORTACAO:
## importar planilha de importacao e selecionando as variaveis estudadas:
IMP <- read.csv2("F:/MESTRADO/PRE_PROJETO/DADOS PRE_PROJETO/IMP_COMPLETA.csv") %>% 
  select(CO_ANO, CO_MES, SG_UF_NCM, CO_NCM, VL_FOB) %>%
  filter(CO_ANO >= 2000)

#-----------------------------------------------------------------------------#
## transformar os valores dos produtos em fatores:
IMP$CO_NCM <- as.factor(IMP$CO_NCM)
IMP$CO_MES <- as.factor(IMP$CO_MES)

#-----------------------------------------------------------------------------#
## criando variavel pauta de produtos:
IMP$PAUTA <- "IMPORTACAO"

#-----------------------------------------------------------------------------#
## renomear variavel a partir da tabela auxiliar:
IMP <- IMP %>% inner_join(TABELAS_AUXILIARES3, by = c("CO_NCM" = "CO_NCM"))

IMP <- IMP %>% inner_join(TABELAS_AUXILIARES4, by = c("CO_NCM" = "CO_NCM"))

IMP <- IMP %>% inner_join(TABELAS_AUXILIARES5, by = c("CO_NCM" = "CO_NCM"))

IMP <- IMP %>% inner_join(TABELAS_AUXILIARES7, by = c("CO_NCM" = "CO_NCM"))

IMP <- IMP %>% inner_join(TABELAS_AUXILIARES8, by = c("CO_NCM" = "CO_NCM"))

#-----------------------------------------------------------------------------#
## remover linhas
IMP <- IMP %>% filter(CGCE != "BENS NÃO ESPECIFICADOS ANTERIORMENTE")
IMP <- IMP %>% filter(CGCE != "COMBUSTÍVEIS E LUBRIFICANTES")
IMP <- IMP %>% filter(FAT_AGREG != "REEXPORTACAO")
IMP <- IMP %>% filter(FAT_AGREG != "TRANSACOES ESPECIAIS")
IMP <- IMP %>% filter(FAT_AGREG != "CONSUMO DE BORDO")
IMP <- IMP %>% filter(PPI != "TRANSACOES ESPECIAIS - DEMAIS")
IMP <- IMP %>% filter(SG_UF_NCM != "ND")
IMP <- IMP %>% filter(SG_UF_NCM != "CB")
IMP <- IMP %>% filter(SG_UF_NCM != "MN")
IMP <- IMP %>% filter(SG_UF_NCM != "RE")
IMP <- IMP %>% filter(SG_UF_NCM != "ED")
IMP <- IMP %>% filter(SG_UF_NCM != "EX")
IMP <- IMP %>% filter(SG_UF_NCM != "ZN")

#-----------------------------------------------------------------------------#
## organizando base de dados:
IMP <- IMP %>% select("CO_ANO":"FAT_AGREG","PPI")

#-----------------------------------------------------------------------------#
## PREPARAR E EXPORTAR DADOS PARA EXCEL:
### PREPARANDO OS DADOS
IMP_2000 <- subset(IMP, CO_ANO == "2000")
IMP_2005 <- subset(IMP, CO_ANO == "2005")
IMP_2010 <- subset(IMP, CO_ANO == "2010")
IMP_2015 <- subset(IMP, CO_ANO == "2015")
IMP_2020 <- subset(IMP, CO_ANO == "2020")

### EXPORTANDO
write.csv2(IMP_2000, "mestrado_script/IMP_2000.csv")
write.csv2(IMP_2005, "mestrado_script/IMP_2005.csv")
write.csv2(IMP_2010, "mestrado_script/IMP_2010.csv")
write.csv2(IMP_2015, "mestrado_script/IMP_2015.csv")
write.csv2(IMP_2020, "mestrado_script/IMP_2020.csv")

rm(list=ls(all=TRUE))

# write.csv(IMP, "mestrado_script/IMP.csv")

#---------------------------------------------------------------------------------
# IMPORTAR E FILTRAR BASE DE DADOS 2000
## importar
EXP_2000 <- read.csv2("mestrado_script/EXP_2000.csv")
IMP_2000 <- read.csv2("mestrado_script/IMP_2000.csv")

## filtrar
EXP_2000 <- select(EXP_2000, -X) # selecionar por column_name
IMP_2000 <- select(IMP_2000, -1) #selecionar por posicao ou "IMP_2000$X <- NULL"

# transformar a variaveis PPE e PPI em fatores:
## exportacao
EXP_2000$PPE <- as.factor(EXP_2000$PPE)
EXP_2000$CO_NCM <- as.factor(EXP_2000$CO_NCM)

## importacao
IMP_2000$PPI <- as.factor(IMP_2000$PPI)
IMP_2000$CO_NCM <- as.factor(IMP_2000$CO_NCM)

#-------------------------------------------------------------------------#
# FATOR AGREGADO - 2000
# indice de cada Produto da BC e Produtos Intraindustriais 2000:
#-------------------------------------------------------------------------#
## EXPORTACAO
## selecionar os produtos exportados:
EXP_2000_a <- select(EXP_2000, CO_NCM, VL_FOB, SG_UF_NCM, FAT_AGREG, PPE)
(EXP_2000_a <- EXP_2000_a %>% group_by(SG_UF_NCM, FAT_AGREG) %>% 
    filter(FAT_AGREG != "CONSUMO DE BORDO") %>% 
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

## renomear
(EXP_2000_a <- rename(EXP_2000_a, "EXP_VL_FOB"="VL_FOB"))

# TRANSFORMAR EM DATAFRAME
EXP_2000_a <- as.data.frame(EXP_2000_a)

#-------------------------------------------------------------------------#
# IMPORTACAO:
# criando base de dados anos 2000:
## selecionar os produtos importacao:
IMP_2000_a <- select(IMP_2000, CO_NCM, VL_FOB, SG_UF_NCM, FAT_AGREG, PPI)
(IMP_2000_a <- IMP_2000_a %>% group_by(SG_UF_NCM, FAT_AGREG) %>% 
    filter(FAT_AGREG != "CONSUMO DE BORDO") %>%
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

## renomear
(IMP_2000_a <- rename(IMP_2000_a, "IMP_VL_FOB"="VL_FOB"))

# TRANSFORMAR EM DATAFRAME
IMP_2000_a <- as.data.frame(IMP_2000_a)

#-------------------------------------------------------------------------#
## exportar planilha com valores agrupados:
write.csv2(EXP_2000_a, "mestrado_script/EXP_2000_A.csv")
write.csv2(IMP_2000_a, "mestrado_script/IMP_2000_A.csv")

#-------------------------------------------------------------------------#
# juntar base de dados BC 2000:
(XM_2000_a <- inner_join(EXP_2000_a, IMP_2000_a, 
                         by=c("SG_UF_NCM", "FAT_AGREG")))

# organizar variaveis:
XM_2000_a <- XM_2000_a %>% 
  select(SG_UF_NCM, FAT_AGREG, EXP_VL_FOB, IMP_VL_FOB)

# CRIANDO A COLUNA DE SOMA:
(XM_2000_a <- XM_2000_a %>% 
    group_by(SG_UF_NCM, FAT_AGREG, EXP_VL_FOB, IMP_VL_FOB) %>% 
    summarise(SOMA = (EXP_VL_FOB + IMP_VL_FOB)) %>% 
    arrange(desc(SOMA)))

#-------------------------------------------------------------------------#
# funcao para calcular o indice GL:
GL <- function(a,b){
  m <- data.frame(abs(a-b))       # modulo de "a" menos "b";
  s <- data.frame(a+b)            # soma de "a" mais "b";
  gl <- data.frame(((s-m)/s)*100)
  return(gl)
}

#-------------------------------------------------------------------------#
# calcular o indice de Grubel-Lloid (GL) XM_2000_a:
(GL_2000_a <- XM_2000_a %>% group_by(SG_UF_NCM, FAT_AGREG) %>% 
    summarise(gl = (1-(abs(EXP_VL_FOB-IMP_VL_FOB)/SOMA))*100) %>% 
    arrange(desc(gl)))


# JUNTANDO O FATOR AGREGADO E O INDICE
(XM_2000_a <- inner_join(XM_2000_a, GL_2000_a, 
                         by=c("SG_UF_NCM", "FAT_AGREG")))

# ORDENAR
(XM_2000_a <- XM_2000_a %>% arrange(desc(EXP_VL_FOB)))

# TRANFORMANDO EM DATAFRAME
XM_2000_a <- as.data.frame(XM_2000_a)

## Exportando para um arquivo Excel:
write.csv2(XM_2000_a, "mestrado_script/XM_2000_A.csv")
write.csv2(GL_2000_a, "mestrado_script/indice GL por Fator Agregado-2000.csv")

### limpar dados
rm(XM_2000_a, GL_2000_a, EXP_2000_a, IMP_2000_a)

#-------------------------------------------------------------------------#
# CGCE - 2000
# indice de cada Produto da BC e Produtos Intraindustriais 2000:
#-------------------------------------------------------------------------#
## EXPORTACAO
## selecionar os produtos exportados:
EXP_2000_CGCE <- select(EXP_2000, CO_NCM, VL_FOB, SG_UF_NCM, CGCE, PPE)
(EXP_2000_CGCE <- EXP_2000_CGCE %>% group_by(SG_UF_NCM, CGCE) %>% 
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

## renomear
(EXP_2000_CGCE <- rename(EXP_2000_CGCE, "EXP_VL_FOB"="VL_FOB"))

#-------------------------------------------------------------------------#
# IMPORTACAO:
# criando base de dados anos 2000:
## selecionar os produtos importacao:
IMP_2000_CGCE <- select(IMP_2000, CO_NCM, VL_FOB, SG_UF_NCM, CGCE, PPI)
(IMP_2000_CGCE <- IMP_2000_CGCE %>% 
    group_by(SG_UF_NCM, CGCE) %>% 
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

## renomear
(IMP_2000_CGCE <- rename(IMP_2000_CGCE, "IMP_VL_FOB"="VL_FOB"))

#-------------------------------------------------------------------------#
## exportar planilha com valores agrupados:
write.csv2(EXP_2000_CGCE, "mestrado_script/EXP_2000_CGCE.csv")
write.csv2(IMP_2000_CGCE, "mestrado_script/IMP_2000_CGCE.csv")

#-------------------------------------------------------------------------#
# juntar base de dados BC 2000:
(XM_2000_CGCE <- inner_join(EXP_2000_CGCE, IMP_2000_CGCE, 
                            by=c("SG_UF_NCM", "CGCE")))

## CRIAR COLUNA DE SOMA
(XM_2000_CGCE <- XM_2000_CGCE %>% 
    group_by(SG_UF_NCM, CGCE, EXP_VL_FOB, IMP_VL_FOB) %>% 
    summarise(SOMA = (EXP_VL_FOB + IMP_VL_FOB)) %>% 
    arrange(desc(SOMA)))

#-------------------------------------------------------------------------#
# funcao para calcular o indice GL:
GL <- function(a,b){
  m <- data.frame(abs(a-b))       # modulo de "a" menos "b";
  s <- data.frame(a+b)            # soma de "a" mais "b";
  gl <- data.frame(((s-m)/s)*100)
  return(gl)
}

#-------------------------------------------------------------------------#
# calcular o indice de Grubel-Lloid (GL) XM_2000_CGCE:
(GL_2000_CGCE <- XM_2000_CGCE %>% group_by(SG_UF_NCM, CGCE) %>% 
    summarise(gl = (1-(abs(EXP_VL_FOB-IMP_VL_FOB)/SOMA))*100) %>% 
    arrange(desc(gl)))

## JUNTAR BASE E INDICE
(XM_2000_CGCE <- inner_join(XM_2000_CGCE, GL_2000_CGCE, 
                            by=c("SG_UF_NCM", "CGCE")))

## ORDENAR
(XM_2000_CGCE <- XM_2000_CGCE %>% arrange(desc(EXP_VL_FOB)))

# TRANFORMANDO EM DATAFRAME
XM_2000_CGCE <- as.data.frame(XM_2000_CGCE)

## Exportando para um arquivo Excel:
write.csv2(XM_2000_CGCE, "mestrado_script/XM_2000_CGCE.csv")
write.csv2(GL_2000_CGCE, "mestrado_script/indice GL por CGCE-2000.csv")

### limpar dados
rm(XM_2000_CGCE, GL_2000_CGCE, EXP_2000_CGCE, IMP_2000_CGCE)


#-------------------------------------------------------------------------#
# ISIC - 2000
# indice de cada Produto da BC e Produtos Intraindustriais 2000:
#-------------------------------------------------------------------------#
## EXPORTACAO
## selecionar os produtos exportados:
EXP_2000_ISIC <- select(EXP_2000, CO_NCM, VL_FOB, SG_UF_NCM, ISIC, PPE)
(EXP_2000_ISIC <- EXP_2000_ISIC %>% 
    group_by(SG_UF_NCM, ISIC) %>% 
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

## RENOMEAR
(EXP_2000_ISIC <- rename(EXP_2000_ISIC, "EXP_VL_FOB"="VL_FOB"))

# TRANSFORMAR EM DATAFRAME
EXP_2000_ISIC <- as.data.frame(EXP_2000_ISIC)

#-------------------------------------------------------------------------#
# IMPORTACAO:
# criando base de dados anos 2000:
## selecionar os produtos importacao:
IMP_2000_ISIC <- select(IMP_2000, CO_NCM, VL_FOB, SG_UF_NCM, ISIC, PPI)
(IMP_2000_ISIC <- IMP_2000_ISIC %>% 
    group_by(SG_UF_NCM, ISIC) %>% 
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

## RENOMEAR
(IMP_2000_ISIC <- rename(IMP_2000_ISIC, "IMP_VL_FOB"="VL_FOB"))

# TRANSFORMAR EM DATAFRAME
IMP_2000_ISIC <- as.data.frame(IMP_2000_ISIC)

#-------------------------------------------------------------------------#
## exportar planilha com valores agrupados:
write.csv2(EXP_2000_ISIC, "mestrado_script/EXP_2000_ISIC.csv")
write.csv2(IMP_2000_ISIC, "mestrado_script/IMP_2000_ISIC.csv")

#-------------------------------------------------------------------------#
# juntar base de dados BC 2000:
(XM_2000_ISIC <- inner_join(EXP_2000_ISIC, IMP_2000_ISIC, 
                            by=c("SG_UF_NCM", "ISIC")))

## CRIAR A COLUNA SOMA
(XM_2000_ISIC <- XM_2000_ISIC %>% 
    group_by(SG_UF_NCM, ISIC, EXP_VL_FOB, IMP_VL_FOB) %>% 
    summarise(SOMA = (EXP_VL_FOB + IMP_VL_FOB)) %>% 
    arrange(desc(SOMA)))

## TRANSFORMAR EM DATAFRAME
(XM_2000_ISIC <- as.data.frame(XM_2000_ISIC))

#-------------------------------------------------------------------------#
# funcao para calcular o indice GL:
GL <- function(a,b){
  m <- data.frame(abs(a-b))       # modulo de "a" menos "b";
  s <- data.frame(a+b)            # soma de "a" mais "b";
  gl <- data.frame(((s-m)/s)*100)
  return(gl)
}

#-------------------------------------------------------------------------#
# calcular o indice de Grubel-Lloid (GL) XM_2000_ISIC:
(GL_2000_ISIC <- XM_2000_ISIC %>% group_by(SG_UF_NCM, ISIC) %>% 
    summarise(gl = (1-(abs(EXP_VL_FOB-IMP_VL_FOB)/SOMA))*100) %>% 
    arrange(desc(gl)))

## JUNTO BASE E INDICE
(XM_2000_ISIC <- inner_join(XM_2000_ISIC, GL_2000_ISIC, 
                            by=c("SG_UF_NCM", "ISIC")))

## ORDENAR
(XM_2000_ISIC <- XM_2000_ISIC %>% arrange(desc(EXP_VL_FOB)))

# TRANFORMANDO EM DATAFRAME
XM_2000_ISIC <- as.data.frame(XM_2000_ISIC)

## Exportando para um arquivo Excel:
write.csv2(XM_2000_ISIC, "mestrado_script/XM_2000_ISIC.csv")
write.csv2(GL_2000_ISIC, "mestrado_script/indice GL por ISIC-2000.csv")

### limpar dados
rm(XM_2000_ISIC, GL_2000_ISIC, EXP_2000_ISIC, IMP_2000_ISIC)


#-------------------------------------------------------------------------#
# SIIT - 2000
# indice de cada Produto da BC e Produtos Intraindustriais 2000:
#-------------------------------------------------------------------------#
## EXPORTACAO
## selecionar os produtos exportados:
EXP_2000_SIIT <- select(EXP_2000, CO_NCM, VL_FOB, SG_UF_NCM, SIIT, PPE)
(EXP_2000_SIIT <- EXP_2000_SIIT %>% 
    group_by(SG_UF_NCM, SIIT) %>% 
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

## renomear
(EXP_2000_SIIT <- rename(EXP_2000_SIIT, "EXP_VL_FOB"="VL_FOB"))

#-------------------------------------------------------------------------#
# IMPORTACAO:
# criando base de dados anos 2000:
## selecionar os produtos importacao:
IMP_2000_SIIT <- select(IMP_2000, CO_NCM, VL_FOB, SG_UF_NCM, SIIT, PPI)
(IMP_2000_SIIT <- IMP_2000_SIIT %>% 
    group_by(SG_UF_NCM, SIIT) %>% 
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

## renomear
(IMP_2000_SIIT <- rename(IMP_2000_SIIT, "IMP_VL_FOB"="VL_FOB"))

#-------------------------------------------------------------------------#
## exportar planilha com valores agrupados:
write.csv2(EXP_2000_SIIT, "mestrado_script/EXP_2000_SIIT.csv")
write.csv2(IMP_2000_SIIT, "mestrado_script/IMP_2000_SIIT.csv")

#-------------------------------------------------------------------------#
# juntar base de dados BC 2000:
(XM_2000_SIIT <- inner_join(EXP_2000_SIIT, IMP_2000_SIIT, 
                            by=c("SG_UF_NCM", "SIIT")))

## CRIAR COLUNA SOMA
(XM_2000_SIIT <- XM_2000_SIIT %>% 
    group_by(SG_UF_NCM, SIIT, EXP_VL_FOB, IMP_VL_FOB) %>% 
    summarise(SOMA = (EXP_VL_FOB + IMP_VL_FOB)) %>% 
    arrange(desc(SOMA)))

#-------------------------------------------------------------------------#
# funcao para calcular o indice GL:
GL <- function(a,b){
  m <- data.frame(abs(a-b))       # modulo de "a" menos "b";
  s <- data.frame(a+b)            # soma de "a" mais "b";
  gl <- data.frame(((s-m)/s)*100)
  return(gl)
}

#-------------------------------------------------------------------------#
# calcular o indice de Grubel-Lloid (GL) XM_2000_SIIT:
(GL_2000_SIIT <- XM_2000_SIIT %>% group_by(SG_UF_NCM, SIIT) %>% 
    summarise(gl = (1-(abs(EXP_VL_FOB-IMP_VL_FOB)/SOMA))*100) %>% 
    arrange(desc(gl)))

## JUNTAR BASE E INDICE
(XM_2000_SIIT <- inner_join(XM_2000_SIIT, GL_2000_SIIT, 
                            by=c("SG_UF_NCM", "SIIT")))

## ORDENAR
(XM_2000_SIIT <- XM_2000_SIIT %>% arrange(desc(EXP_VL_FOB)))

## TRANSFORMAR EM DATAFRAME
XM_2000_SIIT <- as.data.frame(XM_2000_SIIT)

## Exportando para um arquivo Excel:
write.csv2(XM_2000_SIIT, "mestrado_script/XM_2000_SIIT.csv")
write.csv2(GL_2000_SIIT, "mestrado_script/indice GL por SIIT-2000.csv")


### limpar dados
rm(list=ls(all=TRUE))


#---------------------------------------------------------------------------------
# IMPORTAR E FILTRAR BASE DE DADOS 2005
## importar
EXP_2005 <- read.csv2("mestrado_script/EXP_2005.csv")
IMP_2005 <- read.csv2("mestrado_script/IMP_2005.csv")

## filtrar
EXP_2005 <- select(EXP_2005, -X) # selecionar por column_name
IMP_2005 <- select(IMP_2005, -1) #selecionar por posicao ou "IMP_2005$X <- NULL"

# transformar a variaveis PPE e PPI em fatores:
## exportacao
EXP_2005$PPE <- as.factor(EXP_2005$PPE)
EXP_2005$CO_NCM <- as.factor(EXP_2005$CO_NCM)

## importacao
IMP_2005$PPI <- as.factor(IMP_2005$PPI)
IMP_2005$CO_NCM <- as.factor(IMP_2005$CO_NCM)

#-------------------------------------------------------------------------#
# FATOR AGREGADO - 2005
# indice de cada Produto da BC e Produtos Intraindustriais 2005:
#-------------------------------------------------------------------------#
## EXPORTACAO
## selecionar os produtos exportados:
EXP_2005_a <- select(EXP_2005, CO_NCM, VL_FOB, SG_UF_NCM, FAT_AGREG, PPE)
(EXP_2005_a <- EXP_2005_a %>% group_by(SG_UF_NCM, FAT_AGREG) %>% 
    filter(FAT_AGREG != "CONSUMO DE BORDO") %>% 
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

## renomear
(EXP_2005_a <- rename(EXP_2005_a, "EXP_VL_FOB"="VL_FOB"))

# TRANSFORMAR EM DATAFRAME
EXP_2005_a <- as.data.frame(EXP_2005_a)

#-------------------------------------------------------------------------#
# IMPORTACAO:
# criando base de dados anos 2005:
## selecionar os produtos importacao:
IMP_2005_a <- select(IMP_2005, CO_NCM, VL_FOB, SG_UF_NCM, FAT_AGREG, PPI)
(IMP_2005_a <- IMP_2005_a %>% group_by(SG_UF_NCM, FAT_AGREG) %>% 
    filter(FAT_AGREG != "CONSUMO DE BORDO") %>%
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

## renomear
(IMP_2005_a <- rename(IMP_2005_a, "IMP_VL_FOB"="VL_FOB"))

# TRANSFORMAR EM DATAFRAME
IMP_2005_a <- as.data.frame(IMP_2005_a)

#-------------------------------------------------------------------------#
## exportar planilha com valores agrupados:
write.csv2(EXP_2005_a, "mestrado_script/EXP_2005_A.csv")
write.csv2(IMP_2005_a, "mestrado_script/IMP_2005_A.csv")

#-------------------------------------------------------------------------#
# juntar base de dados BC 2005:
(XM_2005_a <- inner_join(EXP_2005_a, IMP_2005_a, 
                         by=c("SG_UF_NCM", "FAT_AGREG")))

# organizar variaveis:
XM_2005_a <- XM_2005_a %>% 
  select(SG_UF_NCM, FAT_AGREG, EXP_VL_FOB, IMP_VL_FOB)

# CRIANDO A COLUNA DE SOMA:
(XM_2005_a <- XM_2005_a %>% 
    group_by(SG_UF_NCM, FAT_AGREG, EXP_VL_FOB, IMP_VL_FOB) %>% 
    summarise(SOMA = (EXP_VL_FOB + IMP_VL_FOB)) %>% 
    arrange(desc(SOMA)))

#-------------------------------------------------------------------------#
# funcao para calcular o indice GL:
GL <- function(a,b){
  m <- data.frame(abs(a-b))       # modulo de "a" menos "b";
  s <- data.frame(a+b)            # soma de "a" mais "b";
  gl <- data.frame(((s-m)/s)*100)
  return(gl)
}

#-------------------------------------------------------------------------#
# calcular o indice de Grubel-Lloid (GL) XM_2005_a:
(GL_2005_a <- XM_2005_a %>% group_by(SG_UF_NCM, FAT_AGREG) %>% 
    summarise(gl = (1-(abs(EXP_VL_FOB-IMP_VL_FOB)/SOMA))*100) %>% 
    arrange(desc(gl)))


# JUNTANDO O FATOR AGREGADO E O INDICE
(XM_2005_a <- inner_join(XM_2005_a, GL_2005_a, 
                         by=c("SG_UF_NCM", "FAT_AGREG")))

# ORDENAR
(XM_2005_a <- XM_2005_a %>% arrange(desc(EXP_VL_FOB)))

# TRANFORMANDO EM DATAFRAME
XM_2005_a <- as.data.frame(XM_2005_a)

## Exportando para um arquivo Excel:
write.csv2(XM_2005_a, "mestrado_script/XM_2005_A.csv")
write.csv2(GL_2005_a, "mestrado_script/indice GL por Fator Agregado-2005.csv")

### limpar dados
rm(XM_2005_a, GL_2005_a, EXP_2005_a, IMP_2005_a)


#-------------------------------------------------------------------------#
#-------------------------------------------------------------------------#
# CGCE - 2005
# indice de cada Produto da BC e Produtos Intraindustriais 2005:
#-------------------------------------------------------------------------#
## EXPORTACAO
## selecionar os produtos exportados:
EXP_2005_CGCE <- select(EXP_2005, CO_NCM, VL_FOB, SG_UF_NCM, CGCE, PPE)
(EXP_2005_CGCE <- EXP_2005_CGCE %>% group_by(SG_UF_NCM, CGCE) %>% 
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

## renomear
(EXP_2005_CGCE <- rename(EXP_2005_CGCE, "EXP_VL_FOB"="VL_FOB"))

#-------------------------------------------------------------------------#
# IMPORTACAO:
# criando base de dados anos 2005:
## selecionar os produtos importacao:
IMP_2005_CGCE <- select(IMP_2005, CO_NCM, VL_FOB, SG_UF_NCM, CGCE, PPI)
(IMP_2005_CGCE <- IMP_2005_CGCE %>% 
    group_by(SG_UF_NCM, CGCE) %>% 
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

## renomear
(IMP_2005_CGCE <- rename(IMP_2005_CGCE, "IMP_VL_FOB"="VL_FOB"))

#-------------------------------------------------------------------------#
## exportar planilha com valores agrupados:
write.csv2(EXP_2005_CGCE, "mestrado_script/EXP_2005_CGCE.csv")
write.csv2(IMP_2005_CGCE, "mestrado_script/IMP_2005_CGCE.csv")

#-------------------------------------------------------------------------#
# juntar base de dados BC 2005:
(XM_2005_CGCE <- inner_join(EXP_2005_CGCE, IMP_2005_CGCE, 
                            by=c("SG_UF_NCM", "CGCE")))

## CRIAR COLUNA DE SOMA
(XM_2005_CGCE <- XM_2005_CGCE %>% 
    group_by(SG_UF_NCM, CGCE, EXP_VL_FOB, IMP_VL_FOB) %>% 
    summarise(SOMA = (EXP_VL_FOB + IMP_VL_FOB)) %>% 
    arrange(desc(SOMA)))

#-------------------------------------------------------------------------#
# funcao para calcular o indice GL:
GL <- function(a,b){
  m <- data.frame(abs(a-b))       # modulo de "a" menos "b";
  s <- data.frame(a+b)            # soma de "a" mais "b";
  gl <- data.frame(((s-m)/s)*100)
  return(gl)
}

#-------------------------------------------------------------------------#
# calcular o indice de Grubel-Lloid (GL) XM_2005_CGCE:
(GL_2005_CGCE <- XM_2005_CGCE %>% group_by(SG_UF_NCM, CGCE) %>% 
    summarise(gl = (1-(abs(EXP_VL_FOB-IMP_VL_FOB)/SOMA))*100) %>% 
    arrange(desc(gl)))

## JUNTAR BASE E INDICE
(XM_2005_CGCE <- inner_join(XM_2005_CGCE, GL_2005_CGCE, 
                            by=c("SG_UF_NCM", "CGCE")))

## ORDENAR
(XM_2005_CGCE <- XM_2005_CGCE %>% arrange(desc(EXP_VL_FOB)))

# TRANFORMANDO EM DATAFRAME
XM_2005_CGCE <- as.data.frame(XM_2005_CGCE)

## Exportando para um arquivo Excel:
write.csv2(XM_2005_CGCE, "mestrado_script/XM_2005_CGCE.csv")
write.csv2(GL_2005_CGCE, "mestrado_script/indice GL por CGCE-2005.csv")

### limpar dados
rm(XM_2005_CGCE, GL_2005_CGCE, EXP_2005_CGCE, IMP_2005_CGCE)


#-------------------------------------------------------------------------#
# ISIC - 2005
# indice de cada Produto da BC e Produtos Intraindustriais 2005:
#-------------------------------------------------------------------------#
## EXPORTACAO
## selecionar os produtos exportados:
EXP_2005_ISIC <- select(EXP_2005, CO_NCM, VL_FOB, SG_UF_NCM, ISIC, PPE)
(EXP_2005_ISIC <- EXP_2005_ISIC %>% 
    group_by(SG_UF_NCM, ISIC) %>% 
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

## renomear
(EXP_2005_ISIC <- rename(EXP_2005_ISIC, "EXP_VL_FOB"="VL_FOB"))

#-------------------------------------------------------------------------#
# IMPORTACAO:
# criando base de dados anos 2005:
## selecionar os produtos importacao:
IMP_2005_ISIC <- select(IMP_2005, CO_NCM, VL_FOB, SG_UF_NCM, ISIC, PPI)
(IMP_2005_ISIC <- IMP_2005_ISIC %>% 
    group_by(SG_UF_NCM, ISIC) %>% 
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

## renomear
(IMP_2005_ISIC <- rename(IMP_2005_ISIC, "IMP_VL_FOB"="VL_FOB"))

#-------------------------------------------------------------------------#
## exportar planilha com valores agrupados:
write.csv2(EXP_2005_ISIC, "mestrado_script/EXP_2005_ISIC.csv")
write.csv2(IMP_2005_ISIC, "mestrado_script/IMP_2005_ISIC.csv")

#-------------------------------------------------------------------------#
# juntar base de dados BC 2005:
(XM_2005_ISIC <- inner_join(EXP_2005_ISIC, IMP_2005_ISIC, 
                            by=c("SG_UF_NCM", "ISIC")))

## CRIAR A COLUNA SOMA
(XM_2005_ISIC <- XM_2005_ISIC %>% 
    group_by(SG_UF_NCM, ISIC, EXP_VL_FOB, IMP_VL_FOB) %>% 
    summarise(SOMA = (EXP_VL_FOB + IMP_VL_FOB)) %>% 
    arrange(desc(SOMA)))

## TRANSFORMAR EM DATAFRAME
(XM_2005_ISIC <- as.data.frame(XM_2005_ISIC))

#-------------------------------------------------------------------------#
# funcao para calcular o indice GL:
GL <- function(a,b){
  m <- data.frame(abs(a-b))       # modulo de "a" menos "b";
  s <- data.frame(a+b)            # soma de "a" mais "b";
  gl <- data.frame(((s-m)/s)*100)
  return(gl)
}

#-------------------------------------------------------------------------#
# calcular o indice de Grubel-Lloid (GL) XM_2005_ISIC:
(GL_2005_ISIC <- XM_2005_ISIC %>% group_by(SG_UF_NCM, ISIC) %>% 
    summarise(gl = (1-(abs(EXP_VL_FOB-IMP_VL_FOB)/SOMA))*100) %>% 
    arrange(desc(gl)))

## JUNTO BASE E INDICE
(XM_2005_ISIC <- inner_join(XM_2005_ISIC, GL_2005_ISIC, 
                            by=c("SG_UF_NCM", "ISIC")))

## ORDENAR
(XM_2005_ISIC <- XM_2005_ISIC %>% arrange(desc(EXP_VL_FOB)))

# TRANFORMANDO EM DATAFRAME
XM_2005_ISIC <- as.data.frame(XM_2005_ISIC)

## Exportando para um arquivo Excel:
write.csv2(XM_2005_ISIC, "mestrado_script/XM_2005_ISIC.csv")
write.csv2(GL_2005_ISIC, "mestrado_script/indice GL por ISIC-2005.csv")

### limpar dados
rm(XM_2005_ISIC, GL_2005_ISIC, EXP_2005_ISIC, IMP_2005_ISIC)


#-------------------------------------------------------------------------#
# SIIT - 2005
# indice de cada Produto da BC e Produtos Intraindustriais 2005:
#-------------------------------------------------------------------------#
## EXPORTACAO
## selecionar os produtos exportados:
EXP_2005_SIIT <- select(EXP_2005, CO_NCM, VL_FOB, SG_UF_NCM, SIIT, PPE)
(EXP_2005_SIIT <- EXP_2005_SIIT %>% 
    group_by(SG_UF_NCM, SIIT) %>% 
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

## renomear
(EXP_2005_SIIT <- rename(EXP_2005_SIIT, "EXP_VL_FOB"="VL_FOB"))

#-------------------------------------------------------------------------#
# IMPORTACAO:
# criando base de dados anos 2005:
## selecionar os produtos importacao:
IMP_2005_SIIT <- select(IMP_2005, CO_NCM, VL_FOB, SG_UF_NCM, SIIT, PPI)
(IMP_2005_SIIT <- IMP_2005_SIIT %>% 
    group_by(SG_UF_NCM, SIIT) %>% 
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

## renomear
(IMP_2005_SIIT <- rename(IMP_2005_SIIT, "IMP_VL_FOB"="VL_FOB"))

#-------------------------------------------------------------------------#
## exportar planilha com valores agrupados:
write.csv2(EXP_2005_SIIT, "mestrado_script/EXP_2005_SIIT.csv")
write.csv2(IMP_2005_SIIT, "mestrado_script/IMP_2005_SIIT.csv")

#-------------------------------------------------------------------------#
# juntar base de dados BC 2005:
(XM_2005_SIIT <- inner_join(EXP_2005_SIIT, IMP_2005_SIIT, 
                            by=c("SG_UF_NCM", "SIIT")))

## CRIAR COLUNA SOMA
(XM_2005_SIIT <- XM_2005_SIIT %>% 
    group_by(SG_UF_NCM, SIIT, EXP_VL_FOB, IMP_VL_FOB) %>% 
    summarise(SOMA = (EXP_VL_FOB + IMP_VL_FOB)) %>% 
    arrange(desc(SOMA)))

#-------------------------------------------------------------------------#
# funcao para calcular o indice GL:
GL <- function(a,b){
  m <- data.frame(abs(a-b))       # modulo de "a" menos "b";
  s <- data.frame(a+b)            # soma de "a" mais "b";
  gl <- data.frame(((s-m)/s)*100)
  return(gl)
}

#-------------------------------------------------------------------------#
# calcular o indice de Grubel-Lloid (GL) XM_2005_SIIT:
(GL_2005_SIIT <- XM_2005_SIIT %>% group_by(SG_UF_NCM, SIIT) %>% 
    summarise(gl = (1-(abs(EXP_VL_FOB-IMP_VL_FOB)/SOMA))*100) %>% 
    arrange(desc(gl)))

## JUNTAR BASE E INDICE
(XM_2005_SIIT <- inner_join(XM_2005_SIIT, GL_2005_SIIT, 
                            by=c("SG_UF_NCM", "SIIT")))

## ORDENAR
(XM_2005_SIIT <- XM_2005_SIIT %>% arrange(desc(EXP_VL_FOB)))

## TRANSFORMAR EM DATAFRAME
XM_2005_SIIT <- as.data.frame(XM_2005_SIIT)

## Exportando para um arquivo Excel:
write.csv2(XM_2005_SIIT, "mestrado_script/XM_2005_SIIT.csv")
write.csv2(GL_2005_SIIT, "mestrado_script/indice GL por SIIT-2005.csv")


### limpar dados
rm(list=ls(all=TRUE))


#---------------------------------------------------------------------------------
# IMPORTAR E FILTRAR BASE DE DADOS 2010
## importar
EXP_2010 <- read.csv2("mestrado_script/EXP_2010.csv")
IMP_2010 <- read.csv2("mestrado_script/IMP_2010.csv")

## filtrar
EXP_2010 <- select(EXP_2010, -X) # selecionar por column_name
IMP_2010 <- select(IMP_2010, -1) #selecionar por posicao ou "IMP_2010$X <- NULL"

# transformar a variaveis PPE e PPI em fatores:
## exportacao
EXP_2010$PPE <- as.factor(EXP_2010$PPE)
EXP_2010$CO_NCM <- as.factor(EXP_2010$CO_NCM)

## importacao
IMP_2010$PPI <- as.factor(IMP_2010$PPI)
IMP_2010$CO_NCM <- as.factor(IMP_2010$CO_NCM)

#-------------------------------------------------------------------------#
# FATOR AGREGADO - 2010
# indice de cada Produto da BC e Produtos Intraindustriais 2010:
#-------------------------------------------------------------------------#
## EXPORTACAO
## selecionar os produtos exportados:
EXP_2010_a <- select(EXP_2010, CO_NCM, VL_FOB, SG_UF_NCM, FAT_AGREG, PPE)
(EXP_2010_a <- EXP_2010_a %>% group_by(SG_UF_NCM, FAT_AGREG) %>% 
    filter(FAT_AGREG != "CONSUMO DE BORDO") %>% 
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

## renomear
(EXP_2010_a <- rename(EXP_2010_a, "EXP_VL_FOB"="VL_FOB"))

# TRANSFORMAR EM DATAFRAME
EXP_2010_a <- as.data.frame(EXP_2010_a)

#-------------------------------------------------------------------------#
# IMPORTACAO:
# criando base de dados anos 2010:
## selecionar os produtos importacao:
IMP_2010_a <- select(IMP_2010, CO_NCM, VL_FOB, SG_UF_NCM, FAT_AGREG, PPI)
(IMP_2010_a <- IMP_2010_a %>% group_by(SG_UF_NCM, FAT_AGREG) %>% 
    filter(FAT_AGREG != "CONSUMO DE BORDO") %>%
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

## renomear
(IMP_2010_a <- rename(IMP_2010_a, "IMP_VL_FOB"="VL_FOB"))

# TRANSFORMAR EM DATAFRAME
IMP_2010_a <- as.data.frame(IMP_2010_a)

#-------------------------------------------------------------------------#
## exportar planilha com valores agrupados:
write.csv2(EXP_2010_a, "mestrado_script/EXP_2010_A.csv")
write.csv2(IMP_2010_a, "mestrado_script/IMP_2010_A.csv")

#-------------------------------------------------------------------------#
# juntar base de dados BC 2010:
(XM_2010_a <- inner_join(EXP_2010_a, IMP_2010_a, 
                         by=c("SG_UF_NCM", "FAT_AGREG")))

# organizar variaveis:
XM_2010_a <- XM_2010_a %>% 
  select(SG_UF_NCM, FAT_AGREG, EXP_VL_FOB, IMP_VL_FOB)

# CRIANDO A COLUNA DE SOMA:
(XM_2010_a <- XM_2010_a %>% 
    group_by(SG_UF_NCM, FAT_AGREG, EXP_VL_FOB, IMP_VL_FOB) %>% 
    summarise(SOMA = (EXP_VL_FOB + IMP_VL_FOB)) %>% 
    arrange(desc(SOMA)))

#-------------------------------------------------------------------------#
# funcao para calcular o indice GL:
GL <- function(a,b){
  m <- data.frame(abs(a-b))       # modulo de "a" menos "b";
  s <- data.frame(a+b)            # soma de "a" mais "b";
  gl <- data.frame(((s-m)/s)*100)
  return(gl)
}

#-------------------------------------------------------------------------#
# calcular o indice de Grubel-Lloid (GL) XM_2010_a:
(GL_2010_a <- XM_2010_a %>% group_by(SG_UF_NCM, FAT_AGREG) %>% 
    summarise(gl = (1-(abs(EXP_VL_FOB-IMP_VL_FOB)/SOMA))*100) %>% 
    arrange(desc(gl)))


# JUNTANDO O FATOR AGREGADO E O INDICE
(XM_2010_a <- inner_join(XM_2010_a, GL_2010_a, 
                         by=c("SG_UF_NCM", "FAT_AGREG")))

# ORDENAR
(XM_2010_a <- XM_2010_a %>% arrange(desc(EXP_VL_FOB)))

# TRANFORMANDO EM DATAFRAME
XM_2010_a <- as.data.frame(XM_2010_a)

## Exportando para um arquivo Excel:
write.csv2(XM_2010_a, "mestrado_script/XM_2010_A.csv")
write.csv2(GL_2010_a, "mestrado_script/indice GL por Fator Agregado-2010.csv")

### limpar dados
rm(XM_2010_a, GL_2010_a, EXP_2010_a, IMP_2010_a)


#-------------------------------------------------------------------------#
#-------------------------------------------------------------------------#
# CGCE - 2010
# indice de cada Produto da BC e Produtos Intraindustriais 2010:
#-------------------------------------------------------------------------#
## EXPORTACAO
## selecionar os produtos exportados:
EXP_2010_CGCE <- select(EXP_2010, CO_NCM, VL_FOB, SG_UF_NCM, CGCE, PPE)
(EXP_2010_CGCE <- EXP_2010_CGCE %>% group_by(SG_UF_NCM, CGCE) %>% 
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

## renomear
(EXP_2010_CGCE <- rename(EXP_2010_CGCE, "EXP_VL_FOB"="VL_FOB"))

#-------------------------------------------------------------------------#
# IMPORTACAO:
# criando base de dados anos 2010:
## selecionar os produtos importacao:
IMP_2010_CGCE <- select(IMP_2010, CO_NCM, VL_FOB, SG_UF_NCM, CGCE, PPI)
(IMP_2010_CGCE <- IMP_2010_CGCE %>% 
    group_by(SG_UF_NCM, CGCE) %>% 
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

## renomear
(IMP_2010_CGCE <- rename(IMP_2010_CGCE, "IMP_VL_FOB"="VL_FOB"))

#-------------------------------------------------------------------------#
## exportar planilha com valores agrupados:
write.csv2(EXP_2010_CGCE, "mestrado_script/EXP_2010_CGCE.csv")
write.csv2(IMP_2010_CGCE, "mestrado_script/IMP_2010_CGCE.csv")

#-------------------------------------------------------------------------#
# juntar base de dados BC 2010:
(XM_2010_CGCE <- inner_join(EXP_2010_CGCE, IMP_2010_CGCE, 
                            by=c("SG_UF_NCM", "CGCE")))

## CRIAR COLUNA DE SOMA
(XM_2010_CGCE <- XM_2010_CGCE %>% 
    group_by(SG_UF_NCM, CGCE, EXP_VL_FOB, IMP_VL_FOB) %>% 
    summarise(SOMA = (EXP_VL_FOB + IMP_VL_FOB)) %>% 
    arrange(desc(SOMA)))

#-------------------------------------------------------------------------#
# funcao para calcular o indice GL:
GL <- function(a,b){
  m <- data.frame(abs(a-b))       # modulo de "a" menos "b";
  s <- data.frame(a+b)            # soma de "a" mais "b";
  gl <- data.frame(((s-m)/s)*100)
  return(gl)
}

#-------------------------------------------------------------------------#
# calcular o indice de Grubel-Lloid (GL) XM_2010_CGCE:
(GL_2010_CGCE <- XM_2010_CGCE %>% group_by(SG_UF_NCM, CGCE) %>% 
    summarise(gl = (1-(abs(EXP_VL_FOB-IMP_VL_FOB)/SOMA))*100) %>% 
    arrange(desc(gl)))

## JUNTAR BASE E INDICE
(XM_2010_CGCE <- inner_join(XM_2010_CGCE, GL_2010_CGCE, 
                            by=c("SG_UF_NCM", "CGCE")))

## ORDENAR
(XM_2010_CGCE <- XM_2010_CGCE %>% arrange(desc(EXP_VL_FOB)))

# TRANFORMANDO EM DATAFRAME
XM_2010_CGCE <- as.data.frame(XM_2010_CGCE)

## Exportando para um arquivo Excel:
write.csv2(XM_2010_CGCE, "mestrado_script/XM_2010_CGCE.csv")
write.csv2(GL_2010_CGCE, "mestrado_script/indice GL por CGCE-2010.csv")

### limpar dados
rm(XM_2010_CGCE, GL_2010_CGCE, EXP_2010_CGCE, IMP_2010_CGCE)


#-------------------------------------------------------------------------#
# ISIC - 2010
# indice de cada Produto da BC e Produtos Intraindustriais 2010:
#-------------------------------------------------------------------------#
## EXPORTACAO
## selecionar os produtos exportados:
EXP_2010_ISIC <- select(EXP_2010, CO_NCM, VL_FOB, SG_UF_NCM, ISIC, PPE)
(EXP_2010_ISIC <- EXP_2010_ISIC %>% 
    group_by(SG_UF_NCM, ISIC) %>% 
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

## renomear
(EXP_2010_ISIC <- rename(EXP_2010_ISIC, "EXP_VL_FOB"="VL_FOB"))

#-------------------------------------------------------------------------#
# IMPORTACAO:
# criando base de dados anos 2010:
## selecionar os produtos importacao:
IMP_2010_ISIC <- select(IMP_2010, CO_NCM, VL_FOB, SG_UF_NCM, ISIC, PPI)
(IMP_2010_ISIC <- IMP_2010_ISIC %>% 
    group_by(SG_UF_NCM, ISIC) %>% 
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

## renomear
(IMP_2010_ISIC <- rename(IMP_2010_ISIC, "IMP_VL_FOB"="VL_FOB"))

#-------------------------------------------------------------------------#
## exportar planilha com valores agrupados:
write.csv2(EXP_2010_ISIC, "mestrado_script/EXP_2010_ISIC.csv")
write.csv2(IMP_2010_ISIC, "mestrado_script/IMP_2010_ISIC.csv")

#-------------------------------------------------------------------------#
# juntar base de dados BC 2010:
(XM_2010_ISIC <- inner_join(EXP_2010_ISIC, IMP_2010_ISIC, 
                            by=c("SG_UF_NCM", "ISIC")))

## CRIAR A COLUNA SOMA
(XM_2010_ISIC <- XM_2010_ISIC %>% 
    group_by(SG_UF_NCM, ISIC, EXP_VL_FOB, IMP_VL_FOB) %>% 
    summarise(SOMA = (EXP_VL_FOB + IMP_VL_FOB)) %>% 
    arrange(desc(SOMA)))

## TRANSFORMAR EM DATAFRAME
(XM_2010_ISIC <- as.data.frame(XM_2010_ISIC))

#-------------------------------------------------------------------------#
# funcao para calcular o indice GL:
GL <- function(a,b){
  m <- data.frame(abs(a-b))       # modulo de "a" menos "b";
  s <- data.frame(a+b)            # soma de "a" mais "b";
  gl <- data.frame(((s-m)/s)*100)
  return(gl)
}

#-------------------------------------------------------------------------#
# calcular o indice de Grubel-Lloid (GL) XM_2010_ISIC:
(GL_2010_ISIC <- XM_2010_ISIC %>% group_by(SG_UF_NCM, ISIC) %>% 
    summarise(gl = (1-(abs(EXP_VL_FOB-IMP_VL_FOB)/SOMA))*100) %>% 
    arrange(desc(gl)))

## JUNTO BASE E INDICE
(XM_2010_ISIC <- inner_join(XM_2010_ISIC, GL_2010_ISIC, 
                            by=c("SG_UF_NCM", "ISIC")))

## ORDENAR
(XM_2010_ISIC <- XM_2010_ISIC %>% arrange(desc(EXP_VL_FOB)))

# TRANFORMANDO EM DATAFRAME
XM_2010_ISIC <- as.data.frame(XM_2010_ISIC)

## Exportando para um arquivo Excel:
write.csv2(XM_2010_ISIC, "mestrado_script/XM_2010_ISIC.csv")
write.csv2(GL_2010_ISIC, "mestrado_script/indice GL por ISIC-2010.csv")

### limpar dados
rm(XM_2010_ISIC, GL_2010_ISIC, EXP_2010_ISIC, IMP_2010_ISIC)


#-------------------------------------------------------------------------#
# SIIT - 2010
# indice de cada Produto da BC e Produtos Intraindustriais 2010:
#-------------------------------------------------------------------------#
## EXPORTACAO
## selecionar os produtos exportados:
EXP_2010_SIIT <- select(EXP_2010, CO_NCM, VL_FOB, SG_UF_NCM, SIIT, PPE)
(EXP_2010_SIIT <- EXP_2010_SIIT %>% 
    group_by(SG_UF_NCM, SIIT) %>% 
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

## renomear
(EXP_2010_SIIT <- rename(EXP_2010_SIIT, "EXP_VL_FOB"="VL_FOB"))

#-------------------------------------------------------------------------#
# IMPORTACAO:
# criando base de dados anos 2010:
## selecionar os produtos importacao:
IMP_2010_SIIT <- select(IMP_2010, CO_NCM, VL_FOB, SG_UF_NCM, SIIT, PPI)
(IMP_2010_SIIT <- IMP_2010_SIIT %>% 
    group_by(SG_UF_NCM, SIIT) %>% 
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

## renomear
(IMP_2010_SIIT <- rename(IMP_2010_SIIT, "IMP_VL_FOB"="VL_FOB"))

#-------------------------------------------------------------------------#
## exportar planilha com valores agrupados:
write.csv2(EXP_2010_SIIT, "mestrado_script/EXP_2010_SIIT.csv")
write.csv2(IMP_2010_SIIT, "mestrado_script/IMP_2010_SIIT.csv")

#-------------------------------------------------------------------------#
# juntar base de dados BC 2010:
(XM_2010_SIIT <- inner_join(EXP_2010_SIIT, IMP_2010_SIIT, 
                            by=c("SG_UF_NCM", "SIIT")))

## CRIAR COLUNA SOMA
(XM_2010_SIIT <- XM_2010_SIIT %>% 
    group_by(SG_UF_NCM, SIIT, EXP_VL_FOB, IMP_VL_FOB) %>% 
    summarise(SOMA = (EXP_VL_FOB + IMP_VL_FOB)) %>% 
    arrange(desc(SOMA)))

#-------------------------------------------------------------------------#
# funcao para calcular o indice GL:
GL <- function(a,b){
  m <- data.frame(abs(a-b))       # modulo de "a" menos "b";
  s <- data.frame(a+b)            # soma de "a" mais "b";
  gl <- data.frame(((s-m)/s)*100)
  return(gl)
}

#-------------------------------------------------------------------------#
# calcular o indice de Grubel-Lloid (GL) XM_2010_SIIT:
(GL_2010_SIIT <- XM_2010_SIIT %>% group_by(SG_UF_NCM, SIIT) %>% 
    summarise(gl = (1-(abs(EXP_VL_FOB-IMP_VL_FOB)/SOMA))*100) %>% 
    arrange(desc(gl)))

## JUNTAR BASE E INDICE
(XM_2010_SIIT <- inner_join(XM_2010_SIIT, GL_2010_SIIT, 
                            by=c("SG_UF_NCM", "SIIT")))

## ORDENAR
(XM_2010_SIIT <- XM_2010_SIIT %>% arrange(desc(EXP_VL_FOB)))

## TRANSFORMAR EM DATAFRAME
XM_2010_SIIT <- as.data.frame(XM_2010_SIIT)

## Exportando para um arquivo Excel:
write.csv2(XM_2010_SIIT, "mestrado_script/XM_2010_SIIT.csv")
write.csv2(GL_2010_SIIT, "mestrado_script/indice GL por SIIT-2010.csv")


### limpar dados
rm(list=ls(all=TRUE))


#---------------------------------------------------------------------------------
# IMPORTAR E FILTRAR BASE DE DADOS 2015
## importar
EXP_2015 <- read.csv2("mestrado_script/EXP_2015.csv")
IMP_2015 <- read.csv2("mestrado_script/IMP_2015.csv")

## filtrar
EXP_2015 <- select(EXP_2015, -X) # selecionar por column_name
IMP_2015 <- select(IMP_2015, -1) #selecionar por posicao ou "IMP_2015$X <- NULL"

# transformar a variaveis PPE e PPI em fatores:
## exportacao
EXP_2015$PPE <- as.factor(EXP_2015$PPE)
EXP_2015$CO_NCM <- as.factor(EXP_2015$CO_NCM)

## importacao
IMP_2015$PPI <- as.factor(IMP_2015$PPI)
IMP_2015$CO_NCM <- as.factor(IMP_2015$CO_NCM)

#-------------------------------------------------------------------------#
# FATOR AGREGADO - 2015
# indice de cada Produto da BC e Produtos Intraindustriais 2015:
#-------------------------------------------------------------------------#
## EXPORTACAO
## selecionar os produtos exportados:
EXP_2015_a <- select(EXP_2015, CO_NCM, VL_FOB, SG_UF_NCM, FAT_AGREG, PPE)
(EXP_2015_a <- EXP_2015_a %>% group_by(SG_UF_NCM, FAT_AGREG) %>% 
    filter(FAT_AGREG != "CONSUMO DE BORDO") %>% 
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

## renomear
(EXP_2015_a <- rename(EXP_2015_a, "EXP_VL_FOB"="VL_FOB"))

# TRANSFORMAR EM DATAFRAME
EXP_2015_a <- as.data.frame(EXP_2015_a)

#-------------------------------------------------------------------------#
# IMPORTACAO:
# criando base de dados anos 2015:
## selecionar os produtos importacao:
IMP_2015_a <- select(IMP_2015, CO_NCM, VL_FOB, SG_UF_NCM, FAT_AGREG, PPI)
(IMP_2015_a <- IMP_2015_a %>% group_by(SG_UF_NCM, FAT_AGREG) %>% 
    filter(FAT_AGREG != "CONSUMO DE BORDO") %>%
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

## renomear
(IMP_2015_a <- rename(IMP_2015_a, "IMP_VL_FOB"="VL_FOB"))

# TRANSFORMAR EM DATAFRAME
IMP_2015_a <- as.data.frame(IMP_2015_a)

#-------------------------------------------------------------------------#
## exportar planilha com valores agrupados:
write.csv2(EXP_2015_a, "mestrado_script/EXP_2015_A.csv")
write.csv2(IMP_2015_a, "mestrado_script/IMP_2015_A.csv")

#-------------------------------------------------------------------------#
# juntar base de dados BC 2015:
(XM_2015_a <- inner_join(EXP_2015_a, IMP_2015_a, 
                         by=c("SG_UF_NCM", "FAT_AGREG")))

# organizar variaveis:
XM_2015_a <- XM_2015_a %>% 
  select(SG_UF_NCM, FAT_AGREG, EXP_VL_FOB, IMP_VL_FOB)

# CRIANDO A COLUNA DE SOMA:
(XM_2015_a <- XM_2015_a %>% 
    group_by(SG_UF_NCM, FAT_AGREG, EXP_VL_FOB, IMP_VL_FOB) %>% 
    summarise(SOMA = (EXP_VL_FOB + IMP_VL_FOB)) %>% 
    arrange(desc(SOMA)))

#-------------------------------------------------------------------------#
# funcao para calcular o indice GL:
GL <- function(a,b){
  m <- data.frame(abs(a-b))       # modulo de "a" menos "b";
  s <- data.frame(a+b)            # soma de "a" mais "b";
  gl <- data.frame(((s-m)/s)*100)
  return(gl)
}

#-------------------------------------------------------------------------#
# calcular o indice de Grubel-Lloid (GL) XM_2015_a:
(GL_2015_a <- XM_2015_a %>% group_by(SG_UF_NCM, FAT_AGREG) %>% 
    summarise(gl = (1-(abs(EXP_VL_FOB-IMP_VL_FOB)/SOMA))*100) %>% 
    arrange(desc(gl)))


# JUNTANDO O FATOR AGREGADO E O INDICE
(XM_2015_a <- inner_join(XM_2015_a, GL_2015_a, 
                         by=c("SG_UF_NCM", "FAT_AGREG")))

# ORDENAR
(XM_2015_a <- XM_2015_a %>% arrange(desc(EXP_VL_FOB)))

# TRANFORMANDO EM DATAFRAME
XM_2015_a <- as.data.frame(XM_2015_a)

## Exportando para um arquivo Excel:
write.csv2(XM_2015_a, "mestrado_script/XM_2015_A.csv")
write.csv2(GL_2015_a, "mestrado_script/indice GL por Fator Agregado-2015.csv")

### limpar dados
rm(XM_2015_a, GL_2015_a, EXP_2015_a, IMP_2015_a)


#-------------------------------------------------------------------------#
#-------------------------------------------------------------------------#
# CGCE - 2015
# indice de cada Produto da BC e Produtos Intraindustriais 2015:
#-------------------------------------------------------------------------#
## EXPORTACAO
## selecionar os produtos exportados:
EXP_2015_CGCE <- select(EXP_2015, CO_NCM, VL_FOB, SG_UF_NCM, CGCE, PPE)
(EXP_2015_CGCE <- EXP_2015_CGCE %>% group_by(SG_UF_NCM, CGCE) %>% 
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

## renomear
(EXP_2015_CGCE <- rename(EXP_2015_CGCE, "EXP_VL_FOB"="VL_FOB"))

#-------------------------------------------------------------------------#
# IMPORTACAO:
# criando base de dados anos 2015:
## selecionar os produtos importacao:
IMP_2015_CGCE <- select(IMP_2015, CO_NCM, VL_FOB, SG_UF_NCM, CGCE, PPI)
(IMP_2015_CGCE <- IMP_2015_CGCE %>% 
    group_by(SG_UF_NCM, CGCE) %>% 
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

## renomear
(IMP_2015_CGCE <- rename(IMP_2015_CGCE, "IMP_VL_FOB"="VL_FOB"))

#-------------------------------------------------------------------------#
## exportar planilha com valores agrupados:
write.csv2(EXP_2015_CGCE, "mestrado_script/EXP_2015_CGCE.csv")
write.csv2(IMP_2015_CGCE, "mestrado_script/IMP_2015_CGCE.csv")

#-------------------------------------------------------------------------#
# juntar base de dados BC 2015:
(XM_2015_CGCE <- inner_join(EXP_2015_CGCE, IMP_2015_CGCE, 
                            by=c("SG_UF_NCM", "CGCE")))

## CRIAR COLUNA DE SOMA
(XM_2015_CGCE <- XM_2015_CGCE %>% 
    group_by(SG_UF_NCM, CGCE, EXP_VL_FOB, IMP_VL_FOB) %>% 
    summarise(SOMA = (EXP_VL_FOB + IMP_VL_FOB)) %>% 
    arrange(desc(SOMA)))

#-------------------------------------------------------------------------#
# funcao para calcular o indice GL:
GL <- function(a,b){
  m <- data.frame(abs(a-b))       # modulo de "a" menos "b";
  s <- data.frame(a+b)            # soma de "a" mais "b";
  gl <- data.frame(((s-m)/s)*100)
  return(gl)
}

#-------------------------------------------------------------------------#
# calcular o indice de Grubel-Lloid (GL) XM_2015_CGCE:
(GL_2015_CGCE <- XM_2015_CGCE %>% group_by(SG_UF_NCM, CGCE) %>% 
    summarise(gl = (1-(abs(EXP_VL_FOB-IMP_VL_FOB)/SOMA))*100) %>% 
    arrange(desc(gl)))

## JUNTAR BASE E INDICE
(XM_2015_CGCE <- inner_join(XM_2015_CGCE, GL_2015_CGCE, 
                            by=c("SG_UF_NCM", "CGCE")))

## ORDENAR
(XM_2015_CGCE <- XM_2015_CGCE %>% arrange(desc(EXP_VL_FOB)))

# TRANFORMANDO EM DATAFRAME
XM_2015_CGCE <- as.data.frame(XM_2015_CGCE)

## Exportando para um arquivo Excel:
write.csv2(XM_2015_CGCE, "mestrado_script/XM_2015_CGCE.csv")
write.csv2(GL_2015_CGCE, "mestrado_script/indice GL por CGCE-2015.csv")

### limpar dados
rm(XM_2015_CGCE, GL_2015_CGCE, EXP_2015_CGCE, IMP_2015_CGCE)


#-------------------------------------------------------------------------#
# ISIC - 2015
# indice de cada Produto da BC e Produtos Intraindustriais 2015:
#-------------------------------------------------------------------------#
## EXPORTACAO
## selecionar os produtos exportados:
EXP_2015_ISIC <- select(EXP_2015, CO_NCM, VL_FOB, SG_UF_NCM, ISIC, PPE)
(EXP_2015_ISIC <- EXP_2015_ISIC %>% 
    group_by(SG_UF_NCM, ISIC) %>% 
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

## renomear
(EXP_2015_ISIC <- rename(EXP_2015_ISIC, "EXP_VL_FOB"="VL_FOB"))

#-------------------------------------------------------------------------#
# IMPORTACAO:
# criando base de dados anos 2015:
## selecionar os produtos importacao:
IMP_2015_ISIC <- select(IMP_2015, CO_NCM, VL_FOB, SG_UF_NCM, ISIC, PPI)
(IMP_2015_ISIC <- IMP_2015_ISIC %>% 
    group_by(SG_UF_NCM, ISIC) %>% 
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

## renomear
(IMP_2015_ISIC <- rename(IMP_2015_ISIC, "IMP_VL_FOB"="VL_FOB"))

#-------------------------------------------------------------------------#
## exportar planilha com valores agrupados:
write.csv2(EXP_2015_ISIC, "mestrado_script/EXP_2015_ISIC.csv")
write.csv2(IMP_2015_ISIC, "mestrado_script/IMP_2015_ISIC.csv")

#-------------------------------------------------------------------------#
# juntar base de dados BC 2015:
(XM_2015_ISIC <- inner_join(EXP_2015_ISIC, IMP_2015_ISIC, 
                            by=c("SG_UF_NCM", "ISIC")))

## CRIAR A COLUNA SOMA
(XM_2015_ISIC <- XM_2015_ISIC %>% 
    group_by(SG_UF_NCM, ISIC, EXP_VL_FOB, IMP_VL_FOB) %>% 
    summarise(SOMA = (EXP_VL_FOB + IMP_VL_FOB)) %>% 
    arrange(desc(SOMA)))

## TRANSFORMAR EM DATAFRAME
(XM_2015_ISIC <- as.data.frame(XM_2015_ISIC))

#-------------------------------------------------------------------------#
# funcao para calcular o indice GL:
GL <- function(a,b){
  m <- data.frame(abs(a-b))       # modulo de "a" menos "b";
  s <- data.frame(a+b)            # soma de "a" mais "b";
  gl <- data.frame(((s-m)/s)*100)
  return(gl)
}

#-------------------------------------------------------------------------#
# calcular o indice de Grubel-Lloid (GL) XM_2015_ISIC:
(GL_2015_ISIC <- XM_2015_ISIC %>% group_by(SG_UF_NCM, ISIC) %>% 
    summarise(gl = (1-(abs(EXP_VL_FOB-IMP_VL_FOB)/SOMA))*100) %>% 
    arrange(desc(gl)))

## JUNTO BASE E INDICE
(XM_2015_ISIC <- inner_join(XM_2015_ISIC, GL_2015_ISIC, 
                            by=c("SG_UF_NCM", "ISIC")))

## ORDENAR
(XM_2015_ISIC <- XM_2015_ISIC %>% arrange(desc(EXP_VL_FOB)))

# TRANFORMANDO EM DATAFRAME
XM_2015_ISIC <- as.data.frame(XM_2015_ISIC)

## Exportando para um arquivo Excel:
write.csv2(XM_2015_ISIC, "mestrado_script/XM_2015_ISIC.csv")
write.csv2(GL_2015_ISIC, "mestrado_script/indice GL por ISIC-2015.csv")

### limpar dados
rm(XM_2015_ISIC, GL_2015_ISIC, EXP_2015_ISIC, IMP_2015_ISIC)


#-------------------------------------------------------------------------#
# SIIT - 2015
# indice de cada Produto da BC e Produtos Intraindustriais 2015:
#-------------------------------------------------------------------------#
## EXPORTACAO
## selecionar os produtos exportados:
EXP_2015_SIIT <- select(EXP_2015, CO_NCM, VL_FOB, SG_UF_NCM, SIIT, PPE)
(EXP_2015_SIIT <- EXP_2015_SIIT %>% 
    group_by(SG_UF_NCM, SIIT) %>% 
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

## renomear
(EXP_2015_SIIT <- rename(EXP_2015_SIIT, "EXP_VL_FOB"="VL_FOB"))

#-------------------------------------------------------------------------#
# IMPORTACAO:
# criando base de dados anos 2015:
## selecionar os produtos importacao:
IMP_2015_SIIT <- select(IMP_2015, CO_NCM, VL_FOB, SG_UF_NCM, SIIT, PPI)
(IMP_2015_SIIT <- IMP_2015_SIIT %>% 
    group_by(SG_UF_NCM, SIIT) %>% 
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

## renomear
(IMP_2015_SIIT <- rename(IMP_2015_SIIT, "IMP_VL_FOB"="VL_FOB"))

#-------------------------------------------------------------------------#
## exportar planilha com valores agrupados:
write.csv2(EXP_2015_SIIT, "mestrado_script/EXP_2015_SIIT.csv")
write.csv2(IMP_2015_SIIT, "mestrado_script/IMP_2015_SIIT.csv")

#-------------------------------------------------------------------------#
# juntar base de dados BC 2015:
(XM_2015_SIIT <- inner_join(EXP_2015_SIIT, IMP_2015_SIIT, 
                            by=c("SG_UF_NCM", "SIIT")))

## CRIAR COLUNA SOMA
(XM_2015_SIIT <- XM_2015_SIIT %>% 
    group_by(SG_UF_NCM, SIIT, EXP_VL_FOB, IMP_VL_FOB) %>% 
    summarise(SOMA = (EXP_VL_FOB + IMP_VL_FOB)) %>% 
    arrange(desc(SOMA)))

#-------------------------------------------------------------------------#
# funcao para calcular o indice GL:
GL <- function(a,b){
  m <- data.frame(abs(a-b))       # modulo de "a" menos "b";
  s <- data.frame(a+b)            # soma de "a" mais "b";
  gl <- data.frame(((s-m)/s)*100)
  return(gl)
}

#-------------------------------------------------------------------------#
# calcular o indice de Grubel-Lloid (GL) XM_2015_SIIT:
(GL_2015_SIIT <- XM_2015_SIIT %>% group_by(SG_UF_NCM, SIIT) %>% 
    summarise(gl = (1-(abs(EXP_VL_FOB-IMP_VL_FOB)/SOMA))*100) %>% 
    arrange(desc(gl)))

## JUNTAR BASE E INDICE
(XM_2015_SIIT <- inner_join(XM_2015_SIIT, GL_2015_SIIT, 
                            by=c("SG_UF_NCM", "SIIT")))

## ORDENAR
(XM_2015_SIIT <- XM_2015_SIIT %>% arrange(desc(EXP_VL_FOB)))

## TRANSFORMAR EM DATAFRAME
XM_2015_SIIT <- as.data.frame(XM_2015_SIIT)

## Exportando para um arquivo Excel:
write.csv2(XM_2015_SIIT, "mestrado_script/XM_2015_SIIT.csv")
write.csv2(GL_2015_SIIT, "mestrado_script/indice GL por SIIT-2015.csv")


### limpar dados
rm(list=ls(all=TRUE))


#---------------------------------------------------------------------------------
# IMPORTAR E FILTRAR BASE DE DADOS 2020
## importar
EXP_2020 <- read.csv2("mestrado_script/EXP_2020.csv")
IMP_2020 <- read.csv2("mestrado_script/IMP_2020.csv")

## filtrar
EXP_2020 <- select(EXP_2020, -X) # selecionar por column_name
IMP_2020 <- select(IMP_2020, -1) #selecionar por posicao ou "IMP_2020$X <- NULL"

# transformar a variaveis PPE e PPI em fatores:
## exportacao
EXP_2020$PPE <- as.factor(EXP_2020$PPE)
EXP_2020$CO_NCM <- as.factor(EXP_2020$CO_NCM)

## importacao
IMP_2020$PPI <- as.factor(IMP_2020$PPI)
IMP_2020$CO_NCM <- as.factor(IMP_2020$CO_NCM)

#-------------------------------------------------------------------------#
# FATOR AGREGADO - 2020
# indice de cada Produto da BC e Produtos Intraindustriais 2020:
#-------------------------------------------------------------------------#
## EXPORTACAO
## selecionar os produtos exportados:
EXP_2020_a <- select(EXP_2020, CO_NCM, VL_FOB, SG_UF_NCM, FAT_AGREG, PPE)
(EXP_2020_a <- EXP_2020_a %>% group_by(SG_UF_NCM, FAT_AGREG) %>% 
    filter(FAT_AGREG != "CONSUMO DE BORDO") %>% 
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

## renomear
(EXP_2020_a <- rename(EXP_2020_a, "EXP_VL_FOB"="VL_FOB"))

# TRANSFORMAR EM DATAFRAME
EXP_2020_a <- as.data.frame(EXP_2020_a)

#-------------------------------------------------------------------------#
# IMPORTACAO:
# criando base de dados anos 2020:
## selecionar os produtos importacao:
IMP_2020_a <- select(IMP_2020, CO_NCM, VL_FOB, SG_UF_NCM, FAT_AGREG, PPI)
(IMP_2020_a <- IMP_2020_a %>% group_by(SG_UF_NCM, FAT_AGREG) %>% 
    filter(FAT_AGREG != "CONSUMO DE BORDO") %>%
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

## renomear
(IMP_2020_a <- rename(IMP_2020_a, "IMP_VL_FOB"="VL_FOB"))

# TRANSFORMAR EM DATAFRAME
IMP_2020_a <- as.data.frame(IMP_2020_a)

#-------------------------------------------------------------------------#
## exportar planilha com valores agrupados:
write.csv2(EXP_2020_a, "mestrado_script/EXP_2020_A.csv")
write.csv2(IMP_2020_a, "mestrado_script/IMP_2020_A.csv")

#-------------------------------------------------------------------------#
# juntar base de dados BC 2020:
(XM_2020_a <- inner_join(EXP_2020_a, IMP_2020_a, 
                         by=c("SG_UF_NCM", "FAT_AGREG")))

# organizar variaveis:
XM_2020_a <- XM_2020_a %>% 
  select(SG_UF_NCM, FAT_AGREG, EXP_VL_FOB, IMP_VL_FOB)

# CRIANDO A COLUNA DE SOMA:
(XM_2020_a <- XM_2020_a %>% 
    group_by(SG_UF_NCM, FAT_AGREG, EXP_VL_FOB, IMP_VL_FOB) %>% 
    summarise(SOMA = (EXP_VL_FOB + IMP_VL_FOB)) %>% 
    arrange(desc(SOMA)))

#-------------------------------------------------------------------------#
# funcao para calcular o indice GL:
GL <- function(a,b){
  m <- data.frame(abs(a-b))       # modulo de "a" menos "b";
  s <- data.frame(a+b)            # soma de "a" mais "b";
  gl <- data.frame(((s-m)/s)*100)
  return(gl)
}

#-------------------------------------------------------------------------#
# calcular o indice de Grubel-Lloid (GL) XM_2020_a:
(GL_2020_a <- XM_2020_a %>% group_by(SG_UF_NCM, FAT_AGREG) %>% 
    summarise(gl = (1-(abs(EXP_VL_FOB-IMP_VL_FOB)/SOMA))*100) %>% 
    arrange(desc(gl)))


# JUNTANDO O FATOR AGREGADO E O INDICE
(XM_2020_a <- inner_join(XM_2020_a, GL_2020_a, 
                         by=c("SG_UF_NCM", "FAT_AGREG")))

# ORDENAR
(XM_2020_a <- XM_2020_a %>% arrange(desc(EXP_VL_FOB)))

# TRANFORMANDO EM DATAFRAME
XM_2020_a <- as.data.frame(XM_2020_a)

## Exportando para um arquivo Excel:
write.csv2(XM_2020_a, "mestrado_script/XM_2020_A.csv")
write.csv2(GL_2020_a, "mestrado_script/indice GL por Fator Agregado-2020.csv")

### limpar dados
rm(XM_2020_a, GL_2020_a, EXP_2020_a, IMP_2020_a)

#-------------------------------------------------------------------------#
# CGCE - 2020
# indice de cada Produto da BC e Produtos Intraindustriais 2020:
#-------------------------------------------------------------------------#
## EXPORTACAO
## selecionar os produtos exportados:
EXP_2020_CGCE <- select(EXP_2020, CO_NCM, VL_FOB, SG_UF_NCM, CGCE, PPE)
(EXP_2020_CGCE <- EXP_2020_CGCE %>% group_by(SG_UF_NCM, CGCE) %>% 
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

## renomear
(EXP_2020_CGCE <- rename(EXP_2020_CGCE, "EXP_VL_FOB"="VL_FOB"))

#-------------------------------------------------------------------------#
# IMPORTACAO:
# criando base de dados anos 2020:
## selecionar os produtos importacao:
IMP_2020_CGCE <- select(IMP_2020, CO_NCM, VL_FOB, SG_UF_NCM, CGCE, PPI)
(IMP_2020_CGCE <- IMP_2020_CGCE %>% 
    group_by(SG_UF_NCM, CGCE) %>% 
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

## renomear
(IMP_2020_CGCE <- rename(IMP_2020_CGCE, "IMP_VL_FOB"="VL_FOB"))

#-------------------------------------------------------------------------#
## exportar planilha com valores agrupados:
write.csv2(EXP_2020_CGCE, "mestrado_script/EXP_2020_CGCE.csv")
write.csv2(IMP_2020_CGCE, "mestrado_script/IMP_2020_CGCE.csv")

#-------------------------------------------------------------------------#
# juntar base de dados BC 2020:
(XM_2020_CGCE <- inner_join(EXP_2020_CGCE, IMP_2020_CGCE, 
                            by=c("SG_UF_NCM", "CGCE")))

## CRIAR COLUNA DE SOMA
(XM_2020_CGCE <- XM_2020_CGCE %>% 
    group_by(SG_UF_NCM, CGCE, EXP_VL_FOB, IMP_VL_FOB) %>% 
    summarise(SOMA = (EXP_VL_FOB + IMP_VL_FOB)) %>% 
    arrange(desc(SOMA)))

#-------------------------------------------------------------------------#
# funcao para calcular o indice GL:
GL <- function(a,b){
  m <- data.frame(abs(a-b))       # modulo de "a" menos "b";
  s <- data.frame(a+b)            # soma de "a" mais "b";
  gl <- data.frame(((s-m)/s)*100)
  return(gl)
}

#-------------------------------------------------------------------------#
# calcular o indice de Grubel-Lloid (GL) XM_2020_CGCE:
(GL_2020_CGCE <- XM_2020_CGCE %>% group_by(SG_UF_NCM, CGCE) %>% 
    summarise(gl = (1-(abs(EXP_VL_FOB-IMP_VL_FOB)/SOMA))*100) %>% 
    arrange(desc(gl)))

## JUNTAR BASE E INDICE
(XM_2020_CGCE <- inner_join(XM_2020_CGCE, GL_2020_CGCE, 
                            by=c("SG_UF_NCM", "CGCE")))

## ORDENAR
(XM_2020_CGCE <- XM_2020_CGCE %>% arrange(desc(EXP_VL_FOB)))

# TRANFORMANDO EM DATAFRAME
XM_2020_CGCE <- as.data.frame(XM_2020_CGCE)

## Exportando para um arquivo Excel:
write.csv2(XM_2020_CGCE, "mestrado_script/XM_2020_CGCE.csv")
write.csv2(GL_2020_CGCE, "mestrado_script/indice GL por CGCE-2020.csv")

### limpar dados
rm(XM_2020_CGCE, GL_2020_CGCE, EXP_2020_CGCE, IMP_2020_CGCE)


#-------------------------------------------------------------------------#
# ISIC - 2020
# indice de cada Produto da BC e Produtos Intraindustriais 2020:
#-------------------------------------------------------------------------#
## EXPORTACAO
## selecionar os produtos exportados:
EXP_2020_ISIC <- select(EXP_2020, CO_NCM, VL_FOB, SG_UF_NCM, ISIC, PPE)
(EXP_2020_ISIC <- EXP_2020_ISIC %>% 
    group_by(SG_UF_NCM, ISIC) %>% 
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

## renomear
(EXP_2020_ISIC <- rename(EXP_2020_ISIC, "EXP_VL_FOB"="VL_FOB"))

#-------------------------------------------------------------------------#
# IMPORTACAO:
# criando base de dados anos 2020:
## selecionar os produtos importacao:
IMP_2020_ISIC <- select(IMP_2020, CO_NCM, VL_FOB, SG_UF_NCM, ISIC, PPI)
(IMP_2020_ISIC <- IMP_2020_ISIC %>% 
    group_by(SG_UF_NCM, ISIC) %>% 
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

## renomear
(IMP_2020_ISIC <- rename(IMP_2020_ISIC, "IMP_VL_FOB"="VL_FOB"))

#-------------------------------------------------------------------------#
## exportar planilha com valores agrupados:
write.csv2(EXP_2020_ISIC, "mestrado_script/EXP_2020_ISIC.csv")
write.csv2(IMP_2020_ISIC, "mestrado_script/IMP_2020_ISIC.csv")

#-------------------------------------------------------------------------#
# juntar base de dados BC 2020:
(XM_2020_ISIC <- inner_join(EXP_2020_ISIC, IMP_2020_ISIC, 
                            by=c("SG_UF_NCM", "ISIC")))

## CRIAR A COLUNA SOMA
(XM_2020_ISIC <- XM_2020_ISIC %>% 
    group_by(SG_UF_NCM, ISIC, EXP_VL_FOB, IMP_VL_FOB) %>% 
    summarise(SOMA = (EXP_VL_FOB + IMP_VL_FOB)) %>% 
    arrange(desc(SOMA)))

## TRANSFORMAR EM DATAFRAME
(XM_2020_ISIC <- as.data.frame(XM_2020_ISIC))

#-------------------------------------------------------------------------#
# funcao para calcular o indice GL:
GL <- function(a,b){
  m <- data.frame(abs(a-b))       # modulo de "a" menos "b";
  s <- data.frame(a+b)            # soma de "a" mais "b";
  gl <- data.frame(((s-m)/s)*100)
  return(gl)
}

#-------------------------------------------------------------------------#
# calcular o indice de Grubel-Lloid (GL) XM_2020_ISIC:
(GL_2020_ISIC <- XM_2020_ISIC %>% group_by(SG_UF_NCM, ISIC) %>% 
    summarise(gl = (1-(abs(EXP_VL_FOB-IMP_VL_FOB)/SOMA))*100) %>% 
    arrange(desc(gl)))

## JUNTO BASE E INDICE
(XM_2020_ISIC <- inner_join(XM_2020_ISIC, GL_2020_ISIC, 
                            by=c("SG_UF_NCM", "ISIC")))

## ORDENAR
(XM_2020_ISIC <- XM_2020_ISIC %>% arrange(desc(EXP_VL_FOB)))

# TRANFORMANDO EM DATAFRAME
XM_2020_ISIC <- as.data.frame(XM_2020_ISIC)

## Exportando para um arquivo Excel:
write.csv2(XM_2020_ISIC, "mestrado_script/XM_2020_ISIC.csv")
write.csv2(GL_2020_ISIC, "mestrado_script/indice GL por ISIC-2020.csv")

### limpar dados
rm(XM_2020_ISIC, GL_2020_ISIC, EXP_2020_ISIC, IMP_2020_ISIC)


#-------------------------------------------------------------------------#
# SIIT - 2020
# indice de cada Produto da BC e Produtos Intraindustriais 2020:
#-------------------------------------------------------------------------#
## EXPORTACAO
## selecionar os produtos exportados:
EXP_2020_SIIT <- select(EXP_2020, CO_NCM, VL_FOB, SG_UF_NCM, SIIT, PPE)
(EXP_2020_SIIT <- EXP_2020_SIIT %>% 
    group_by(SG_UF_NCM, SIIT) %>% 
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

## renomear
(EXP_2020_SIIT <- rename(EXP_2020_SIIT, "EXP_VL_FOB"="VL_FOB"))

#-------------------------------------------------------------------------#
# IMPORTACAO:
# criando base de dados anos 2020:
## selecionar os produtos importacao:
IMP_2020_SIIT <- select(IMP_2020, CO_NCM, VL_FOB, SG_UF_NCM, SIIT, PPI)
(IMP_2020_SIIT <- IMP_2020_SIIT %>% 
    group_by(SG_UF_NCM, SIIT) %>% 
    summarise(VL_FOB=sum(VL_FOB)) %>% 
    arrange(desc(VL_FOB)))

## renomear
(IMP_2020_SIIT <- rename(IMP_2020_SIIT, "IMP_VL_FOB"="VL_FOB"))

#-------------------------------------------------------------------------#
## exportar planilha com valores agrupados:
write.csv2(EXP_2020_SIIT, "mestrado_script/EXP_2020_SIIT.csv")
write.csv2(IMP_2020_SIIT, "mestrado_script/IMP_2020_SIIT.csv")

#-------------------------------------------------------------------------#
# juntar base de dados BC 2020:
(XM_2020_SIIT <- inner_join(EXP_2020_SIIT, IMP_2020_SIIT, 
                            by=c("SG_UF_NCM", "SIIT")))

## CRIAR COLUNA SOMA
(XM_2020_SIIT <- XM_2020_SIIT %>% 
    group_by(SG_UF_NCM, SIIT, EXP_VL_FOB, IMP_VL_FOB) %>% 
    summarise(SOMA = (EXP_VL_FOB + IMP_VL_FOB)) %>% 
    arrange(desc(SOMA)))

#-------------------------------------------------------------------------#
# funcao para calcular o indice GL:
GL <- function(a,b){
  m <- data.frame(abs(a-b))       # modulo de "a" menos "b";
  s <- data.frame(a+b)            # soma de "a" mais "b";
  gl <- data.frame(((s-m)/s)*100)
  return(gl)
}

#-------------------------------------------------------------------------#
# calcular o indice de Grubel-Lloid (GL) XM_2020_SIIT:
(GL_2020_SIIT <- XM_2020_SIIT %>% group_by(SG_UF_NCM, SIIT) %>% 
    summarise(gl = (1-(abs(EXP_VL_FOB-IMP_VL_FOB)/SOMA))*100) %>% 
    arrange(desc(gl)))

## JUNTAR BASE E INDICE
(XM_2020_SIIT <- inner_join(XM_2020_SIIT, GL_2020_SIIT, 
                            by=c("SG_UF_NCM", "SIIT")))

## ORDENAR
(XM_2020_SIIT <- XM_2020_SIIT %>% arrange(desc(EXP_VL_FOB)))

## TRANSFORMAR EM DATAFRAME
XM_2020_SIIT <- as.data.frame(XM_2020_SIIT)

## Exportando para um arquivo Excel:
write.csv2(XM_2020_SIIT, "mestrado_script/XM_2020_SIIT.csv")
write.csv2(GL_2020_SIIT, "mestrado_script/indice GL por SIIT-2020.csv")

### limpar dados
rm(list=ls(all=TRUE))


#---------------------------------------------------------------------------------
# IMPORTAR INDICES E CRIANDO MAPAS
## IMPORTAR INDICES DE FATOR AGREGADO

(GL_2000_FA <- read.csv2("mestrado_script/indice GL por Fator Agregado-2000.csv") %>%
   select("SG_UF_NCM", "FAT_AGREG", "gl") %>% 
   rename("GL_2000"="gl"))

(GL_2005_FA <- read.csv2("mestrado_script/indice GL por Fator Agregado-2005.csv") %>%
    select("SG_UF_NCM", "FAT_AGREG", "gl") %>% 
    rename("GL_2005"="gl"))

(GL_2010_FA <- read.csv2("mestrado_script/indice GL por Fator Agregado-2010.csv") %>% 
    select("SG_UF_NCM", "FAT_AGREG", "gl") %>% 
    rename("GL_2010"="gl"))

(GL_2015_FA <- read.csv2("mestrado_script/indice GL por Fator Agregado-2015.csv") %>% 
    select("SG_UF_NCM", "FAT_AGREG", "gl") %>% 
    rename("GL_2015"="gl"))

(GL_2020_FA <- read.csv2("mestrado_script/indice GL por Fator Agregado-2020.csv") %>% 
    select("SG_UF_NCM", "FAT_AGREG", "gl") %>% 
    rename("GL_2020"="gl"))

## LIMPAR BASE
GL_2000_FA <- filter(GL_2000_FA, GL_2000 >= 50)
GL_2005_FA <- filter(GL_2005_FA, GL_2005 >= 50)
GL_2010_FA <- filter(GL_2010_FA, GL_2010 >= 50)
GL_2015_FA <- filter(GL_2015_FA, GL_2015 >= 50)
GL_2020_FA <- filter(GL_2020_FA, GL_2020 >= 50)

## JUNTAR BASES
GL_FA <- full_join(GL_2000_FA, GL_2005_FA, by = c("SG_UF_NCM", "FAT_AGREG"))
GL_FA <- full_join(GL_FA, GL_2010_FA, by = c("SG_UF_NCM", "FAT_AGREG"))
GL_FA <- full_join(GL_FA, GL_2015_FA, by = c("SG_UF_NCM", "FAT_AGREG"))
GL_FA <- full_join(GL_FA, GL_2020_FA, by = c("SG_UF_NCM", "FAT_AGREG"))

## ARRUMAR
GL_FA <- arrange(GL_FA, SG_UF_NCM)

# RENOMEAR OBSERVACOES
(GL_FA <- GL_FA %>% 
    mutate(FAT_AGREG = recode(FAT_AGREG, "PRODUTOS SEMIMANUFATURADOS" = "Semimanufaturados")))
(GL_FA <- GL_FA %>% 
    mutate(FAT_AGREG = recode(FAT_AGREG, "PRODUTOS BASICOS" = "Básicos")))
(GL_FA <- GL_FA %>% 
    mutate(FAT_AGREG = recode(FAT_AGREG, "PRODUTOS MANUFATURADOS" = "Manufaturados")))

## exportar planilha com valores agrupados:
write.csv2(GL_FA, "mestrado_script/GL_FA_T.csv")

#------------------------------------------------------------#
# CRIAR MAPA AQUI
## BAIXAR BASE DO MAPA
(BRA <- ne_states(country = "Brazil", returnclass = "sf"))

(FA <- read.csv2("mestrado_script/GL_FA_T.csv") %>% 
    select("SG_UF_NCM":"GL_2020"))

# renomear os dados missing
FA$GL_2000[is.na(FA$GL_2000)] <- "NA"
FA$GL_2005[is.na(FA$GL_2005)] <- "NA"
FA$GL_2010[is.na(FA$GL_2010)] <- "NA"
FA$GL_2015[is.na(FA$GL_2015)] <- "NA"
FA$GL_2020[is.na(FA$GL_2020)] <- "NA"

(GL <- full_join(BRA, FA, by = c("postal" = "SG_UF_NCM")))

#------------------------------------------------------------#
(FA_2000 <- ggplot(GL) +
    aes(fill = GL_2000, group = name) +
    geom_sf(shape = "circle", size = 0.15) +
    geom_sf_label(aes(label = postal),
                  label.padding = unit(0.8, "mm"),
                  size = 2) +
    scale_fill_manual(
      values = list(
        `Manufaturados` = "#66C2A5",
        `Básicos` = "#AB98C8",
        `Semimanufaturados` = "#E1D83B",
        `NA` = "#FFFFFF")
    ) +
    # colocando a localizacao da escala
    annotation_scale(location="br", height = unit(0.2, "cm")) +
    # colocar a indicador do norte, estilo, altura e largura
    annotation_north_arrow(location="tr",
                           style = north_arrow_nautical,
                           height = unit(1.5,"cm"),
                           width = unit(1.5,"cm")) +
    labs(x = "Latitude", y = "Longitude", 
         title = "2000",
         # "Indice GL dos Estados Brasileiros, por Grandes \nCategorias Econ?micas, 2000"
         subtitle = "Dia 10/09/2021",
         fill="FA",    # titulo da legenda
         caption = "Fonte: Elaborado pelo autor, dados do SECINT e SEPEC (2021).",
         x=NULL,
         y=NULL) +   # legenda dos eixos, deixar sem lagendas
    theme_bw() +   # colocar fundo branco no mapa
    theme(legend.position = c(0.18, 0.2),  # colocar a legenda em outra localizacao
          legend.key.size = unit(4,"mm"),  # reduzir o tamanho da legenda
          plot.title = element_text(size = 12L, face = "bold", hjust = 0.5),
          plot.caption = element_text(size = 10, hjust = 0), # hjust-ajustar na horizontal e vjust-ajustar na vertical
          plot.subtitle = element_text(size = 10),
          legend.title = element_text(size = 10),
          legend.text = element_text(size = 9)))

# salvando o plot do grafico e png
ggsave(plot = FA_2000, 
       filename = "mestrado_script/mapa/Mapa_FA_2000.png",
       width = 5, height = 5)

#------------------------------------------------------------#
(FA_2005 <- ggplot(GL) +
    aes(fill = GL_2005, group = name) +
    geom_sf(shape = "circle", size = 0.15) +
    geom_sf_label(aes(label = postal),
                  label.padding = unit(0.8, "mm"),
                  size = 2) +
    scale_fill_manual(
      values = list(
        `Manufaturados` = "#66C2A5",
        `Básicos` = "#AB98C8",
        `Semimanufaturados` = "#E1D83B",
        `NA` = "#FFFFFF")
    ) +
    # colocando a localizacao da escala
    annotation_scale(location="br", height = unit(0.2, "cm")) +
    # colocar a indicador do norte, estilo, altura e largura
    annotation_north_arrow(location="tr",
                           style = north_arrow_nautical,
                           height = unit(1.5,"cm"),
                           width = unit(1.5,"cm")) +
    labs(x = "Latitude", y = "Longitude", 
         title = "2005",
         # "Indice GL dos Estados Brasileiros, por Grandes \nCategorias Econ?micas, 2000"
         subtitle = "Dia 10/09/2021",
         fill="FA",    # titulo da legenda
         caption = "Fonte: Elaborado pelo autor, dados do SECINT e SEPEC (2021).",
         x=NULL,
         y=NULL) +   # legenda dos eixos, deixar sem lagendas
    theme_bw() +   # colocar fundo branco no mapa
    theme(legend.position = c(0.18, 0.2),  # colocar a legenda em outra localizacao
          legend.key.size = unit(4,"mm"),  # reduzir o tamanho da legenda
          plot.title = element_text(size = 12L, face = "bold", hjust = 0.5),
          plot.caption = element_text(size = 10, hjust = 0), # hjust-ajustar na horizontal e vjust-ajustar na vertical
          plot.subtitle = element_text(size = 10),
          legend.title = element_text(size = 10),
          legend.text = element_text(size = 9)))

# salvando o plot do grafico e png
ggsave(plot = FA_2005, 
       filename = "mestrado_script/mapa/Mapa_FA_2005.png",
       width = 5, height = 5)

#------------------------------------------------------------#
FA_2010 <- ggplot(GL) +
  aes(fill = GL_2010, group = name) +
  geom_sf(shape = "circle", size = 0.15) +
  geom_sf_label(aes(label = postal),
                label.padding = unit(0.8, "mm"),
                size = 2) +
  scale_fill_manual(
    values = list(
      `Manufaturados` = "#66C2A5",
      `Básicos` = "#AB98C8",
      `Semimanufaturados` = "#E1D83B",
      `NA` = "#FFFFFF")
  ) +
  # colocando a localizacao da escala
  annotation_scale(location="br", height = unit(0.2, "cm")) +
  # colocar a indicador do norte, estilo, altura e largura
  annotation_north_arrow(location="tr",
                         style = north_arrow_nautical,
                         height = unit(1.5,"cm"),
                         width = unit(1.5,"cm")) +
  labs(x = "Latitude", y = "Longitude", 
       title = "2010",
       # "Indice GL dos Estados Brasileiros, por Grandes \nCategorias Econ?micas, 2000"
       subtitle = "Dia 10/09/2021",
       fill="FA",    # titulo da legenda
       caption = "Fonte: Elaborado pelo autor, dados do SECINT e SEPEC (2021).",
       x=NULL,
       y=NULL) +   # legenda dos eixos, deixar sem lagendas
  theme_bw() +   # colocar fundo branco no mapa
  theme(legend.position = c(0.18, 0.2),  # colocar a legenda em outra localizacao
        legend.key.size = unit(4,"mm"),  # reduzir o tamanho da legenda
        plot.title = element_text(size = 12L, face = "bold", hjust = 0.5),
        plot.caption = element_text(size = 10, hjust = 0), # hjust-ajustar na horizontal e vjust-ajustar na vertical
        plot.subtitle = element_text(size = 10),
        legend.title = element_text(size = 10),
        legend.text = element_text(size = 9))

# salvando o plot do grafico e png
ggsave(plot = FA_2010, 
       filename = "mestrado_script/mapa/Mapa_FA_2010.png",
       width = 5, height = 5)

#------------------------------------------------------------#
FA_2015 <- ggplot(GL) +
  aes(fill = GL_2015, group = name) +
  geom_sf(shape = "circle", size = 0.15) +
  geom_sf_label(aes(label = postal),
                label.padding = unit(0.8, "mm"),
                size = 2) +
  scale_fill_manual(
    values = list(
      `Manufaturados` = "#66C2A5",
      `Básicos` = "#AB98C8",
      `Semimanufaturados` = "#E1D83B",
      `NA` = "#FFFFFF")
  ) +
  # colocando a localizacao da escala
  annotation_scale(location="br", height = unit(0.2, "cm")) +
  # colocar a indicador do norte, estilo, altura e largura
  annotation_north_arrow(location="tr",
                         style = north_arrow_nautical,
                         height = unit(1.5,"cm"),
                         width = unit(1.5,"cm")) +
  labs(x = "Latitude", y = "Longitude", 
       title = "2015",
       # "Indice GL dos Estados Brasileiros, por Grandes \nCategorias Econ?micas, 2000"
       subtitle = "Dia 10/09/2021",
       fill="FA",    # titulo da legenda
       caption = "Fonte: Elaborado pelo autor, dados do SECINT e SEPEC (2021).",
       x=NULL,
       y=NULL) +   # legenda dos eixos, deixar sem lagendas
  theme_bw() +   # colocar fundo branco no mapa
  theme(legend.position = c(0.18, 0.2),  # colocar a legenda em outra localizacao
        legend.key.size = unit(4,"mm"),  # reduzir o tamanho da legenda
        plot.title = element_text(size = 12L, face = "bold", hjust = 0.5),
        plot.caption = element_text(size = 10, hjust = 0), # hjust-ajustar na horizontal e vjust-ajustar na vertical
        plot.subtitle = element_text(size = 10),
        legend.title = element_text(size = 10),
        legend.text = element_text(size = 9))

# salvando o plot do grafico e png
ggsave(plot = FA_2015, 
       filename = "mestrado_script/mapa/Mapa_FA_2015.png",
       width = 5, height = 5)

#------------------------------------------------------------#
FA_2020 <- ggplot(GL) +
  aes(fill = GL_2020, group = name) +
  geom_sf(shape = "circle", size = 0.15) +
  geom_sf_label(aes(label = postal),
                label.padding = unit(0.8, "mm"),
                size = 2) +
  scale_fill_manual(
    values = list(
      `Manufaturados` = "#66C2A5",
      `Básicos` = "#AB98C8",
      `Semimanufaturados` = "#E1D83B",
      `NA` = "#FFFFFF")
  ) +
  # colocando a localizacao da escala
  annotation_scale(location="br", height = unit(0.2, "cm")) +
  # colocar a indicador do norte, estilo, altura e largura
  annotation_north_arrow(location="tr",
                         style = north_arrow_nautical,
                         height = unit(1.5,"cm"),
                         width = unit(1.5,"cm")) +
  labs(x = "Latitude", y = "Longitude", 
       title = "2020",
       # "Indice GL dos Estados Brasileiros, por Grandes \nCategorias Econ?micas, 2000"
       subtitle = "Dia 10/09/2021",
       fill="FA",    # titulo da legenda
       caption = "Fonte: Elaborado pelo autor, dados do SECINT e SEPEC (2021).",
       x=NULL,
       y=NULL) +   # legenda dos eixos, deixar sem lagendas
  theme_bw() +   # colocar fundo branco no mapa
  theme(legend.position = c(0.18, 0.2),  # colocar a legenda em outra localizacao
        legend.key.size = unit(4,"mm"),  # reduzir o tamanho da legenda
        plot.title = element_text(size = 12L, face = "bold", hjust = 0.5),
        plot.caption = element_text(size = 10, hjust = 0), # hjust-ajustar na horizontal e vjust-ajustar na vertical
        plot.subtitle = element_text(size = 10),
        legend.title = element_text(size = 10),
        legend.text = element_text(size = 9))

# salvando o plot do grafico e png
ggsave(plot = FA_2020, 
       filename = "mestrado_script/mapa/Mapa_FA_2020.png",
       width = 5, height = 5)

#------------------------------------------------------------#
# juntar mapas em um unico arquivo
## Plotando todos
grid.arrange(FA_2000, FA_2005, FA_2010, 
             FA_2015, FA_2020,
             ncol=3, nrow=2)

(Mapa_FA <- grid.arrange(FA_2000, FA_2005, FA_2010, 
                         FA_2015, FA_2020,
                         ncol=3, nrow=2))

# salvando o plot do grafico e png
ggsave(plot = Mapa_FA, 
       filename = "mestrado_script/mapa/Mapa_FA_2000_2020.png",
       width = 15, height = 10)

### limpar dados
rm(list=ls(all=TRUE))

#-----------------------------------------------------#
# IMPORTAR INDICES DE CGCE
(GL_2000_CGCE <- read.csv2("mestrado_script/indice GL por CGCE-2000.csv") %>%
    select("SG_UF_NCM", "CGCE", "gl") %>% 
    rename("GL_2000"="gl"))

(GL_2005_CGCE <- read.csv2("mestrado_script/indice GL por CGCE-2005.csv") %>%
    select("SG_UF_NCM", "CGCE", "gl") %>% 
    rename("GL_2005"="gl"))

(GL_2010_CGCE <- read.csv2("mestrado_script/indice GL por CGCE-2010.csv") %>% 
    select("SG_UF_NCM", "CGCE", "gl") %>% 
    rename("GL_2010"="gl"))

(GL_2015_CGCE <- read.csv2("mestrado_script/indice GL por CGCE-2015.csv") %>% 
    select("SG_UF_NCM", "CGCE", "gl") %>% 
    rename("GL_2015"="gl"))

(GL_2020_CGCE <- read.csv2("mestrado_script/indice GL por CGCE-2020.csv") %>% 
    select("SG_UF_NCM", "CGCE", "gl") %>% 
    rename("GL_2020"="gl"))

## LIMPAR BASE
GL_2000_CGCE <- filter(GL_2000_CGCE, GL_2000 >= 50)
GL_2005_CGCE <- filter(GL_2005_CGCE, GL_2005 >= 50)
GL_2010_CGCE <- filter(GL_2010_CGCE, GL_2010 >= 50)
GL_2015_CGCE <- filter(GL_2015_CGCE, GL_2015 >= 50)
GL_2020_CGCE <- filter(GL_2020_CGCE, GL_2020 >= 50)

## JUNTAR BASES
GL_CGCE <- full_join(GL_2000_CGCE, GL_2005_CGCE, by = c("SG_UF_NCM", "CGCE"))
GL_CGCE <- full_join(GL_CGCE, GL_2010_CGCE, by = c("SG_UF_NCM", "CGCE"))
GL_CGCE <- full_join(GL_CGCE, GL_2015_CGCE, by = c("SG_UF_NCM", "CGCE"))
GL_CGCE <- full_join(GL_CGCE, GL_2020_CGCE, by = c("SG_UF_NCM", "CGCE"))

## ARRUMAR
GL_CGCE <- arrange(GL_CGCE, SG_UF_NCM)

# RENOMEAR OBSERVACOES
(GL_CGCE <- GL_CGCE %>% 
    mutate(CGCE = recode(CGCE, "BENS INTERMEDI?RIOS (BI)" = "BI")))
(GL_CGCE <- GL_CGCE %>% 
    mutate(CGCE = recode(CGCE, "BENS DE CAPITAL (BK)" = "BK")))
(GL_CGCE <- GL_CGCE %>% 
    mutate(CGCE = recode(CGCE, "BENS DE CONSUMO (BC)" = "BC")))

## exportar planilha com valores agrupados:
write.csv2(GL_CGCE, "mestrado_script/GL_CGCE_T.csv")

#------------------------------------------------------------#
# CRIAR MAPA AQUI
## BAIXAR BASE DO MAPA
(BRA <- ne_states(country = "Brazil", returnclass = "sf"))

(CGCE <- read.csv2("mestrado_script/GL_CGCE_T.csv") %>% 
    select("SG_UF_NCM":"GL_2020"))

# renomear os dados missing
CGCE$GL_2000[is.na(CGCE$GL_2000)] <- "NA"
CGCE$GL_2005[is.na(CGCE$GL_2005)] <- "NA"
CGCE$GL_2010[is.na(CGCE$GL_2010)] <- "NA"
CGCE$GL_2015[is.na(CGCE$GL_2015)] <- "NA"
CGCE$GL_2020[is.na(CGCE$GL_2020)] <- "NA"

(GL <- full_join(BRA, CGCE, by = c("postal" = "SG_UF_NCM")))


#------------------------------------------------------------#
(CGCE_2000 <- ggplot(GL) +
  aes(fill = GL_2000, group = name) +
  geom_sf(shape = "circle", size = 0.15) +
  geom_sf_label(aes(label = postal),
                label.padding = unit(0.8, "mm"),
                size = 2) +
  scale_fill_manual(
    values = list(
      `BK` = "#66C2A5",
      `BI` = "#AB98C8",
      `BC` = "#E1D83B",
      `NA` = "#FFFFFF")
  ) +
  # colocando a localizacao da escala
  annotation_scale(location="br", height = unit(0.2, "cm")) +
  # colocar a indicador do norte, estilo, altura e largura
  annotation_north_arrow(location="tr",
                         style = north_arrow_nautical,
                         height = unit(1.5,"cm"),
                         width = unit(1.5,"cm")) +
  labs(x = "Latitude", y = "Longitude", 
       title = "2000",
       # "Indice GL dos Estados Brasileiros, por Grandes \nCategorias Econômicas, 2000"
       subtitle = "Dia 10/09/2021",
       fill="CGCE",    # titulo da legenda
       caption = "Fonte: Elaborado pelo autor, dados do SECINT e SEPEC (2021).",
       x=NULL,
       y=NULL) +   # legenda dos eixos, deixar sem lagendas
  theme_bw() +   # colocar fundo branco no mapa
  theme(legend.position = c(0.18, 0.2),  # colocar a legenda em outra localizacao
        legend.key.size = unit(4,"mm"),  # reduzir o tamanho da legenda
        plot.title = element_text(size = 12L, face = "bold", hjust = 0.5),
        plot.caption = element_text(size = 10, hjust = 0), # hjust-ajustar na horizontal e vjust-ajustar na vertical
        plot.subtitle = element_text(size = 10),
        legend.title = element_text(size = 10),
        legend.text = element_text(size = 9)))

# salvando o plot do grafico e png
ggsave(plot = CGCE_2000, 
       filename = "mestrado_script/mapa/Mapa_CGCE_2000.png",
       width = 5, height = 5)

#------------------------------------------------------------#
(CGCE_2005 <- ggplot(GL) +
  aes(fill = GL_2005, group = name) +
  geom_sf(shape = "circle", size = 0.15) +
  geom_sf_label(aes(label = postal),
                label.padding = unit(0.8, "mm"),
                size = 2) +
  scale_fill_manual(
    values = list(
      `BK` = "#66C2A5",
      `BI` = "#AB98C8",
      `BC` = "#E1D83B",
      `NA` = "#FFFFFF")
  ) +
  # colocando a localizacao da escala
  annotation_scale(location="br", height = unit(0.2, "cm")) +
  # colocar a indicador do norte, estilo, altura e largura
  annotation_north_arrow(location="tr",
                         style = north_arrow_nautical,
                         height = unit(1.5,"cm"),
                         width = unit(1.5,"cm")) +
  labs(x = "Latitude", y = "Longitude", 
       title = "2005",
       # "Indice GL dos Estados Brasileiros, por Grandes \nCategorias Econômicas, 2000"
       subtitle = "Dia 10/09/2021",
       fill="CGCE",    # titulo da legenda
       caption = "Fonte: Elaborado pelo autor, dados do SECINT e SEPEC (2021).",
       x=NULL,
       y=NULL) +   # legenda dos eixos, deixar sem lagendas
  theme_bw() +   # colocar fundo branco no mapa
  theme(legend.position = c(0.18, 0.2),  # colocar a legenda em outra localizacao
        legend.key.size = unit(4,"mm"),  # reduzir o tamanho da legenda
        plot.title = element_text(size = 12L, face = "bold", hjust = 0.5),
        plot.caption = element_text(size = 10, hjust = 0), # hjust-ajustar na horizontal e vjust-ajustar na vertical
        plot.subtitle = element_text(size = 10),
        legend.title = element_text(size = 10),
        legend.text = element_text(size = 9)))

# salvando o plot do grafico e png
ggsave(plot = CGCE_2005, 
       filename = "mestrado_script/mapa/Mapa_CGCE_2005.png",
       width = 5, height = 5)

#------------------------------------------------------------#
CGCE_2010 <- ggplot(GL) +
  aes(fill = GL_2010, group = name) +
  geom_sf(shape = "circle", size = 0.15) +
  geom_sf_label(aes(label = postal),
                label.padding = unit(0.8, "mm"),
                size = 2) +
  scale_fill_manual(
    values = list(
      `BK` = "#66C2A5",
      `BI` = "#AB98C8",
      `BC` = "#E1D83B",
      `NA` = "#FFFFFF")
  ) +
  # colocando a localizacao da escala
  annotation_scale(location="br", height = unit(0.2, "cm")) +
  # colocar a indicador do norte, estilo, altura e largura
  annotation_north_arrow(location="tr",
                         style = north_arrow_nautical,
                         height = unit(1.5,"cm"),
                         width = unit(1.5,"cm")) +
  labs(x = "Latitude", y = "Longitude", 
       title = "2010",
       # "Indice GL dos Estados Brasileiros, por Grandes \nCategorias Econômicas, 2000"
       subtitle = "Dia 10/09/2021",
       fill="CGCE",    # titulo da legenda
       caption = "Fonte: Elaborado pelo autor, dados do SECINT e SEPEC (2021).",
       x=NULL,
       y=NULL) +   # legenda dos eixos, deixar sem lagendas
  theme_bw() +   # colocar fundo branco no mapa
  theme(legend.position = c(0.18, 0.2),  # colocar a legenda em outra localizacao
        legend.key.size = unit(4,"mm"),  # reduzir o tamanho da legenda
        plot.title = element_text(size = 12L, face = "bold", hjust = 0.5),
        plot.caption = element_text(size = 10, hjust = 0), # hjust-ajustar na horizontal e vjust-ajustar na vertical
        plot.subtitle = element_text(size = 10),
        legend.title = element_text(size = 10),
        legend.text = element_text(size = 9))

# salvando o plot do grafico e png
ggsave(plot = CGCE_2010, 
       filename = "mestrado_script/mapa/Mapa_CGCE_2010.png",
       width = 5, height = 5)

#------------------------------------------------------------#
CGCE_2015 <- ggplot(GL) +
  aes(fill = GL_2015, group = name) +
  geom_sf(shape = "circle", size = 0.15) +
  geom_sf_label(aes(label = postal),
                label.padding = unit(0.8, "mm"),
                size = 2) +
  scale_fill_manual(
    values = list(
      `BK` = "#66C2A5",
      `BI` = "#AB98C8",
      `BC` = "#E1D83B",
      `NA` = "#FFFFFF")
  ) +
  # colocando a localizacao da escala
  annotation_scale(location="br", height = unit(0.2, "cm")) +
  # colocar a indicador do norte, estilo, altura e largura
  annotation_north_arrow(location="tr",
                         style = north_arrow_nautical,
                         height = unit(1.5,"cm"),
                         width = unit(1.5,"cm")) +
  labs(x = "Latitude", y = "Longitude", 
       title = "2015",
       # "Indice GL dos Estados Brasileiros, por Grandes \nCategorias Econômicas, 2000"
       subtitle = "Dia 10/09/2021",
       fill="CGCE",    # titulo da legenda
       caption = "Fonte: Elaborado pelo autor, dados do SECINT e SEPEC (2021).",
       x=NULL,
       y=NULL) +   # legenda dos eixos, deixar sem lagendas
  theme_bw() +   # colocar fundo branco no mapa
  theme(legend.position = c(0.18, 0.2),  # colocar a legenda em outra localizacao
        legend.key.size = unit(4,"mm"),  # reduzir o tamanho da legenda
        plot.title = element_text(size = 12L, face = "bold", hjust = 0.5),
        plot.caption = element_text(size = 10, hjust = 0), # hjust-ajustar na horizontal e vjust-ajustar na vertical
        plot.subtitle = element_text(size = 10),
        legend.title = element_text(size = 10),
        legend.text = element_text(size = 9))

# salvando o plot do grafico e png
ggsave(plot = CGCE_2015, 
       filename = "mestrado_script/mapa/Mapa_CGCE_2015.png",
       width = 5, height = 5)

#------------------------------------------------------------#
CGCE_2020 <- ggplot(GL) +
  aes(fill = GL_2020, group = name) +
  geom_sf(shape = "circle", size = 0.15) +
  geom_sf_label(aes(label = postal),
                label.padding = unit(0.8, "mm"),
                size = 2) +
  scale_fill_manual(
    values = list(
      `BK` = "#66C2A5",
      `BI` = "#AB98C8",
      `BC` = "#E1D83B",
      `NA` = "#FFFFFF")
  ) +
  # colocando a localizacao da escala
  annotation_scale(location="br", height = unit(0.2, "cm")) +
  # colocar a indicador do norte, estilo, altura e largura
  annotation_north_arrow(location="tr",
                         style = north_arrow_nautical,
                         height = unit(1.5,"cm"),
                         width = unit(1.5,"cm")) +
  labs(x = "Latitude", y = "Longitude", 
       title = "2020",
       # "Indice GL dos Estados Brasileiros, por Grandes \nCategorias Econômicas, 2000"
       subtitle = "Dia 10/09/2021",
       fill="CGCE",    # titulo da legenda
       caption = "Fonte: Elaborado pelo autor, dados do SECINT e SEPEC (2021).",
       x=NULL,
       y=NULL) +   # legenda dos eixos, deixar sem lagendas
  theme_bw() +   # colocar fundo branco no mapa
  theme(legend.position = c(0.18, 0.2),  # colocar a legenda em outra localizacao
        legend.key.size = unit(4,"mm"),  # reduzir o tamanho da legenda
        plot.title = element_text(size = 12L, face = "bold", hjust = 0.5),
        plot.caption = element_text(size = 10, hjust = 0), # hjust-ajustar na horizontal e vjust-ajustar na vertical
        plot.subtitle = element_text(size = 10),
        legend.title = element_text(size = 10),
        legend.text = element_text(size = 9))

# salvando o plot do grafico e png
ggsave(plot = CGCE_2020, 
       filename = "mestrado_script/mapa/Mapa_CGCE_2020.png",
       width = 5, height = 5)

#----------------------------------------------#
# juntar mapas em um unico arquivo
# Plotando todos
grid.arrange(CGCE_2000, CGCE_2005, CGCE_2010, 
             CGCE_2015, CGCE_2020,
             ncol=3, nrow=2)

(Mapa_CGCE <- grid.arrange(CGCE_2000, CGCE_2005, CGCE_2010, 
                           CGCE_2015, CGCE_2020,
                           ncol=3, nrow=2))

# salvando o plot do grafico e png
ggsave(plot = Mapa_CGCE, 
       filename = "mestrado_script/mapa/Mapa_CGCE_2000_2020.png",
       width = 15, height = 10)

### limpar dados
rm(list=ls(all=TRUE))

#-----------------------------------------------------#
# IMPORTAR INDICES DE ISIC
(GL_2000_ISIC <- read.csv2("mestrado_script/indice GL por ISIC-2000.csv") %>%
    select("SG_UF_NCM", "ISIC", "gl") %>% 
    rename("GL_2000"="gl"))

(GL_2005_ISIC <- read.csv2("mestrado_script/indice GL por ISIC-2005.csv") %>%
    select("SG_UF_NCM", "ISIC", "gl") %>% 
    rename("GL_2005"="gl"))

(GL_2010_ISIC <- read.csv2("mestrado_script/indice GL por ISIC-2010.csv") %>% 
    select("SG_UF_NCM", "ISIC", "gl") %>% 
    rename("GL_2010"="gl"))

(GL_2015_ISIC <- read.csv2("mestrado_script/indice GL por ISIC-2015.csv") %>% 
    select("SG_UF_NCM", "ISIC", "gl") %>% 
    rename("GL_2015"="gl"))

(GL_2020_ISIC <- read.csv2("mestrado_script/indice GL por ISIC-2020.csv") %>% 
    select("SG_UF_NCM", "ISIC", "gl") %>% 
    rename("GL_2020"="gl"))

## LIMPAR BASE
GL_2000_ISIC <- filter(GL_2000_ISIC, GL_2000 >= 50)
GL_2005_ISIC <- filter(GL_2005_ISIC, GL_2005 >= 50)
GL_2010_ISIC <- filter(GL_2010_ISIC, GL_2010 >= 50)
GL_2015_ISIC <- filter(GL_2015_ISIC, GL_2015 >= 50)
GL_2020_ISIC <- filter(GL_2020_ISIC, GL_2020 >= 50)

## JUNTAR BASES
GL_ISIC <- full_join(GL_2000_ISIC, GL_2005_ISIC, by = c("SG_UF_NCM", "ISIC"))
GL_ISIC <- full_join(GL_ISIC, GL_2010_ISIC, by = c("SG_UF_NCM", "ISIC"))
GL_ISIC <- full_join(GL_ISIC, GL_2015_ISIC, by = c("SG_UF_NCM", "ISIC"))
GL_ISIC <- full_join(GL_ISIC, GL_2020_ISIC, by = c("SG_UF_NCM", "ISIC"))

## ARRUMAR
GL_ISIC <- arrange(GL_ISIC, SG_UF_NCM)

# RENOMEAR OBSERVACOES
(GL_ISIC <- GL_ISIC %>% 
    mutate(ISIC = recode(ISIC, "Indústria Extrativa" = "Extrativa")))
(GL_ISIC <- GL_ISIC %>% 
    mutate(ISIC = recode(ISIC, "Outros Produtos" = "Outros")))
(GL_ISIC <- GL_ISIC %>% 
    mutate(ISIC = recode(ISIC, "Indústria de Transformação" = "Transformação")))

## exportar planilha com valores agrupados:
write.csv2(GL_ISIC, "mestrado_script/GL_ISIC_T.csv")

#------------------------------------------------------------#
# CRIAR MAPA AQUI
## BAIXAR BASE DO MAPA
(BRA <- ne_states(country = "Brazil", returnclass = "sf"))

(ISIC <- read.csv2("mestrado_script/GL_ISIC_T.csv") %>% 
    select("SG_UF_NCM":"GL_2020"))

# renomear os dados missing
ISIC$GL_2000[is.na(ISIC$GL_2000)] <- "NA"
ISIC$GL_2005[is.na(ISIC$GL_2005)] <- "NA"
ISIC$GL_2010[is.na(ISIC$GL_2010)] <- "NA"
ISIC$GL_2015[is.na(ISIC$GL_2015)] <- "NA"
ISIC$GL_2020[is.na(ISIC$GL_2020)] <- "NA"

(GL2 <- full_join(BRA, ISIC, by = c("postal" = "SG_UF_NCM")))

GL2$GL_2000[is.na(GL2$GL_2000)] <- "NA"
GL2$GL_2005[is.na(GL2$GL_2005)] <- "NA"
GL2$GL_2010[is.na(GL2$GL_2010)] <- "NA"
GL2$GL_2015[is.na(GL2$GL_2015)] <- "NA"
GL2$GL_2020[is.na(GL2$GL_2020)] <- "NA"

#------------------------------------------------------------#
(ISIC_2000 <- ggplot(GL2) +
    aes(fill = GL_2000, group = name) +
    geom_sf(shape = "circle", size = 0.15) +
    geom_sf_label(aes(label = postal),
                  label.padding = unit(0.8, "mm"),
                  size = 2) +
    scale_fill_manual(
      values = list(
        `Agropecuária` = "#66C2A5",
        `Transformação` = "#AB98C8",
        `Outros` = "#E1D83B",
        `Extrativa` = "#98FB98",
        `NA` = "#FFFFFF")
    ) +
    # colocando a localizacao da escala
    annotation_scale(location="br", height = unit(0.2, "cm")) +
    # colocar a indicador do norte, estilo, altura e largura
    annotation_north_arrow(location="tr",
                           style = north_arrow_nautical,
                           height = unit(1.5,"cm"),
                           width = unit(1.5,"cm")) +
    labs(x = "Latitude", y = "Longitude", 
         title = "2000",
         # "Indice GL dos Estados Brasileiros, por Grandes \nCategorias Econômicas, 2000"
         subtitle = "Dia 10/09/2021",
         fill="CGCE",    # titulo da legenda
         caption = "Fonte: Elaborado pelo autor, dados do SECINT e SEPEC (2021).",
         x=NULL,
         y=NULL) +   # legenda dos eixos, deixar sem lagendas
    theme_bw() +   # colocar fundo branco no mapa
    theme(legend.position = c(0.18, 0.2),  # colocar a legenda em outra localizacao
          legend.key.size = unit(4,"mm"),  # reduzir o tamanho da legenda
          plot.title = element_text(size = 12L, face = "bold", hjust = 0.5),
          plot.caption = element_text(size = 10, hjust = 0), # hjust-ajustar na horizontal e vjust-ajustar na vertical
          plot.subtitle = element_text(size = 10),
          legend.title = element_text(size = 10),
          legend.text = element_text(size = 9)))

# Salvando o plot do grafico e png
ggsave(plot = ISIC_2000, 
       filename = "mestrado_script/mapa/Mapa_ISIC_2000.png",
       width = 5, height = 5)


#------------------------------------------------------------#
(ISIC_2005 <- ggplot(GL) +
    aes(fill = GL_2005, group = name) +
    geom_sf(shape = "circle", size = 0.15) +
    geom_sf_label(aes(label = postal),
                  label.padding = unit(0.8, "mm"),
                  size = 2) +
    scale_fill_manual(
      values = list(
        `Agropecuária` = "#66C2A5",
        `Transformação` = "#AB98C8",
        `Outros` = "#E1D83B",
        `Extrativa` = "#98FB98",
        `NA` = "#FFFFFF")
    ) +
    # colocando a localizacao da escala
    annotation_scale(location="br", height = unit(0.2, "cm")) +
    # colocar a indicador do norte, estilo, altura e largura
    annotation_north_arrow(location="tr",
                           style = north_arrow_nautical,
                           height = unit(1.5,"cm"),
                           width = unit(1.5,"cm")) +
    labs(x = "Latitude", y = "Longitude", 
         title = "2005",
         # "Indice GL dos Estados Brasileiros, por Grandes \nCategorias Econômicas, 2000"
         subtitle = "Dia 10/09/2021",
         fill="ISIC",    # titulo da legenda
         caption = "Fonte: Elaborado pelo autor, dados do SECINT e SEPEC (2021).",
         x=NULL,
         y=NULL) +   # legenda dos eixos, deixar sem lagendas
    theme_bw() +   # colocar fundo branco no mapa
    theme(legend.position = c(0.18, 0.2),  # colocar a legenda em outra localizacao
          legend.key.size = unit(4,"mm"),  # reduzir o tamanho da legenda
          plot.title = element_text(size = 12L, face = "bold", hjust = 0.5),
          plot.caption = element_text(size = 10, hjust = 0), # hjust-ajustar na horizontal e vjust-ajustar na vertical
          plot.subtitle = element_text(size = 10),
          legend.title = element_text(size = 10),
          legend.text = element_text(size = 9)))

# salvando o plot do grafico e png
ggsave(plot = ISIC_2005, 
       filename = "mestrado_script/mapa/Mapa_ISIC_2005.png",
       width = 5, height = 5)

#------------------------------------------------------------#
ISIC_2010 <- ggplot(GL) +
  aes(fill = GL_2010, group = name) +
  geom_sf(shape = "circle", size = 0.15) +
  geom_sf_label(aes(label = postal),
                label.padding = unit(0.8, "mm"),
                size = 2) +
  scale_fill_manual(
    values = list(
      `Agropecuária` = "#66C2A5",
      `Transformação` = "#AB98C8",
      `Outros` = "#E1D83B",
      `Extrativa` = "#98FB98",
      `NA` = "#FFFFFF")
  ) +
  # colocando a localizacao da escala
  annotation_scale(location="br", height = unit(0.2, "cm")) +
  # colocar a indicador do norte, estilo, altura e largura
  annotation_north_arrow(location="tr",
                         style = north_arrow_nautical,
                         height = unit(1.5,"cm"),
                         width = unit(1.5,"cm")) +
  labs(x = "Latitude", y = "Longitude", 
       title = "2010",
       # "Indice GL dos Estados Brasileiros, por Grandes \nCategorias Econômicas, 2000"
       subtitle = "Dia 10/09/2021",
       fill="ISIC",    # titulo da legenda
       caption = "Fonte: Elaborado pelo autor, dados do SECINT e SEPEC (2021).",
       x=NULL,
       y=NULL) +   # legenda dos eixos, deixar sem lagendas
  theme_bw() +   # colocar fundo branco no mapa
  theme(legend.position = c(0.18, 0.2),  # colocar a legenda em outra localizacao
        legend.key.size = unit(4,"mm"),  # reduzir o tamanho da legenda
        plot.title = element_text(size = 12L, face = "bold", hjust = 0.5),
        plot.caption = element_text(size = 10, hjust = 0), # hjust-ajustar na horizontal e vjust-ajustar na vertical
        plot.subtitle = element_text(size = 10),
        legend.title = element_text(size = 10),
        legend.text = element_text(size = 9))

# salvando o plot do grafico e png
ggsave(plot = ISIC_2010, 
       filename = "mestrado_script/mapa/Mapa_ISIC_2010.png",
       width = 5, height = 5)

#------------------------------------------------------------#
ISIC_2015 <- ggplot(GL) +
  aes(fill = GL_2015, group = name) +
  geom_sf(shape = "circle", size = 0.15) +
  geom_sf_label(aes(label = postal),
                label.padding = unit(0.8, "mm"),
                size = 2) +
  scale_fill_manual(
    values = list(
      `Agropecuária` = "#66C2A5",
      `Transformação` = "#AB98C8",
      `Outros` = "#E1D83B",
      `Extrativa` = "#98FB98",
      `NA` = "#FFFFFF")
  ) +
  # colocando a localizacao da escala
  annotation_scale(location="br", height = unit(0.2, "cm")) +
  # colocar a indicador do norte, estilo, altura e largura
  annotation_north_arrow(location="tr",
                         style = north_arrow_nautical,
                         height = unit(1.5,"cm"),
                         width = unit(1.5,"cm")) +
  labs(x = "Latitude", y = "Longitude", 
       title = "2015",
       # "Indice GL dos Estados Brasileiros, por Grandes \nCategorias Econômicas, 2000"
       subtitle = "Dia 10/09/2021",
       fill="ISIC",    # titulo da legenda
       caption = "Fonte: Elaborado pelo autor, dados do SECINT e SEPEC (2021).",
       x=NULL,
       y=NULL) +   # legenda dos eixos, deixar sem lagendas
  theme_bw() +   # colocar fundo branco no mapa
  theme(legend.position = c(0.18, 0.2),  # colocar a legenda em outra localizacao
        legend.key.size = unit(4,"mm"),  # reduzir o tamanho da legenda
        plot.title = element_text(size = 12L, face = "bold", hjust = 0.5),
        plot.caption = element_text(size = 10, hjust = 0), # hjust-ajustar na horizontal e vjust-ajustar na vertical
        plot.subtitle = element_text(size = 10),
        legend.title = element_text(size = 10),
        legend.text = element_text(size = 9))

# salvando o plot do grafico e png
ggsave(plot = ISIC_2015, 
       filename = "mestrado_script/mapa/Mapa_ISIC_2015.png",
       width = 5, height = 5)

#------------------------------------------------------------#
ISIC_2020 <- ggplot(GL) +
  aes(fill = GL_2020, group = name) +
  geom_sf(shape = "circle", size = 0.15) +
  geom_sf_label(aes(label = postal),
                label.padding = unit(0.8, "mm"),
                size = 2) +
  scale_fill_manual(
    values = list(
      `Agropecuária` = "#66C2A5",
      `Transformação` = "#AB98C8",
      `Outros` = "#E1D83B",
      `Extrativa` = "#98FB98",
      `NA` = "#FFFFFF")
  ) +
  # colocando a localizacao da escala
  annotation_scale(location="br", height = unit(0.2, "cm")) +
  # colocar a indicador do norte, estilo, altura e largura
  annotation_north_arrow(location="tr",
                         style = north_arrow_nautical,
                         height = unit(1.5,"cm"),
                         width = unit(1.5,"cm")) +
  labs(x = "Latitude", y = "Longitude", 
       title = "2020",
       # "Indice GL dos Estados Brasileiros, por Grandes \nCategorias Econômicas, 2000"
       subtitle = "Dia 10/09/2021",
       fill="ISIC",    # titulo da legenda
       caption = "Fonte: Elaborado pelo autor, dados do SECINT e SEPEC (2021).",
       x=NULL,
       y=NULL) +   # legenda dos eixos, deixar sem lagendas
  theme_bw() +   # colocar fundo branco no mapa
  theme(legend.position = c(0.18, 0.2),  # colocar a legenda em outra localizacao
        legend.key.size = unit(4,"mm"),  # reduzir o tamanho da legenda
        plot.title = element_text(size = 12L, face = "bold", hjust = 0.5),
        plot.caption = element_text(size = 10, hjust = 0), # hjust-ajustar na horizontal e vjust-ajustar na vertical
        plot.subtitle = element_text(size = 10),
        legend.title = element_text(size = 10),
        legend.text = element_text(size = 9))

# salvando o plot do grafico e png
ggsave(plot = ISIC_2020, 
       filename = "mestrado_script/mapa/Mapa_ISIC_2020.png",
       width = 5, height = 5)

#----------------------------------------------#
# juntar mapas em um unico arquivo
## Plotando todos
grid.arrange(ISIC_2000, ISIC_2005, ISIC_2010, 
             ISIC_2015, ISIC_2020,
             ncol=3, nrow=2)

(Mapa_ISIC <- grid.arrange(ISIC_2000, ISIC_2005, ISIC_2010, 
                           ISIC_2015, ISIC_2020,
                           ncol=3, nrow=2))

# salvando o plot do grafico e png
ggsave(plot = Mapa_ISIC, 
       filename = "mestrado_script/mapa/Mapa_ISIC_2000_2020.png",
       width = 15, height = 10)

### limpar dados
rm(list=ls(all=TRUE))

#----------------------------------------------#
# IMPORTAR INDICES DE SIIT
(GL_2000_SIIT <- read.csv2("mestrado_script/indice GL por SIIT-2000.csv") %>%
    select("SG_UF_NCM", "SIIT", "gl") %>% 
    rename("GL_2000"="gl"))

(GL_2005_SIIT <- read.csv2("mestrado_script/indice GL por SIIT-2005.csv") %>%
    select("SG_UF_NCM", "SIIT", "gl") %>% 
    rename("GL_2005"="gl"))

(GL_2010_SIIT <- read.csv2("mestrado_script/indice GL por SIIT-2010.csv") %>% 
    select("SG_UF_NCM", "SIIT", "gl") %>% 
    rename("GL_2010"="gl"))

(GL_2015_SIIT <- read.csv2("mestrado_script/indice GL por SIIT-2015.csv") %>% 
    select("SG_UF_NCM", "SIIT", "gl") %>% 
    rename("GL_2015"="gl"))

(GL_2020_SIIT <- read.csv2("mestrado_script/indice GL por SIIT-2020.csv") %>% 
    select("SG_UF_NCM", "SIIT", "gl") %>% 
    rename("GL_2020"="gl"))

## LIMPAR BASE
GL_2000_SIIT <- filter(GL_2000_SIIT, GL_2000 >= 50)
GL_2005_SIIT <- filter(GL_2005_SIIT, GL_2005 >= 50)
GL_2010_SIIT <- filter(GL_2010_SIIT, GL_2010 >= 50)
GL_2015_SIIT <- filter(GL_2015_SIIT, GL_2015 >= 50)
GL_2020_SIIT <- filter(GL_2020_SIIT, GL_2020 >= 50)

## JUNTAR BASES
GL_SIIT <- full_join(GL_2000_SIIT, GL_2005_SIIT, by = c("SG_UF_NCM", "SIIT"))
GL_SIIT <- full_join(GL_SIIT, GL_2010_SIIT, by = c("SG_UF_NCM", "SIIT"))
GL_SIIT <- full_join(GL_SIIT, GL_2015_SIIT, by = c("SG_UF_NCM", "SIIT"))
GL_SIIT <- full_join(GL_SIIT, GL_2020_SIIT, by = c("SG_UF_NCM", "SIIT"))

## ARRUMAR
(GL_SIIT <- arrange(GL_SIIT, SG_UF_NCM))

# RENOMEAR OBSERVACOES
(GL_SIIT <- GL_SIIT %>% 
    mutate(SIIT = recode(SIIT, 
                         "PRODUTOS DA INDUSTRIA DE TRANSFORMAÇÃO DE ALTA TECNOLOGIA" = "Alta")))
(GL_SIIT <- GL_SIIT %>% 
    mutate(SIIT = recode(SIIT, 
                         "PRODUTOS DA INDUSTRIA DE TRANSFORMAÇÃO DE MEDIA-BAIXA TECNOLOGIA" = "Média-Baixa")))
(GL_SIIT <- GL_SIIT %>% 
    mutate(SIIT = recode(SIIT, 
                         "PRODUTOS DA INDUSTRIA DE TRANSFORMAÇÃO DE MEDIA-ALTA TECNOLOGIA" = "Média-Alta")))
(GL_SIIT <- GL_SIIT %>% 
    mutate(SIIT = recode(SIIT, 
                         "PRODUTOS N.C.I.T" = "Básico")))
(GL_SIIT <- GL_SIIT %>% 
    mutate(SIIT = recode(SIIT, 
                         "PRODUTOS DA INDUSTRIA DE TRANSFORMAÇÃO DE BAIXA TECNOLOGIA" = "Baixa")))

## exportar planilha com valores agrupados:
write.csv2(GL_SIIT, "mestrado_script/GL_SIIT_T.csv")

#------------------------------------------------------------#
# CRIAR MAPA AQUI
## BAIXAR BASE DO MAPA
(BRA <- ne_states(country = "Brazil", returnclass = "sf"))

(SIIT <- read.csv2("mestrado_script/GL_SIIT_T.csv") %>% 
    select("SG_UF_NCM":"GL_2020"))

# renomear os dados missing
SIIT$GL_2000[is.na(SIIT$GL_2000)] <- "NA"
SIIT$GL_2005[is.na(SIIT$GL_2005)] <- "NA"
SIIT$GL_2010[is.na(SIIT$GL_2010)] <- "NA"
SIIT$GL_2015[is.na(SIIT$GL_2015)] <- "NA"
SIIT$GL_2020[is.na(SIIT$GL_2020)] <- "NA"

(GL <- full_join(BRA, SIIT, by = c("postal" = "SG_UF_NCM")))

#------------------------------------------------------------#
(SIIT_2000 <- ggplot(GL) +
    aes(fill = GL_2000, group = name) +
    geom_sf(shape = "circle", size = 0.15) +
    geom_sf_label(aes(label = postal),
                  label.padding = unit(0.8, "mm"),
                  size = 2) +
    scale_fill_manual(
      values = list(
        `Alta` = "#AB98C8",
        `Média-Baixa` = "#98FB98",
        `Média-Alta` = "#E1D83B",
        `Básico` = "#BC8F8F",
        `Baixa` = "#66C2A5",
        `NA` = "#FFFFFF")
    ) +
    # colocando a localizacao da escala
    annotation_scale(location="br", height = unit(0.2, "cm")) +
    # colocar a indicador do norte, estilo, altura e largura
    annotation_north_arrow(location="tr",
                           style = north_arrow_nautical,
                           height = unit(1.5,"cm"),
                           width = unit(1.5,"cm")) +
    labs(x = "Latitude", y = "Longitude", 
         title = "2000",
         # "Indice GL dos Estados Brasileiros, por Grandes \nCategorias Econômicas, 2000"
         subtitle = "Dia 10/09/2021",
         fill="SIIT",    # titulo da legenda
         caption = "Fonte: Elaborado pelo autor, dados do SECINT e SEPEC (2021).",
         x=NULL,
         y=NULL) +   # legenda dos eixos, deixar sem lagendas
    theme_bw() +   # colocar fundo branco no mapa
    theme(legend.position = c(0.18, 0.2),  # colocar a legenda em outra localizacao
          legend.key.size = unit(4,"mm"),  # reduzir o tamanho da legenda
          plot.title = element_text(size = 12L, face = "bold", hjust = 0.5),
          plot.caption = element_text(size = 10, hjust = 0), # hjust-ajustar na horizontal e vjust-ajustar na vertical
          plot.subtitle = element_text(size = 10),
          legend.title = element_text(size = 10),
          legend.text = element_text(size = 9)))

# salvando o plot do grafico e png
ggsave(plot = SIIT_2000, 
       filename = "mestrado_script/mapa/Mapa_SIIT_2000.png",
       width = 5, height = 5)

#------------------------------------------------------------#
(SIIT_2005 <- ggplot(GL) +
    aes(fill = GL_2005, group = name) +
    geom_sf(shape = "circle", size = 0.15) +
    geom_sf_label(aes(label = postal),
                  label.padding = unit(0.8, "mm"),
                  size = 2) +
    scale_fill_manual(
      values = list(
        `Alta` = "#AB98C8",
        `Média-Baixa` = "#98FB98",
        `Média-Alta` = "#E1D83B",
        `Básico` = "#BC8F8F",
        `Baixa` = "#66C2A5",
        `NA` = "#FFFFFF")
    ) +
    # colocando a localizacao da escala
    annotation_scale(location="br", height = unit(0.2, "cm")) +
    # colocar a indicador do norte, estilo, altura e largura
    annotation_north_arrow(location="tr",
                           style = north_arrow_nautical,
                           height = unit(1.5,"cm"),
                           width = unit(1.5,"cm")) +
    labs(x = "Latitude", y = "Longitude", 
         title = "2005",
         # "Indice GL dos Estados Brasileiros, por Grandes \nCategorias Econômicas, 2000"
         subtitle = "Dia 10/09/2021",
         fill="SIIT",    # titulo da legenda
         caption = "Fonte: Elaborado pelo autor, dados do SECINT e SEPEC (2021).",
         x=NULL,
         y=NULL) +   # legenda dos eixos, deixar sem lagendas
    theme_bw() +   # colocar fundo branco no mapa
    theme(legend.position = c(0.18, 0.2),  # colocar a legenda em outra localizacao
          legend.key.size = unit(4,"mm"),  # reduzir o tamanho da legenda
          plot.title = element_text(size = 12L, face = "bold", hjust = 0.5),
          plot.caption = element_text(size = 10, hjust = 0), # hjust-ajustar na horizontal e vjust-ajustar na vertical
          plot.subtitle = element_text(size = 10),
          legend.title = element_text(size = 10),
          legend.text = element_text(size = 9)))

# salvando o plot do grafico e png
ggsave(plot = SIIT_2005, 
       filename = "mestrado_script/mapa/Mapa_SIIT_2005.png",
       width = 5, height = 5)

#------------------------------------------------------------#
SIIT_2010 <- ggplot(GL) +
  aes(fill = GL_2010, group = name) +
  geom_sf(shape = "circle", size = 0.15) +
  geom_sf_label(aes(label = postal),
                label.padding = unit(0.8, "mm"),
                size = 2) +
  scale_fill_manual(
    values = list(
      `Alta` = "#AB98C8",
      `Média-Baixa` = "#98FB98",
      `Média-Alta` = "#E1D83B",
      `Básico` = "#BC8F8F",
      `Baixa` = "#66C2A5",
      `NA` = "#FFFFFF")
  ) +
  # colocando a localizacao da escala
  annotation_scale(location="br", height = unit(0.2, "cm")) +
  # colocar a indicador do norte, estilo, altura e largura
  annotation_north_arrow(location="tr",
                         style = north_arrow_nautical,
                         height = unit(1.5,"cm"),
                         width = unit(1.5,"cm")) +
  labs(x = "Latitude", y = "Longitude", 
       title = "2010",
       # "Indice GL dos Estados Brasileiros, por Grandes \nCategorias Econômicas, 2000"
       subtitle = "Dia 10/09/2021",
       fill="SIIT",    # titulo da legenda
       caption = "Fonte: Elaborado pelo autor, dados do SECINT e SEPEC (2021).",
       x=NULL,
       y=NULL) +   # legenda dos eixos, deixar sem lagendas
  theme_bw() +   # colocar fundo branco no mapa
  theme(legend.position = c(0.18, 0.2),  # colocar a legenda em outra localizacao
        legend.key.size = unit(4,"mm"),  # reduzir o tamanho da legenda
        plot.title = element_text(size = 12L, face = "bold", hjust = 0.5),
        plot.caption = element_text(size = 10, hjust = 0), # hjust-ajustar na horizontal e vjust-ajustar na vertical
        plot.subtitle = element_text(size = 10),
        legend.title = element_text(size = 10),
        legend.text = element_text(size = 9))

# salvando o plot do grafico e png
ggsave(plot = SIIT_2010, 
       filename = "mestrado_script/mapa/Mapa_SIIT_2010.png",
       width = 5, height = 5)

#------------------------------------------------------------#
SIIT_2015 <- ggplot(GL) +
  aes(fill = GL_2015, group = name) +
  geom_sf(shape = "circle", size = 0.15) +
  geom_sf_label(aes(label = postal),
                label.padding = unit(0.8, "mm"),
                size = 2) +
  scale_fill_manual(
    values = list(
      `Alta` = "#AB98C8",
      `Média-Baixa` = "#98FB98",
      `Média-Alta` = "#E1D83B",
      `Básico` = "#BC8F8F",
      `Baixa` = "#66C2A5",
      `NA` = "#FFFFFF")
  ) +
  # colocando a localizacao da escala
  annotation_scale(location="br", height = unit(0.2, "cm")) +
  # colocar a indicador do norte, estilo, altura e largura
  annotation_north_arrow(location="tr",
                         style = north_arrow_nautical,
                         height = unit(1.5,"cm"),
                         width = unit(1.5,"cm")) +
  labs(x = "Latitude", y = "Longitude", 
       title = "2015",
       # "Indice GL dos Estados Brasileiros, por Grandes \nCategorias Econômicas, 2000"
       subtitle = "Dia 10/09/2021",
       fill="SIIT",    # titulo da legenda
       caption = "Fonte: Elaborado pelo autor, dados do SECINT e SEPEC (2021).",
       x=NULL,
       y=NULL) +   # legenda dos eixos, deixar sem lagendas
  theme_bw() +   # colocar fundo branco no mapa
  theme(legend.position = c(0.18, 0.2),  # colocar a legenda em outra localizacao
        legend.key.size = unit(4,"mm"),  # reduzir o tamanho da legenda
        plot.title = element_text(size = 12L, face = "bold", hjust = 0.5),
        plot.caption = element_text(size = 10, hjust = 0), # hjust-ajustar na horizontal e vjust-ajustar na vertical
        plot.subtitle = element_text(size = 10),
        legend.title = element_text(size = 10),
        legend.text = element_text(size = 9))

# salvando o plot do grafico e png
ggsave(plot = SIIT_2015, 
       filename = "mestrado_script/mapa/Mapa_SIIT_2015.png",
       width = 5, height = 5)

#------------------------------------------------------------#
SIIT_2020 <- ggplot(GL) +
  aes(fill = GL_2020, group = name) +
  geom_sf(shape = "circle", size = 0.15) +
  geom_sf_label(aes(label = postal),
                label.padding = unit(0.8, "mm"),
                size = 2) +
  scale_fill_manual(
    values = list(
      `Alta` = "#AB98C8",
      `Média-Baixa` = "#98FB98",
      `Média-Alta` = "#E1D83B",
      `Básico` = "#BC8F8F",
      `Baixa` = "#66C2A5",
      `NA` = "#FFFFFF")
  ) +
  # colocando a localizacao da escala
  annotation_scale(location="br", height = unit(0.2, "cm")) +
  # colocar a indicador do norte, estilo, altura e largura
  annotation_north_arrow(location="tr",
                         style = north_arrow_nautical,
                         height = unit(1.5,"cm"),
                         width = unit(1.5,"cm")) +
  labs(x = "Latitude", y = "Longitude", 
       title = "2020",
       # "Indice GL dos Estados Brasileiros, por Grandes \nCategorias Econômicas, 2000"
       subtitle = "Dia 10/09/2021",
       fill="SIIT",    # titulo da legenda
       caption = "Fonte: Elaborado pelo autor, dados do SECINT e SEPEC (2021).",
       x=NULL,
       y=NULL) +   # legenda dos eixos, deixar sem lagendas
  theme_bw() +   # colocar fundo branco no mapa
  theme(legend.position = c(0.18, 0.2),  # colocar a legenda em outra localizacao
        legend.key.size = unit(4,"mm"),  # reduzir o tamanho da legenda
        plot.title = element_text(size = 12L, face = "bold", hjust = 0.5),
        plot.caption = element_text(size = 10, hjust = 0), # hjust-ajustar na horizontal e vjust-ajustar na vertical
        plot.subtitle = element_text(size = 10),
        legend.title = element_text(size = 10),
        legend.text = element_text(size = 9))

# salvando o plot do grafico e png
ggsave(plot = SIIT_2020, 
       filename = "mestrado_script/mapa/Mapa_SIIT_2020.png",
       width = 5, height = 5)

#----------------------------------------------#
# juntar mapas em um unico arquivo
## Plotando todos
grid.arrange(SIIT_2000, SIIT_2005, SIIT_2010, 
             SIIT_2015, SIIT_2020,
             ncol=3, nrow=2)

(Mapa_SIIT <- grid.arrange(SIIT_2000, SIIT_2005, SIIT_2010, 
                           SIIT_2015, SIIT_2020,
                           ncol=3, nrow=2))

# salvando o plot do grafico e png
ggsave(plot = Mapa_SIIT, 
       filename = "mestrado_script/mapa/Mapa_SIIT_2000_2020.png",
       width = 15, height = 10)

### limpar dados
rm(list=ls(all=TRUE))

#-------------------------------FIM-------------------------------#