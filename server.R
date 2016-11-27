server <- function(input, output) {
  filtered_bcl <- reactive({
    # Used to streamline the app, preventing temp errors from even happening. 
    # The problem is that when the app initializes, filtered is trying to access the country input, but the country input hasn’t been created yet. 
    # After Shiny finishes loading fully and the country input is generated, filtered tries accessing it again, this time it’s successful, and the error goes away.
    
    if (is.null(input$countryInput)){
      return(NULL)
    }
    
    bcl %>%
      filter(Price >= input$priceInput[1],
             Price <= input$priceInput[2],
             Type == input$typeInput,
             #Subtype == input$subtypeInput,
             Country == input$countryInput
      )
  })
  
  optimal_bcl <- reactive({
    filtered_bcl() %>% filter(Subtype == input$subtypeInput)
  })
  
  output$coolplot <- renderPlot({
    # preventing temp errors again
    if (is.null(optimal_bcl())){
      return()
    }
    ggplot(optimal_bcl(), aes(Alcohol_Content)) +
      geom_histogram()
  })
  output$results <- renderTable({
    # sorting by price
    if (input$logicalInput == TRUE){
      optimal_bcl()[order(optimal_bcl()$Price, decreasing = TRUE),]
    } else{
      optimal_bcl()
    }
  })
  # NO comma between different outputs
  output$summary <- renderText({
    paste0("There are ", nrow(optimal_bcl()), " options found available for you tonight!")
  })
  # As long as you use a reactive({}), you will need to use an observe({}) to view the reactive element. 
  # Reactive element can only be viewed if called upon with parantheses. i.e. priceDiff()
  #
  # priceDiff <- reactive({
  #   diff(input$priceInput)
  # })
  # 
  # observe({ print(priceDiff()) })
  
  output$subtypeOutput <- renderUI({
    selectInput("subtypeInput", "Subtypes", 
                choices = unique(filtered_bcl()$Subtype), 
                selected = "TABLE WINE RED")
  })
  
  output$countryOutput <- renderUI({
    #Add option to select all countries
    # checkboxInput("subCountriesInput", "Sort by countries", value = TRUE)
    # if(input)
    selectInput("countryInput", "Country",
                sort(unique(bcl$Country)),
                selected = "CANADA")
  })
  
}
shinyApp(ui = ui, server = server)