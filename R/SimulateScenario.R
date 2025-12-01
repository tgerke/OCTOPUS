##### COPYRIGHT #############################################################################################################
#
# Copyright (C) 2018 JANSSEN RESEARCH & DEVELOPMENT, LLC
# This package is governed by the JRD OCTOPUS License, which is the
# GNU General Public License V3 with additional terms. The precise license terms are located in the files
# LICENSE and GPL.
#
#############################################################################################################################.

#' @name SimulateScenario
#' @title SimulateScenario
#' @description { SimulateScenario This function is the main funciton in simulating a scenario.
#' The scenario will be simulated cScen$nQtyReps times.  }
#' @seealso { \href{https://github.com/kwathen/OCTOPUS/blob/master/R/SimulateScenario.R}{View Code on GitHub} }
#' @export
SimulateScenario <- function( cScen, cTrialDesign  )
{
    UseMethod( "SimulateScenario", cScen )

}

#' @title SimulateScenario.default
#' @describeIn SimulateScenario  Default method that is suitable for most cases.
#' @seealso { \href{https://github.com/kwathen/OCTOPUS/blob/master/R/SimulateScenario.R}{View Code on GitHub} }
#' @export
SimulateScenario.default <- function( cScen, cTrialDesign  )
{
    nQtyReps        <- cScen$nQtyReps
    nTrialIDStart   <- cScen$nTrialIDStart
    
    # Check if future.apply is available and if a parallel plan is set
    bUseParallel <- FALSE
    if (requireNamespace("future.apply", quietly = TRUE) && 
        requireNamespace("future", quietly = TRUE)) {
        # Check if user has set a parallel plan (not sequential and not uniprocess)
        tryCatch({
            currentPlan <- future::plan()
            planClass <- class(currentPlan)[1]
            # Only use parallel if explicitly set to multisession, multicore, or cluster
            bUseParallel <- planClass %in% c("multisession", "multicore", "cluster")
        }, error = function(e) {
            bUseParallel <- FALSE
        })
    }
    
    if (bUseParallel) {
        # Parallel execution path
        if (gnPrintDetail >= 1) {
            message("Using parallel execution with ", future::nbrOfWorkers(), " workers")
        }
        
        # Create a list of scenario objects, one per replication
        # Each has a unique trial ID
        lScenarios <- lapply(1:nQtyReps, function(i) {
            cScenCopy <- cScen
            cScenCopy$nTrialID <- nTrialIDStart + i - 1
            return(cScenCopy)
        })
        
        # Run simulations in parallel
        lResults <- future.apply::future_lapply(
            lScenarios,
            function(cScenRep) {
                SimulateSingleTrial(cScenRep, cTrialDesign)
            },
            future.seed = TRUE  # Ensure reproducible random numbers
        )
        
        # Aggregate results
        vRes       <- NULL
        lISAAnaRes <- list()
        
        for(i in 1:nQtyReps) {
            rRes <- lResults[[i]]
            vRes <- rbind(vRes, c(unlist(rRes$lRet)))
            
            lISAAna <- rRes$lRetISAAna
            nQtyISA <- length(lISAAna)
            for(iISA in 1:nQtyISA) {
                if(i == 1) {
                    lISAAnaRes[[iISA]] <- lISAAna[[iISA]]
                } else {
                    if(ncol(lISAAnaRes[[iISA]]) != ncol(lISAAna[[iISA]])) {
                        browser()
                    }
                    lISAAnaRes[[iISA]] <- rbind(lISAAnaRes[[iISA]], lISAAna[[iISA]])
                }
            }
        }
        
    } else {
        # Sequential execution path (original code)
        vRes            <- vector()
        lISAAnaRes      <- list()
        i               <- 1
        
        cScen$nTrialID  <- cScen$nTrialIDStart
        repeat
        {
            #print( paste( "Rep ", i))
            # if( cScen$nTrialID == 23 & i == 3 )
            #     browser()
            rRes <- SimulateSingleTrial( cScen, cTrialDesign  )
            
            vRes <- rbind( vRes,c( unlist( rRes$lRet ) ))
            
            
            lISAAna <- rRes$lRetISAAna
            nQtyISA <- length( lISAAna )
            for( iISA in 1:nQtyISA )
            {
                if( i == 1 )
                {
                    lISAAnaRes[[ iISA ]] <- lISAAna[[ iISA]]
                }
                else
                {
                    if( ncol( lISAAnaRes[[ iISA ]]) != ncol(  lISAAna[[ iISA]]))
                        browser()
                    lISAAnaRes[[ iISA ]] <- rbind( lISAAnaRes[[ iISA ]], lISAAna[[ iISA]])
                }
                
            }
            
            if( i == nQtyReps)
                break
            i <- i + 1
            cScen$nTrialID <- cScen$nTrialID + 1
        }
    }
    
    return( list( vRes=vRes, lISAAnaRes = lISAAnaRes)  )

}
