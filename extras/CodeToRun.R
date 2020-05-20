library(NSAID)

# Optional: specify where the temporary files (used by the ff package) will be created:
options(fftempdir = "")

# Maximum number of cores to be used:
maxCores <- parallel::detectCores()

# The folder where the study intermediate and result files will be written:
outputFolder <- ""

# Details for connecting to the server:
connectionDetails <- DatabaseConnector::createConnectionDetails(dbms = "sql server",
                                                                server = '',
                                                                user = '',
                                                                password = '')

# The name of the database schema where the CDM data can be found:
cdmDatabaseSchema <- "CDMPv531.dbo"

# The name of the database schema and table where the study-specific cohorts will be instantiated:
cohortDatabaseSchema <- "CDMPv531_Result.dbo"
cohortTable <- "JMPark_NSAID"

# Some meta-information that will be used by the export function:
databaseId <- "AUSOM"
databaseName <- "AUSOM"
databaseDescription <- "Medicare Claims Synthetic Public Use Files (SynPUFs) were created to allow interested parties to gain familiarity using Medicare claims data while protecting beneficiary privacy. These files are intended to promote development of software and applications that utilize files in this format, train researchers on the use and complexities of Centers for Medicare and Medicaid Services (CMS) claims, and support safe data mining innovations. The SynPUFs were created by combining randomized information from multiple unique beneficiaries and changing variable values. This randomization and combining of beneficiary information ensures privacy of health information."

# For Oracle: define a schema that can be used to emulate temp tables:
oracleTempSchema <- NULL

execute(connectionDetails = connectionDetails,
        cdmDatabaseSchema = cdmDatabaseSchema,
        cohortDatabaseSchema = cohortDatabaseSchema,
        cohortTable = cohortTable,
        oracleTempSchema = oracleTempSchema,
        outputFolder = outputFolder,
        databaseId = databaseId,
        databaseName = databaseName,
        databaseDescription = databaseDescription,
        createCohorts = TRUE,
        synthesizePositiveControls = TRUE,
        runAnalyses = TRUE,
        runDiagnostics = TRUE,
        packageResults = TRUE,
        maxCores = maxCores)

resultsZipFile <- file.path(outputFolder, "export", paste0("Results", databaseId, ".zip"))
dataFolder <- file.path(outputFolder, "shinyData")

prepareForEvidenceExplorer(resultsZipFile = resultsZipFile, dataFolder = dataFolder)

launchEvidenceExplorer(dataFolder = dataFolder, blind = TRUE, launch.browser = FALSE)
