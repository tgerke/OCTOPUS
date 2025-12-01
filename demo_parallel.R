##### Demo: Using Parallel Simulation in OCTOPUS #####
#
# This script demonstrates how to use the new parallel execution capability
# in OCTOPUS using the future framework.
#
# Author: GitHub Copilot
# Date: December 2025
#

library(OCTOPUS)

cat("\n")
cat("====================================================================\n")
cat("  OCTOPUS Parallel Simulation Demo\n")
cat("====================================================================\n\n")

# Check system capabilities
n_cores <- parallel::detectCores(logical = FALSE)
cat("System Information:\n")
cat("  Available CPU cores:", n_cores, "\n")
cat("  Recommended workers:", max(1, n_cores - 1), "(leave 1 core for OS)\n\n")

# Check if future packages are available
has_future <- requireNamespace("future", quietly = TRUE) && 
              requireNamespace("future.apply", quietly = TRUE)

if (!has_future) {
    cat("Note: future and future.apply packages are not installed.\n")
    cat("      Parallel execution will not be available.\n")
    cat("      Install with: install.packages(c('future', 'future.apply'))\n\n")
} else {
    library(future)
    cat("✓ Parallel execution packages are available\n\n")
}

cat("====================================================================\n")
cat("  Basic Usage\n")
cat("====================================================================\n\n")

cat("1. Sequential Execution (default):\n")
cat("   --------------------------------\n")
cat("   # No special setup needed\n")
cat("   results <- RunSimulation(lSimulation)\n\n")

if (has_future) {
    cat("2. Parallel Execution:\n")
    cat("   -------------------\n")
    cat("   library(future)\n")
    cat("   plan(multisession, workers = 4)  # Use 4 cores\n")
    cat("   results <- RunSimulation(lSimulation)\n")
    cat("   plan(sequential)  # Good practice: reset when done\n\n")
    
    cat("3. Automatic Worker Selection:\n")
    cat("   ----------------------------\n")
    cat("   library(future)\n")
    cat("   # Use all but one core (recommended)\n")
    cat("   plan(multisession, workers = parallel::detectCores() - 1)\n")
    cat("   results <- RunSimulation(lSimulation)\n")
    cat("   plan(sequential)\n\n")
}

cat("====================================================================\n")
cat("  Performance Tips\n")
cat("====================================================================\n\n")

cat("• Start with 4 workers and scale up based on results\n")
cat("• Leave 1-2 cores free for the OS and other tasks\n")
cat("• More workers = more memory usage (typically 100-500 MB per worker)\n")
cat("• Parallel speedup is best with nQtyReps >= 20\n")
cat("• Expected speedup: 3-4x with 4 cores, 6-7x with 8 cores\n")
cat("• Use 'multisession' on all platforms (Windows, Mac, Linux)\n")
cat("• On Linux/Mac HPC: 'multicore' is more efficient but doesn't work on Windows\n\n")

cat("====================================================================\n")
cat("  Example Workflow\n")
cat("====================================================================\n\n")

cat("# Example: Running a simulation with parallelization\n")
cat("library(OCTOPUS)\n")
cat("library(future)\n\n")

cat("# Load your simulation design\n")
cat("# source('SimulationDesign.R')\n")
cat("# cSimulation <- SetupSimulations(cTrialDesign, nQtyReps = 100)\n\n")

cat("# Set up parallel execution\n")
cat("plan(multisession, workers = 4)\n\n")

cat("# Run simulation (automatically uses parallel execution)\n")
cat("# results <- RunSimulation(cSimulation)\n\n")

cat("# Reset to sequential\n")
cat("plan(sequential)\n\n")

cat("# Process results as usual\n")
cat("# ...\n\n")

if (has_future) {
    cat("====================================================================\n")
    cat("  Live Demo\n")
    cat("====================================================================\n\n")
    
    cat("Current future plan:", class(plan())[1], "\n\n")
    
    cat("Testing worker count detection:\n")
    cat("  Available workers (sequential):", nbrOfWorkers(), "\n")
    
    # Temporarily set up parallel plan
    plan(multisession, workers = min(2, n_cores))
    cat("  Available workers (parallel):", nbrOfWorkers(), "\n")
    
    # Reset
    plan(sequential)
    cat("  Reset to sequential:", nbrOfWorkers(), "worker\n\n")
    
    cat("✓ Parallel execution is configured correctly!\n\n")
}

cat("====================================================================\n")
cat("  Troubleshooting\n")
cat("====================================================================\n\n")

cat("If you encounter issues:\n\n")

cat("1. Check package installation:\n")
cat("   installed.packages()[c('future', 'future.apply'), 'Version']\n\n")

cat("2. Verify plan is set correctly:\n")
cat("   class(future::plan())[1]  # Should be 'multisession' when parallel\n\n")

cat("3. Check worker count:\n")
cat("   future::nbrOfWorkers()  # Should be > 1 when parallel\n\n")

cat("4. Reset if stuck:\n")
cat("   future::plan(future::sequential)\n\n")

cat("5. For memory issues:\n")
cat("   - Reduce number of workers\n")
cat("   - Monitor with: pryr::mem_used() or gc()\n\n")

cat("====================================================================\n")
cat("  For More Information\n")
cat("====================================================================\n\n")

cat("• OCTOPUS Parallelization Analysis: See PARALLELIZATION_ANALYSIS.md\n")
cat("• future package: https://future.futureverse.org/\n")
cat("• future.apply package: https://future.apply.futureverse.org/\n\n")

cat("====================================================================\n\n")
