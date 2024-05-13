library(readr)

modelo <- read_csv("~/dev/assentamentos-precarios-R/resultados/modelo.csv", 
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

# Para cada região Metropolitana aplica o modelo de LDA
for (i in 1:nrow(rms)) {
  print(rms[i,2])
}


# Para cada Estado aplica o modelo LDA
for (i in 1:nrow(ufs)) {
  print(ufs[i,2])
}

# View(modelo)
