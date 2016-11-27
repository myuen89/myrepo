bcl <- read.csv("bcl-data.csv", stringsAsFactors = FALSE)

ui <- fluidPage(
  titlePanel(div(img(src = "./bcl_logo.png"), strong("Need a drink?"))), 
  sidebarLayout(
    sidebarPanel(
      sliderInput("priceInput", "Price", min = 0, max = 100, value = c(25, 40), pre = "$"), 
      radioButtons("typeInput", "Product type",
                   choices = c("BEER", "REFRESHMENT", "SPIRITS", "WINE"),
                   selected = "WINE"),
      # selectInput("typeInput", "Product type",
      #             choices = bcl$Type,
      #             selected = "WINE"),
      #checkboxGroupInput("subtypeInput", "Subtypes", choices = unique(bcl$Subtype), selected = "TABLE WINE RED"),
      uiOutput("subtypeOutput"),
      uiOutput("countryOutput"),
      
      radioButtons("logicalInput", "Sort results by price",
                   choices = c(TRUE, FALSE),
                   selected = TRUE
      )
    ), 
    mainPanel(
      plotOutput("coolplot"),
      # adds spacing in html rendering
      br(),
      # h2() affects font size
      h2(textOutput("summary")),
      br(),
      tableOutput("results")
    )
  )
)