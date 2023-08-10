#' ppendemic_tab: Endemic Plant Database of Peru
#'
#' The `ppendemic_tab` dataset is a tibble (data frame) that provides easy access
#' to a comprehensive database of Peru's endemic plant species. It contains a total
#' of 7,249 records with essential botanical information, including the accepted
#' name, accepted family, accepted name author, publication author, place of
#' publication, volume and page, and first published details.
#'
#' @format A tibble (data frame) with 7249 rows and 7 columns:
#'   \describe{
#'     \item{accepted_name}{Character vector. The accepted name of the endemic
#'     plant species.}
#'     \item{accepted_family}{Character vector. The family of the accepted name
#'     of the endemic plant species.}
#'     \item{accepted_name_author}{Character vector. The author(s) of the accepted
#'     name of the endemic plant species.}
#'     \item{publication_author}{Character vector. The author(s) of the publication
#'     containing the endemic plant species information.}
#'     \item{place_of_publication}{Character vector. The place of publication of
#'     the endemic plant species information.}
#'     \item{volume_and_page}{Character vector. The volume and page number of the
#'     publication containing the endemic plant species information.}
#'     \item{first_published}{Character vector. The first published year of the
#'     publication containing the endemic plant species information.}
#'   }
#'
#' @details The dataset provides a curated and up-to-date collection of Peru's
#' endemic plant species, gathered from reputable botanical sources and publications.
#' The data for this database was extracted and compiled from the World Checklist
#' of Vascular Plants (WCVP) database, which is a comprehensive and reliable
#' repository of botanical information.
#'
#' Researchers, botanists, ecologists, and nature enthusiasts can use this dataset
#' to explore and study the unique and diverse flora exclusive to Peru. The dataset
#' is particularly valuable for conducting studies related to biodiversity,
#' conservation, and ecological research.
#'
#' @source The dataset has been carefully compiled and updated to offer the latest
#' insights into Peru's endemic plant species. Original sources of the data include
#' authoritative botanical publications and research articles available in the WCVP
#' database.
#'
#' @examples
#'
#' # Load the package
#' library(ppendemic)
#'
#' # Access the dataset
#' data("ppendemic_tab")
#'
#'
#' @keywords dataset
#'
"ppendemic_tab"
