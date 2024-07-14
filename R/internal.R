#' @keywords internal
.names_standardize <- function(splist) {
  # Convertir todo a mayúsculas
  fixed1 <- toupper(splist)

  # Eliminar 'CF.' y 'AFF.'
  fixed2 <- gsub("CF\\.", "", fixed1)
  fixed3 <- gsub("AFF\\.", "", fixed2)

  # Eliminar espacios en blanco al inicio y al final
  fixed4 <- trimws(fixed3)

  # Cambiar guiones bajos por espacios
  fixed5 <- gsub("_", " ", fixed4)

  # Estandarizar 'VAR', 'F.', 'SUBSP.'
  fixed6 <- gsub(" VAR ", " VAR. ", fixed5)
  fixed7 <- gsub(" (F|FO|FO\\.|FORM|FORM\\.|FORMA|FORMA\\.) ", " F. ", fixed6)
  fixed8 <- gsub(" (SSP|SPP|SUBSP|SP|SP\\.|SPP\\.) ", " SUBSP. ", fixed7)

  # Manejar híbridos (eliminar 'X' y '\u00d7')
  fixed9 <- gsub("(^X )|( X$)|( X )|(^\u00d7 )|( \u00d7$)|( \u00d7 )", " ", fixed8)
  hybrids <- fixed8 == fixed9
  if (!all(hybrids)) {
    sp_hybrids <- splist[!hybrids]
    warning(paste("The 'X' sign indicating hybrids have been removed in the",
                  "following names before search:",
                  paste(paste0("'", sp_hybrids, "'"), collapse = ", ")),
            immediate. = TRUE, call. = FALSE)
  }

  # Eliminar múltiples espacios
  fixed10 <- gsub(" +", " ", fixed9)

  # Eliminar símbolos no alfabéticos al inicio
  for(j in 1:100) {
    whichs <- which(grepl("^[^A-Z]", fixed10))
    if(length(whichs) > 0)
      fixed10[whichs] <- gsub("^[^A-Z]", "", fixed10[whichs])
    whichs <- which(grepl("^[^A-Z]", fixed10))
    if(length(whichs) == 0) break
  }

  return(fixed10)
}

#------------------------------------------------
#' @keywords internal
# Function wrap of .classify_algo for multiple species
.splist_classify <- function(x) {

  x <- .names_standardize(x)

  ##################
  infrasp <- c("subsp.", "ssp.", "var.", "subvar.",
               "forma", "f.", "subf.")
  Infrasp_cat <- toupper(infrasp)
  # Regular expression to make sure, infra code is between names
  Infrasp_cat_reg <- paste("[[:alpha:]]",
                           gsub("\\.",
                                "\\\\.",
                                Infrasp_cat),
                           "[[:alpha:]]")
  Infrasp_cat_reg |>  length()
  # Split names
  x_split <- strsplit(x, " ")

  # Aply the algorithm
  result <- lapply(x_split,
                   .classify_algo,
                   Infrasp_cat_reg)
  # Combine result list into a matrix
  result <- do.call(rbind, result)
  result <- cbind(x, result)
  # Combine categories and remove
  result[, 5] <- paste0(result[, 5], result[, 6])
  result[, 9] <- paste0(result[, 9], result[, 10])
  result <- result[, -c(6, 10), drop = FALSE]

  # Give the colnames of the matrix
  colnames(result) <- c(
    "Orig.Name",
    "Orig.Genus",
    "Orig.Species",
    "Author",
    "Subspecies",
    "Variety",
    "Subvariety",
    "Forma",
    "Subforma"
  )
  result
  return(result)
}

#------------------------------------------------
# The algorithm for one name
.classify_algo <- function(x_split_i,
                           Infrasp_cat_reg) {

  # Base output
  output <- character(10)

  # Count the number of names
  n <- length(x_split_i)

  # Genus and epithet
  output[1:2] <- x_split_i[1:2]


  # Check for infrataxa
  if (n > 2) {
    # Connect previous and next name to check for infras
    x_split_i_paste <- x_split_i
    x_split_i_paste[2:n] <- paste(substr(x_split_i[1:(n - 1)], 1, 1),
                                  x_split_i[2:n],
                                  substr(x_split_i[3:n],1 , 1))

    infra_check <- sapply(as.list(Infrasp_cat_reg),
                          function(x, y) {
                            regexpr(x, y) == 1
                          },
                          x_split_i_paste)
    infra_id <- rowSums(infra_check) > 0



    # if there is none get only the author name
    if (!any(infra_id)) {
      output[3] <- paste(x_split_i[3:n],
                         collapse = " ")
    } else {
      # If it has infra categories, get them

      n_infra <- sum(infra_id) # Number of infra categories
      pos <- which(infra_id)
      for (i in 1:n_infra) {
        # do it for all infra names
        # Get the position of the infra
        pos_1 <- pos[i] + 1
        pos_out <- which(infra_check[pos[i], ]) + 3
        output[pos_out] <- x_split_i[pos_1]
      }
      if (n > pos_1) {
        # get the author
        output[3] <- paste(x_split_i[(pos_1 + 1):n],
                           collapse = " ")
      }
      if (pos[1] > 3) { # Author names before infras
        output[3] <- paste(x_split_i[3:(pos[1] - 1)],
                           collapse = " ")
      }
    }
  }
  return(output)
}


# ---------------------------------------------------------------
#' @keywords internal
# Definir la función para transformar el data frame
.transform_split_classify <- function(df) {
  # Convertir a data frame
  df <- as.data.frame(df)
  df$sorter <- 1:nrow(df)

  # Crear las nuevas columnas infraspecie e infra_rank
  df$Orig.Infraspecies <- with(df, ifelse(Subspecies != "", Subspecies,
                                    ifelse(Variety != "", Variety,
                                           ifelse(Subvariety != "", Subvariety,
                                                  ifelse(Forma != "", Forma,
                                                         ifelse(Subforma != "", Subforma, NA_character_))))))

  df$Infra.Rank <- with(df, ifelse(Subspecies != "", "SUBSP.",
                                   ifelse(Variety != "", "VAR.",
                                          ifelse(Subvariety != "", "SUBVAR.",
                                                 ifelse(Forma != "", "F.",
                                                        ifelse(Subforma != "", "SUBF.", NA_character_))))))

  # Añadir la columna rank
  df$Rank <- ifelse(!is.na(df$Orig.Genus) & !is.na(df$Orig.Species) & is.na(df$Orig.Infraspecies), 2,
         ifelse(!is.na(df$Orig.Genus) & !is.na(df$Orig.Species) & !is.na(df$Orig.Infraspecies), 3,
                ifelse(is.na(df$Orig.Species) & is.na(df$Orig.Infraspecies), 1, NA)))

  # Reordenar las columnas para que infraspecie e infra_rank estén antes de Subspecies
  column_order <- c( "sorter","Orig.Name", "Orig.Genus", "Orig.Species", "Author",
                    "Orig.Infraspecies", "Infra.Rank", "Rank")#,
                   # "Subspecies", "Variety", "Subvariety",
                    #"Forma", "Subforma")

  df <- df[, column_order]

  return(df)
}

# ---------------------------------------------------------------
#' @keywords internal
map_dfr_progress <- function(.x, .f, ..., .id = NULL) { ## credits to https://www.jamesatkins.net/posts/progress-bar-in-purrr-map-df/
  function_name <- stringr::str_remove(toString(substitute(.f)), '_helper')
  .f <- purrr::as_mapper(.f, ...)
  pb <- progress::progress_bar$new(total = length(.x),
                                   force = TRUE,
                                   format = paste(paste0(eval(...), collapse = ' '), ": ",
                                                  function_name, "[:bar] :percent", collapse = ''))
  # pb <- progress::progress_bar$new(total = length(.x),
  #                                  force = TRUE,
  #                                  format = paste(paste0(eval(...), collapse = ' '), ": ", substitute(.f), "[:bar] :percent", collapse = ''))


  f <- function(...) {
    pb$tick()
    .f(...)
  }

  #future::plan(future::multicore, workers = 4)
  purrr::map_dfr(.x, f, ..., .id = .id)
}

# ---------------------------------------------------------------
#' @keywords internal
get_trees_of_genus <- function(genus, target_df = NULL){
  return(target_df |>
           dplyr::filter(Genus %in% genus) |>
           dplyr::select(c('Genus', 'Species')))
}
## locally save output of get_trees_of_genus of called more than once for the same inputs. --> maybe we should get rid of this, as I suppose it's not effectively speading up things due to the increased memory usage.
memoised_get_trees_of_genus <- memoise::memoise(get_trees_of_genus)


# ---------------------------------------------------------------
#' @keywords internal
simple_cap <- function (x) {
  words <- sapply(strsplit(x, " "),
                  function(words) paste(tolower(words),
                   collapse = " "))
  capitalized <- sapply(strsplit(words, ""), function(word) {
    if (length(word) > 0) {
      word[1] <- toupper(word[1])
    }
    paste(word, collapse = "")
  })
  return(capitalized)
}

# ---------------------------------------------------------------
#' @keywords internal
str_to_simple_cap <- function(text) {
  # Convertir todo el texto a minúsculas
  text <- tolower(text)

  # Obtener la primera letra y convertirla a mayúscula
  first_letter <- toupper(substr(text, 1, 1))

  # Obtener el resto del texto desde la segunda letra en adelante
  rest_text <- substr(text, 2, nchar(text))

  # Combinar la primera letra en mayúscula con el resto del texto en minúsculas
  result <- paste0(first_letter, rest_text)

  return(result)
}

# ---------------------------------------------------------------
#' @keywords internal
.check_binomial <- function(splist_class, splist) {

  missing_bino <- which(apply(splist_class[, 3:4, drop = FALSE],
                              1,
                              function(x) {any(is.na(x))}))
  if (length(missing_bino) > 0) {
    message(paste0("The species list (splist) should only include binomial names.",
                   " The following names were submitted at the genus level: ",
                   paste(paste0("'", splist[missing_bino], "'"),
                         collapse = ", ")))

  }
  return(missing_bino)
}


# ---------------------------------------------------------------
#' @keywords internal
# get_target <- function(backbone = NULL, target_df = NULL){
#   #####
#   assertthat::assert_that(
#     any(
#       is.null(backbone),
#       all(backbone %in% c('v09',
#                           'v10', 'v11',
#                           '12', 'v13'))#,
#       #all(backbone %in% c('GBIF', 'WFO', 'WCVP', 'BGCI', 'CUSTOM'))
#     )
#   )
#
#   if(is.null(backbone)){
#     return(dplyr::filter(ppendemic.source,
#                          v11 == TRUE))
#   }
#   else {
#     return(dplyr::filter(ppendemic.source,
#                          get(backbone) == TRUE))
#   }
#
# }
#
# memoised_get_target <- memoise::memoise(get_target)

# ---------------------------------------------------------------
utils::globalVariables(c("%>%", "Genus", "Genus.x", "Matched.Genus",
                         "Matched.Infraespecie", "Matched.Species",
    "Orig.Genus", "Orig.Infraespecie", "Orig.Species", "Sorter", "Species",
    "fuzzy_genus_dist", "fuzzy_infraspecies_dist", "fuzzy_species_dist",
    "infraspecies", "sorter",  "Matched.Infraspecies", "Orig.Infraspecies",
    "Comp.Rank",  "Matched.Rank",  "Orig.Name", "Rank", "Matched.Name"))

