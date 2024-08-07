% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/matching_ppendemic.R
\name{matching_ppendemic}
\alias{matching_ppendemic}
\title{Match Species Names to Endemic Plant List of Peru}
\usage{
matching_ppendemic(splist)
}
\arguments{
\item{splist}{A vector containing the species list.}
}
\value{
Returns a tibble with the matched names in
Matched.Genus, Matched.Species for binomial names,
and Matched.Infraspecies for valid infra species names.
}
\description{
This function matches given species names against the internal database of endemic plant species in Peru.
}
\details{
The function first attempts to directly match species names with exact
matches in the database (genus and specific epithet, or genus, specific
epithet, and infra species). If no exact match is found, the function
performs a fuzzy match using the fuzzyjoin package with an optimal string alignment distance of one, as implemented in stringdist.

The maximum edit distance is intentionally set to one.

The function matching_ppendemic returns a tibble with new columns Matched.Genus, Matched.Species, and Matched.Infraspecies, containing the matched names or NA if no match was found.

Additionally, a logical column is added for each function called, allowing users to see which functions were applied to each name during the matching process. If a process column shows \code{NA}, the corresponding function was not called for that name because it was already matched by a preceding function.
}
\keyword{internal}
