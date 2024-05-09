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
  'AC',
  'AL',
  'AM',
  'AP',
  'BA',
  'CE',
  'DF',
  'ES',
  'GO',
  'MA',
  'MG',
  'MS',
  'MT',
  'PA',
  'PB',
  'PE',
  'PI',
  'PR',
  'RJ',
  'RN',
  'RO',
  'RR',
  'RS',
  'SC',
  'SE',
  'SP_Capital',
  'SP_Exceto_Capital',
  'TO'
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
  
  # basico <- read_excel("Basico_AC.XLS", 
  #                      col_types = c("text", "numeric", "text", 
  #                                    "numeric", "text", "numeric", "text", 
  #                                    "numeric", "text", "numeric", "text", 
  #                                    "numeric", "text", "numeric", "text", 
  #                                    "numeric", "text", "numeric", "text", 
  #                                    "numeric", "numeric", "numeric", 
  #                                    "text", "text", "text", "text", "text", 
  #                                    "text", "text", "text", "text", "text"))
  # Domicilio01 <- read_excel("Domicilio01_AC.XLS", 
  #                              col_types = c("text", "numeric", "numeric", 
  #                                            "numeric", "numeric", "numeric", "numeric", 
  #                                            "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                            "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                            "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                            "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                            "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                            "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                            "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                            "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                            "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                            "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                            "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                            "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                            "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                            "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                            "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                            "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                            "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                            "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                            "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                            "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                            "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                            "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                            "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                            "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                            "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                            "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                            "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                            "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                            "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                            "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                            "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                            "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                            "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                            "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                            "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                            "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                            "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                            "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                            "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                            "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                            "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                            "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                            "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                            "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                            "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                            "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                            "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                            "numeric"))
  # 
  # Responsavel02 <- read_excel("Responsavel02_AC.xls", 
  #                                col_types = c("text", "numeric", "numeric", 
  #                                              "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                              "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                              "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                              "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                              "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                              "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                              "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                              "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                              "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                              "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                              "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                              "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                              "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                              "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                              "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                              "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                              "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                              "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                              "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                              "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                              "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                              "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                              "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                              "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                              "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                              "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                              "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                              "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                              "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                              "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                              "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                              "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                              "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                              "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                              "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                              "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                              "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                              "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                              "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                              "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                              "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                              "numeric", "numeric", "numeric", "numeric", "numeric", 
  #                                              "numeric", "numeric", "numeric", "numeric", "numeric"))
  # 
  # basico <- basico |>
  #   select(
  #     'Cod_setor',
  #     'Cod_Grandes Regiões',
  #     'Cod_UF',
  #     'Cod_meso',
  #     'Cod_RM',
  #     'Nome_da_RM',
  #     'Cod_municipio',
  #     'Nome_do_municipio',
  #     'Situacao_setor',
  #     'V001',
  #     'V002'
  #   ) |>
  #   rename(
  #     'numero_de_domicilios' = 'V001',
  #     'numero_moradores' = 'V002'
  #   )
  # 
  # Domicilio01 <- Domicilio01 |>
  #   select(
  #     'Cod_setor',
  #     'V003',
  #     'V002',
  #     'V035',
  #     'V106',
  #     'V023',
  #     'V017',
  #     'V018',
  #     'V025',
  #     'V026',
  #     'V027',
  #     'V028',
  #     'V029',
  #     'V030',
  #     'V031',
  #     'V032',
  #     'V033',
  #     'V010',
  #     'V011'
  #   ) |>
  #   rename(
  #     'domicilios_tipo_casa' = 'V003',
  #     'domicilios_particulares_permanentes' = 'V002',
  #     'domicilios_com_lixo_coletado' = 'V035',
  #     'domicilios_tipo_casa_com_abastecimento_de_agua' = 'V106',
  #     'domicilios_particulares_permanentes_sem_banheiro_ou_sanitario' = 'V023',
  #     'domicilios_particulares_permanentes_com_banheiro_ligado_a_esgoto' = 'V017',
  #     'V018': 'domicilios_particulares_permanentes_com_banheiro_ligado_a_fossa_septica',
  #     'V025': 'domicilios_particulares_permanentes_com_1_banheiro',
  #     'V026': 'domicilios_particulares_permanentes_com_2_banheiros',
  #     'V027': 'domicilios_particulares_permanentes_com_3_banheiros',
  #     'V028': 'domicilios_particulares_permanentes_com_4_banheiros',
  #     'V029': 'domicilios_particulares_permanentes_com_5_banheiros',
  #     'V030': 'domicilios_particulares_permanentes_com_6_banheiros',
  #     'V031': 'domicilios_particulares_permanentes_com_7_banheiros',
  #     'V032': 'domicilios_particulares_permanentes_com_8_banheiros',
  #     'V033': 'domicilios_particulares_permanentes_com_mais_de_9_banheiros',
  #     'V010': 'domicilios_particulares_permanentes_cedidos_de_outra_forma',
  #     'V011': 'domicilios_particulares_permanentes_em_outra_condicao_de_ocupacao'
  #   )
  # 
  # geral <- left_join(basico, Domicilio01, by='Cod_setor')
}


## USAR O rbind para concatenar

?rename

