library(shiny)

fields <- c("Name", 
            "Firm", 
            "Date", 
            "Results", 
            "TextResults",
            "Responsiveness",
            "TextResponsivenss",
            "Expertise", 
            "TextExpertise",
            "Efficiency", 
            "TextEfficiency",
            "Compatability",
            "TextCompatability",
            "Understanding", 
            "TextUnderstanding",
            "Predictability",
            "TextPredictability")
outputDir <- "~/Documents/Code/responses/"

saveData <- function(data){
  data <- t(data)
  # Create a unique file name
  fileName <- sprintf("%s_%s.csv", as.integer(Sys.time()),
  digest::digest(data))
  # Write file to local system
  write.csv(
    x=data,
    file=file.path(outputDir, fileName),
    row.names=FALSE, quote=TRUE
  )
}

# Load all previous responses
loadData <- function() {
  # Read all files into a list
  files <- list.files(outputDir, full.names=TRUE)
  data <- lapply(files, read.csv, stringsAsFactors=FALSE)
  # Concatenate all data together into one data.frame
  data <- do.call(rbind, data)
  data
}

# Shiny app with 3 fields that the user can submit data for
shinyApp(
  ui=fluidPage(
    headerPanel("The QualMet Scorecard and Assessment Platform",
    tags$head(
    tags$style(type='text/css', 
               "select, textarea, input[type='text'] {margin-bottom: 0px;}"
               , "#submit {
               color: rgb(255, 255, 255);
               text-shadow: 0px -1px 0px rgba(0, 0, 0, 0.25);
               background-color: rgb(189,54,47);
               background-image: -moz-linear-gradient(center top , rgb(108,108,108), rgb(189,54,47));
               background-repeat: repeat-x;
               border-color: rgba(0, 0, 0, 0.1) rgba(0, 0, 0, 0.1) rgba(0, 0, 0, 0.25);
               }"
    ))),
  sidebarPanel(
      h5("Prototype Created by:"),
      tags$a("Qualmet", 
             href="http://www.qualmetlegal.com")),
    DT::dataTableOutput("responses", width=600), tags$hr(),
    textInput("Name", "Your Name:", ""),
    selectInput("Firm", "Firm You Are Evaluating (Select A Firm From the Dropdown Menu):", 
                choices=c("Firm A" = "Firm A",
                          "Firm B" = "Firm B", 
                          "Firm C" = "Firm C",
                          "Firm D" = "Firm D",
                          "Firm E" = "Firm E",
                          "Firm F" = "Firm F",
                          "Firm G" = "Firm G",
                          "Firm H" = "Firm H",
                          "Firm I" = "Firm I", 
                          "Firm J" = "Firm J")), 
    dateInput("Date", "Date:"),
    br(),
    radioButtons("Results", "Execution/Results:",
                 c("(1) Does Not Meet Expectations" = "1",
                 "(2) Partially Meets Expectations" = "2",
                   "(3) Meets Expectations" = "3",
                   "(4) Exceeds Expectations" = "4",
                   "(5) Far Exceeds Expectations" = "5")),
    textInput("TextResults", "Comments on Execution/Results (Optional):", ""),
    br(),
    radioButtons("Responsiveness", "Responsiveness:",
                 c("(1) Does Not Meet Expectations" = "1",
                   "(2) Partially Meets Expectations" = "2",
                   "(3) Meets Expectations" = "3",
                   "(4) Exceeds Expectations" = "4",
                   "(5) Far Exceeds Expectations" = "5")),
    textInput("TextResponsiveness", "Comments on Responsiveness (Optional):", ""),
    br(),
    radioButtons("Expertise", "Expertise:",
                 c("(1) Does Not Meet Expectations" = "1",
                   "(2) Partially Meets Expectations" = "2",
                   "(3) Meets Expectations" = "3",
                   "(4) Exceeds Expectations" = "4",
                   "(5) Far Exceeds Expectations" = "5")),
    textInput("TextExpertise", "Comments on Expertise (Optional):", ""),
    br(),
    radioButtons("Efficiency", "Efficiency:",
                 c("(1) Does Not Meet Expectations" = "1",
                   "(2) Partially Meets Expectations" = "2",
                   "(3) Meets Expectations" = "3",
                   "(4) Exceeds Expectations" = "4",
                   "(5) Far Exceeds Expectations" = "5")),
    textInput("TextEfficiency", "Comments on Efficiency (Optional):", ""),
    br(),
    radioButtons("Compatability", "Compatability With Company Values:",
                 c("(1) Does Not Meet Expectations" = "1",
                   "(2) Partially Meets Expectations" = "2",
                   "(3) Meets Expectations" = "3",
                   "(4) Exceeds Expectations" = "4",
                   "(5) Far Exceeds Expectations" = "5")),
    textInput("TextCompatability", "Comments on Compatability With Company Values (Optional):", ""),
    br(),
    radioButtons("Understanding", "Understanding Objectives:",
                 c("(1) Does Not Meet Expectations" = "1",
                   "(2) Partially Meets Expectations" = "2",
                   "(3) Meets Expectations" = "3",
                   "(4) Exceeds Expectations" = "4",
                   "(5) Far Exceeds Expectations" = "5")),
    textInput("TextUnderstanding", "Comments on Understanding of Objectives (Optional):", ""),
    br(),
    radioButtons("Predictability", "Predictable Cost:",
                 c("(1) Does Not Meet Expectations" = "1",
                   "(2) Partially Meets Expectations" = "2",
                   "(3) Meets Expectations" = "3",
                   "(4) Exceeds Expectations" = "4",
                   "(5) Far Exceeds Expectations" = "5")),
    textInput("TextPredictability", "Comments on Predicability of Cost (Optional):", ""),
  tags$button("Submit", 
                           id="submit", 
                           type="button", 
                           class="btn action-button", 
                           onclick="return confirm('Are You Sure?');" )
  ),
  server = function(input, output, session){
    formData <- reactive({
      data <- sapply(fields, function(x) input[[x]])
      data
  })
    # When submit is clicked save the form data
    observeEvent(input$submit, {
      saveData(formData())
    })
    
    # # Show the previous responses
    # # (update with current response when Submit is clicked)
    # output$responses <- DT::renderDataTable({
    #   input$submit
    #   loadData()
    # })
  }
)

