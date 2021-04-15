require(shiny)
require(elo)
require(ggplot2)
require(dplyr)
require(tidyverse)
require(shinydashboard)





elo_df <- read.csv("https://raw.githubusercontent.com/vicky61992/R_Project_Shiny_Dashboard/master/FileA.csv")
df <- read.csv("https://raw.githubusercontent.com/vicky61992/R_Project_Shiny_Dashboard/master/FileB.csv")

create_elo_data <- function(k){
    temp_df <- elo.run(winner ~ fighter + opponent, k = k, 
                       data = elo_df %>% arrange(fighter , date)) %>% 
        as_tibble() %>% 
        cbind(elo_df %>% arrange(fighter, date) %>% select(match_id)) %>% 
        select(team.A, team.B, elo.A, elo.B, match_id)
    
    rbind(temp_df %>% 
              select_at(vars(contains(".A"), contains("match_id"))) %>% 
              rename_all(.funs = function(x) str_replace(x, ".A", "")),
          temp_df %>% 
              select_at(vars(contains(".B"), contains("match_id"))) %>% 
              rename_all(.funs = function(x) str_replace(x, ".B", ""))) %>% 
        rename("fighter" = "team") %>% 
        left_join(df %>% 
                      select(fighter, date, weight_class, match_id),
                  by = c("fighter", "match_id")) %>% 
        mutate(date = as.Date(date))
}

create_elo_data(20) %>% colnames()


ui <- dashboardPage(
    dashboardHeader(title = "Fighter Data Analysis Dashboard"),
    
    dashboardSidebar(
        sidebarMenu(
          menuItem('About', tabName = 'about', icon = icon('pen')),
            menuItem("Weight Categories",
                     tabName = "Weight_Categories_tab",
                     icon = icon('chart-bar')),
            menuItem("Fighter to Fighter Comparison",
                     tabName = "Comparison_tab",
                     icon = icon('id-card')),
            menuItem("Source code", icon = icon("code"), href = "https://github.com/vicky61992/R_Project_Shiny_Dashboard+
                     ")
        )
    ),
    
    dashboardBody(
      tabItem(tabName = 'about',
              h2('Fighter Club', align = 'center'),
              tags$p('It is the largest MMA promotion company in the world and features some of the 
                     highest-level fighters in the sport on its roster.It produces events worldwide
                     that showcase twelve weight divisions (eight mens divisions and four womens divisions) 
                     and abides by the Unified Rules of Mixed Martial Arts.', 
                     style = 'font-size: 120%;margin-left:2.5em;'),
              
      ),
        tabItems(
            tabItem(tabName = "Weight_Categories_tab",
                    box(plotOutput("elo_timeseries")),
                    box(plotOutput("elo_dist")),
                    box(tableOutput("top_5_table")),
                    box(uiOutput("weight_class_selector_1")),
                    box(sliderInput(inputId = "v_k_1",
                                    label = "select",
                                    min = 1, 
                                    max = 100,
                                    value = 20))
                    
                    ),
            tabItem(tabName = "Comparison_tab",
                    fluidRow(box(uiOutput("fighter_selector")), box(uiOutput("opponent_selector"))),
                    fluidRow(box(valueBoxOutput("fighter_card")), box(valueBoxOutput("opponent_card"))),
                    box(uiOutput("weight_class_selector_2")),
                    box(sliderInput("v_k_2",
                                    label = "select",
                                    min = 1,
                                    max = 100,
                                    value = 20)))
        )
    )
    
    
)

server <- function(input, output) {
    
    output$weight_class_selector_1 <- renderUI({
        
        weight_class_1_df <- create_elo_data(input$v_k_1)
        
        
        selectInput(inputId = "v_weight_class_1",
                    label = "Weight Class",
                    choices = weight_class_1_df %>% 
                        select(weight_class) %>% 
                        distinct() %>% 
                        arrange(weight_class))
    })
    output$weight_class_selector_2 <- renderUI({
        
        weight_class_2_df <- create_elo_data(input$v_k_2)
        
        
        selectInput(inputId = "v_weight_class_2",
                    label = "Weight Class",
                    choices = weight_class_2_df %>% 
                        select(weight_class) %>% 
                        distinct() %>% 
                        arrange(weight_class))
    })
    output$fighter_selector <- renderUI({
        
        fighter_selector_df <- create_elo_data(input$v_k_2) %>% 
            filter(weight_class == input$v_weight_class_2) %>% 
            select(fighter) %>% 
            distinct() %>% 
            arrange(fighter)
        
        
        selectInput(inputId = "v_fighter",
                    label = "Fighter",
                    choices = fighter_selector_df)
    })
    output$opponent_selector <- renderUI({
        opponent_selector_df <- create_elo_data(input$v_k_2) %>% 
            filter(weight_class == input$v_weight_class_2) %>% 
            filter(fighter != input$v_fighter) %>% 
            select(fighter) %>% 
            distinct() %>% 
            arrange(fighter)
        
        selectInput(inputId = "v_opponent",
                    label = "Opponent",
                    choices = opponent_selector_df)
        
        
    })
    output$top_5_table <- renderTable({
        
        table_df <- create_elo_data(input$v_k_1)
        
        table_df %>% 
            filter(weight_class == input$v_weight_class_1) %>% 
            group_by(fighter) %>% 
            arrange(desc(elo)) %>% 
            slice(1) %>% 
            ungroup() %>% 
            top_n(elo, n = 5) %>% 
            arrange(desc(elo)) %>% 
            select(fighter, elo) %>% 
            mutate(rank = row_number())
        
        
    })
    
    output$elo_timeseries <- renderPlot({
        elo_timeseries_df <- create_elo_data(input$v_k_1) %>% 
            filter(weight_class == input$v_weight_class_1)
        
        top_5_fighters <- elo_timeseries_df %>% 
            group_by(fighter) %>% 
            arrange(desc(elo)) %>% 
            slice(1) %>% 
            ungroup() %>% 
            top_n(elo, n = 5) %>% 
            select(fighter)
        
        ggplot(data = elo_timeseries_df, aes(x = date, y = elo)) + 
            geom_point() + 
            geom_point(data = elo_timeseries_df %>% filter(fighter %in% top_5_fighters$fighter),
                       aes(x = date, y = elo, color = fighter)) +
            theme(legend.position = "top")
            
        
    })
    output$elo_dist <- renderPlot({
        elo_dist <- create_elo_data(input$v_k_1) %>% 
            filter(weight_class == input$v_weight_class_1)
        
        ggplot(data = elo_dist, aes(x = elo)) + geom_histogram()
    })
    
    output$fighter_card <- renderValueBox({
        elo <- elo.run(winner ~ fighter + opponent,
                k = input$v_k_2,
                data = elo_df)
        
        fighter_prob <- round(100*predict(elo, data.frame(fighter = input$v_fighter, opponent = input$v_opponent)),0)
        
        valueBox(
            value = paste(fighter_prob, "%", sep = ""),
            subtitle = paste(input$v_fighter, " Probability", sep = ""),
            color = "blue",
            icon = icon("hand-rock")
        )

    })
    
    output$opponent_card <- renderValueBox({
        elo <- elo.run(winner ~ fighter + opponent,
                       k = input$v_k_2,
                       data = elo_df)
        
        opponent_prob <- round(100*predict(elo, data.frame(fighter = input$v_opponent, opponent = input$v_fighter)),0)
        
        valueBox(
            value = paste(opponent_prob, "%", sep = ""),
            subtitle = paste(input$v_opponent, " Probability", sep = ""),
            color = "red",
            icon = icon("hand-rock")
        )
        
    })
    

}

shinyApp(ui = ui, server = server)

