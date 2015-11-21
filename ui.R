library(shiny)

shinyUI(fluidPage(
    h2("Probability Quiz"),
    div("To test your understanding of basic probability, choose values for a roll 
        of 2 die. Specify options as either dice falling exactly as entered - one 
        after the other (e.g. 3 then 1); or the dice entered in any order 
        (e.g. 3 then 1 or 1 then 3); or any combination of the dice where the total 
        is the same as the total of the dice picked (e.g. 1 then 3 or 2 then 2 or 3 then 1). 
        You may press the Hint button for a visual idea of how to calculate these. 
        Enter your probablity estimate then press the submit button for the result."),
      br(),
      div("As the number of rolls of die increase it is more likely that the probable
          outcomes will be observed on average. This can be tested on the accompanying
          histogram of randomly generated rolls as the number is increased via the 
          slider. This effect is described in the Central Limit Theorem, which 
          observes that the averages of samples have approximately normal 
          distributions as the sample size increases."),

    fluidRow(
        
        column(1,
               radioButtons("Dice1", label = h3("Dice 1"),
                            choices = list("1" = 1, "2" = 2, "3" = 3,
                                           "4" = 4, "5" = 5, "6" = 6),
                            selected = 3)),
      
        column(1,
               radioButtons("Dice2", label = h3("Dice 2"),
                            choices = list("1" = 1, "2" = 2, "3" = 3,
                                           "4" = 4, "5" = 5, "6" = 6),
                            selected = 1)),
        column(2,
               radioButtons("Options", label = h3("Options"),
                            choices = list("Ordered" = 1, "Unordered" = 2,
                                           "Total Value" = 3),
                            selected = 3),
               verbatimTextOutput("TotalValue")),

       column(3, 
              textInput("SuggestedProb", 
                 label = h3("Probability Estimate (decimal or fraction)"), 
                 value = "0"),
       actionButton("EstimateButton", "Submit")),

       column(4, 
         br(),
         verbatimTextOutput("Estimated"),
         br(),
         verbatimTextOutput("Answered"),
         br(),
         verbatimTextOutput("Explained"))

),
    
    fluidRow(
        column(5,
               actionButton("imageButton", "Hint"),
               br(),
               imageOutput("diceImage")),

        column(7,
               sliderInput('Rolls', 'Adjust number of rolls',
                           value = 50, min = 2, max = 1552, step = 50),
               plotOutput('rollsHist'))
    )
   

))
