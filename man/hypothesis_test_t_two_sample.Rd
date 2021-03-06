% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/hypothesis_tests.R
\name{hypothesis_test_t_two_sample}
\alias{hypothesis_test_t_two_sample}
\title{Perform a two sample t test of one numerical variable across mutliple groups}
\usage{
hypothesis_test_t_two_sample(dependent.var, independent.var, design)
}
\arguments{
\item{dependent.var}{string with the column name in `data` of the dependent variable. Should be numerical.}

\item{design}{the svy design object created using map_to_design or directly with svydesign}

\item{independen.var}{string with the column name in `data` of the independent variable. Should be a 'select one' with few (<15) categories.}
}
\value{
A list with the results of the test (T-value, p value, etc.) or the error message.
}
\description{
Perform a two sample t test of one numerical variable across mutliple groups
}
\examples{
hypothesis_test_t_two_sample("males_13_15", "resp_gender", design)
}
