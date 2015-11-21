library(shiny)
library(dice)
library(MASS)

shinyServer(
    function(input, output) {
    
    # function to render an image of dice in response to pressing Hint button
    DiceImage <- eventReactive(input$imageButton, {
        filename <- normalizePath(file.path('.',
                       paste('dicediagram_medium.jpg', sep='')))
        
        # Return a list containing the filename and alt text
        list(src = filename, alt = "6 sided dice combinations")
    } )
        
    # Send a pre-rendered image, and don't delete the image after sending it
    output$diceImage <- renderImage({
       DiceImage() 
   
     }, deleteFile = FALSE)

    # current total value of the two dice selection    
    output$TotalValue <- renderText({as.numeric(input$Dice1) + as.numeric(input$Dice2)})
    
    # calculation of input text as a decimal
    inputEstimate <- eventReactive(input$EstimateButton, {
       inputVal = round(eval(parse(text=input$SuggestedProb)), 7)
    })
    
    output$Estimated <- renderText({
        paste("Entered:", round(inputEstimate(), 7))
    })  
    
    # function to return the probability of dice selection with options picked
    AnswerText <- eventReactive(input$EstimateButton, {
        
        # two dice in specific order    
        if (input$Options == 1) {
          dicelist = list(as.numeric(input$Dice1), as.numeric(input$Dice2))
          chanceNum = getEventProb(nrolls=2, ndicePerRoll=1, nsidesPerDie = 6, 
                                     eventList = dicelist, orderMatters = TRUE)          
        }
        # two dice in any order    
        else if (input$Options == 2) {
          dicelist = list(as.numeric(input$Dice1), as.numeric(input$Dice2))
          chanceNum = getEventProb(nrolls=2, ndicePerRoll=1, nsidesPerDie = 6, 
                                   eventList = dicelist, orderMatters = FALSE)          
        }
        # any two dice totalling a value (e.g. 6+1 = 7, 5+2 = 7)    
        else {
          dicelist = list(as.numeric(input$Dice1) + as.numeric(input$Dice2))
          chanceNum = getEventProb(nrolls=1, ndicePerRoll=2, nsidesPerDie = 6, 
                                   eventList = dicelist)
        } 
        
        chanceNum
    })  
    
    output$Answered <- renderText({
        paste("Answer:", round(AnswerText(), 7))
    })    
   
    # function to explain the anaswer in terms of the die rolls
    ExplanationText <-  eventReactive(input$EstimateButton, {
        Explanation = ""
        # two dice in specific order    
        if (input$Options == 1) {
            Explanation <- paste("1 chance to throw", as.numeric(input$Dice1),
                                 "then", as.numeric(input$Dice2), "= 1/36 =", 
                                 round(1/36, 7))
        }        
        # two dice in any order    
        else if (input$Options == 2) {
           if(as.numeric(input$Dice1) == as.numeric(input$Dice2)) {
               Explanation <- paste0("Only 1 variation for doubles = 1/36 = ", round(1/36, 7))   
           }
           else {
               Explanation <- paste("2 chances to throw a", as.numeric(input$Dice1),
                                     "and a", as.numeric(input$Dice2), "= 2/36 =", 
                                     round(2/36, 7))
           }
        }
        # any two dice totalling a value (e.g. 6+1 = 7, 5+2 = 7)    
        else {
            dicevalue = as.numeric(input$Dice1) + as.numeric(input$Dice2)
            switch(as.character(dicevalue),
                   "2" = {Explanation <- paste("1 chance to total 2 = 1/36 =", round(1/36, 7))},
                   "3" = {Explanation <- paste("2 chances to total 3 = 2/36 =", round(2/36, 7))},
                   "4" = {Explanation <- paste("3 chances to total 4 = 3/36 =", round(3/36, 7))},
                   "5" = {Explanation <- paste("4 chances to total 5 = 4/36 =", round(4/36, 7))},
                   "6" = {Explanation <- paste("5 chances to total 6 = 5/36 =", round(5/36, 7))},
                   "7" = {Explanation <- paste("6 chances to total 7 = 6/36 =", round(6/36, 7))},
                   "8" = {Explanation <- paste("5 chances to total 8 = 5/36 =", round(5/36, 7))},
                   "9" = {Explanation <- paste("4 chances to total 9 = 4/36 =", round(4/36, 7))},
                   "10" = {Explanation <- paste("3 chances to total 10 = 3/36 =", round(3/36, 7))},
                   "11" = {Explanation <- paste("2 chances to total 11 = 2/36 =", round(2/36, 7))},
                   "12" = {Explanation <- paste("1 chance to total 12 = 1/36 =", round(1/36, 7))}
            )
        } 
        
        Explanation 
        
    })
    
    output$Explained <- renderText({
        ExplanationText()
    })  
    
    output$rollsHist <- renderPlot({
        set.seed(1010)
        hist(rowSums(replicate(2, sample(6, input$Rolls, replace=T))), 
             breaks = c(2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12), 
             col='lightblue', xlab='Combined dice value', 
             ylab = 'Frequency of rolls', main='Histogram')
       }, height = 300, width = 500)
    
})