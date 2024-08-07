% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fuzzy_match_spp_within_genus.R
\name{fuzzy_match_species_within_genus_helper}
\alias{fuzzy_match_species_within_genus_helper}
\title{Fuzzy Match Species within Genus}
\usage{
fuzzy_match_species_within_genus_helper(df, target_df)
}
\arguments{
\item{df}{A tibble containing the species data to be matched.}

\item{target_df}{A tibble representing the ppendemic database containing the reference list of endemic species.}
}
\value{
A tibble with an additional logical column fuzzy_match_species_within_genus, indicating whether the specific epithet was successfully fuzzy matched within the matched genus (\code{TRUE}) or not (\code{FALSE}).
}
\description{
This function attempts to fuzzy match species names within a genus to the ppendemic database using fuzzyjoin::stringdist for fuzzy matching.
}
\keyword{internal}
