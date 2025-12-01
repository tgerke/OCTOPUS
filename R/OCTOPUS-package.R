##### COPYRIGHT #############################################################################################################
#
# Copyright (C) 2018 JANSSEN RESEARCH & DEVELOPMENT, LLC
# This package is governed by the JRD OCTOPUS License, which is the
# GNU General Public License V3 with additional terms. The precise license terms are located in the files
# LICENSE and GPL.
#
#############################################################################################################################.

#' @keywords internal
#' @importFrom grDevices dev.off pdf
#' @importFrom graphics abline legend lines text title
#' @importFrom methods new
#' @importFrom stats coef lm na.omit predict pt qnorm qpois qt quantile rexp rgamma rmultinom rnorm runif t.test update vcov wilcox.test
#' @importFrom utils getS3method read.table write.table
#' @importFrom nlme gls varIdent corSymm
#' @importFrom coin wilcox_test statistic confint
#' @importFrom DoseFinding MCPMod
"_PACKAGE"

## usethis namespace: start
## usethis namespace: end
NULL

# Declare global variables to avoid R CMD check NOTEs
utils::globalVariables(c("gDebug", "gnPrintDetail", "gPrintEnrollment"))
