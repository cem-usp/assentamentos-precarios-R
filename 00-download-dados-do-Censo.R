# Faz o download dos dados do Censo
# https://rdrr.io/github/ropensci/ftp/
library(ftp)
library(data.table)
library(readxl)
library(dplyr)

url <- "ftp://ftp.ibge.gov.br/Censos/Censo_Demografico_2010/Resultados_do_Universo/Agregados_por_Setores_Censitarios/"
files <- ftp_list(url, TRUE)
files <- unlist(files)

UFS = c(
  'AC'
  # 'AL',
  # 'AM',
  # 'AP',
  # 'BA',
  # 'CE',
  # 'DF',
  # 'ES',
  # 'GO',
  # 'MA',
  # 'MG',
  # 'MS',
  # 'MT',
  # 'PA',
  # 'PB',
  # 'PE',
  # 'PI',
  # 'PR',
  # 'RJ',
  # 'RN',
  # 'RO',
  # 'RR',
  # 'RS',
  # 'SC',
  # 'SE',
  # 'SP_Capital',
  # 'SP_Exceto_Capital',
  # 'TO'
)

setwd('downloads/Censo2010/')

for (uf in UFS) {
  # print(uf)
  file <- files |>
    startsWith(uf) |>
    which()
  # seila <- files[which(startsWith(files, uf))]
  disk_file = files[file]
  print(files[file])
  
  if (!file.exists(disk_file)){
    paste0(url, files[file]) |>
      ftp_fetch(disk = disk_file)
  }
  
  unzip(disk_file, junkpaths = TRUE)
  
  basico <- read_excel("Basico_AC.XLS", 
                       col_types = c("text", "numeric", "text", 
                                     "numeric", "text", "numeric", "text", 
                                     "numeric", "text", "numeric", "text", 
                                     "numeric", "text", "numeric", "text", 
                                     "numeric", "text", "numeric", "text", 
                                     "numeric", "numeric", "numeric", 
                                     "text", "text", "text", "text", "text", 
                                     "text", "text", "text", "text", "text"))
  basico <- basico |>
    select(
      'Cod_Grandes Regiões',
      'Cod_UF',
      'Cod_meso',
      'Cod_RM',
      'Nome_da_RM',
      'Cod_municipio',
      'Nome_do_municipio',
      'Situacao_setor',
      'V001',
      'V002'
    )
  
}


## USAR O rbind para concatenar

?read.csv

