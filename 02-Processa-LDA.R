library(readr)
library(dplyr)
#install.packages('../ldaSPSS_0.1.0_R_x86_64-pc-linux-gnu.tar.gz')
library(ldaSPSS)

modelo <- read_csv("../dados/modelo.csv", 
                   col_types = cols(Cod_setor = col_character()))

rms <- modelo |>
  filter(
    rm != '0' & rm != '00'
  ) |>
  select(
    'rm',
    'nome_rm'
  ) |>
  distinct()

ufs <- modelo |>
  select(
    'uf',
    'nome_UF'
  ) |>
  distinct()

# Lista para armazenar os resultados das Rms.
listaResultadoLdaRms <- list()
# Lista para armazenar os resultados das UFs
listaResultadoLdaUfs <- list()
# Retira variáveis repetidas.
modelo <- modelo %>% select(-numero_de_pessoas_residentes, -numero_de_domicilios_particulares_permanentes)

# Para cada região Metropolitana aplica o modelo de LDA
for (i in 1:nrow(rms)) {
  print(rms[i,2])
  codRm <- rms[i,1]$rm
  # Separa os dados da RM.
  dadosCemRm <- modelo %>% filter(rm==as.numeric(codRm)) %>% na.omit()
  # Seleciona as variáveis de interesse.
  dadosCemRm <- dadosCemRm[, 11:27]# %>% select(all_of(variaveis))
  dadosCemRm <- dadosCemRm %>% 
    filter(tipo_do_setor==0 | tipo_do_setor==1)
  dadosCemRmTreino <- dadosCemRm %>% 
    filter( numero_de_domicilios >= 50)
  if (nrow(dadosCemRmTreino) < 2) next
  dados <- dadosCemRmTreino[, 2:(ncol(dadosCemRmTreino))]
  grupos <- dadosCemRmTreino[, 1]$tipo_do_setor
  dadosVariaveisSelecionadas <- selecaoVariaveis(dados, grupos)#, variaveis)
  if (is.null(dadosVariaveisSelecionadas)) next
  if (length(dadosVariaveisSelecionadas$indices_selecionadas)==0) next
  indicesVariaveisSelecionadas <- sort(dadosVariaveisSelecionadas$indices_selecionadas)
  #variaveisSelecionadas <- variaveis[indicesVariaveisSelecionadas]
  #print(variaveisSelecionadas)  
  # Variáveis selecionadas.
  dados <- dados[, indicesVariaveisSelecionadas]
  # LDA
  resultadoLdaRm <- ldaSpss(dados, grupos, variaveis = NULL, prob=c(0.5, 0.5))
  listaResultadoLdaRm <- list(rm=codRm, 
                              stepwise=dadosVariaveisSelecionadas$resultados_detalhados,
                              variaveis = indicesVariaveisSelecionadas, 
                              resultado = resultadoLdaRm)
  # Adiciona os resultados para a rm na lista.
  listaResultadoLdaRms <- append(listaResultadoLdaRms, list(listaResultadoLdaRm))
}


# Para cada Estado aplica o modelo LDA
for (i in 1:nrow(ufs)) {
  print(ufs[i,2])
  codUf <- ufs[i,1]$uf
  # Separa os dados da UF.
  dadosCemUf <- modelo %>% filter(uf==as.numeric(codUf)) %>% na.omit()
  # Seleciona as variáveis de interesse.
  dadosCemUf <- dadosCemUf[, 11:27]# %>% select(all_of(variaveis))
  dadosCemUf <- dadosCemUf %>% 
    filter(tipo_do_setor==0 | tipo_do_setor==1)
  dadosCemUfTreino <- dadosCemUf %>% 
    filter( numero_de_domicilios >= 50)
  if (nrow(dadosCemUfTreino) < 2) next
  dados <- dadosCemUfTreino[, 2:(ncol(dadosCemUfTreino))]
  grupos <- dadosCemUfTreino[, 1]$tipo_do_setor
  dadosVariaveisSelecionadas <- selecaoVariaveis(dados, grupos)#, variaveis)
  if (is.null(dadosVariaveisSelecionadas)) next
  if (length(dadosVariaveisSelecionadas$indices_selecionadas)==0) next
  indicesVariaveisSelecionadas <- sort(dadosVariaveisSelecionadas$indices_selecionadas)
  #variaveisSelecionadas <- variaveis[indicesVariaveisSelecionadas]
  #print(variaveisSelecionadas)  
  # Variáveis selecionadas.
  dados <- dados[, indicesVariaveisSelecionadas]
  # LDA
  resultadoLdaUf <- ldaSpss(dados, grupos, variaveis = NULL, prob=c(0.5, 0.5))
  listaResultadoLdaUf <- list(uf=codUf, 
                              stepwise=dadosVariaveisSelecionadas$resultados_detalhados,
                              variaveis = indicesVariaveisSelecionadas, 
                              resultado = resultadoLdaUf)
  # Adiciona os resultados para a uf na lista.
  listaResultadoLdaUfs <- append(listaResultadoLdaUfs, list(listaResultadoLdaUf))
}

# View(modelo)
