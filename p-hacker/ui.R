library(shiny)
library(shinythemes)
library(shinyBS) # Additional Bootstrap Controls

shinyUI(fluidPage(theme = shinytheme("spacelab"),
	tags$head(tags$link(rel="stylesheet", type="text/css", href="accordion.css")),	
	
	title = "p-hacker: Train your p-hacking skills!",
	
	titlePanel("p-hacker: Train your p-hacking skills!"),
	
	div(class="row", 
	    HTML(readFile("snippets/quick_start.html")), 
		HTML(readFile("snippets/tech_details.html")), 
	    HTML(readFile("snippets/about.html"))
	),	
	
	# ---------------------------------------------------------------------
	# The actual app ...
	
	fluidRow(
		column(width=4,
			tabsetPanel(id ="tabs1",				
				tabPanel("New study",	
					h3("Settings for initial data collection:"),			
					textInput("label_group1", "Name for experimental group", "Elderly priming"),
					textInput("label_group2", "Name for control group", "Control priming"),
					sliderInput("n_per_group", "Initial # of participants in each group", min=2, max=100, value=20, step=1),
					sliderInput("true_effect", "True effect (Cohen's d)", min=0, max=1.5, value=0, step=0.05),
					sliderInput("dv_n", "Number of DVs", min=2, max=10, value=4, step=1),					
					actionButton('generateNewData','Run new experiment'),
					p("(Discards previous data)"),
					br(),br(),
					HTML("<div style='color:#BBBBBB; font-size:70%'>"),
					popify(textInput("seed", "Use seed (automatically incremented)", ''), "Hint", "Used to generate random values. Same seed leads to same values!", placement="top"),
					htmlOutput("seed_form"),
					htmlOutput("error_msg"),
					HTML("</div>")
				),
				tabPanel("Now: p-hack!", class="disabled",
					h3("Basic tools to improve your p-value:"),
					checkboxInput("cov_age", "Control for age", FALSE),
					checkboxInput("cov_gender", "Control for gender", FALSE),
					checkboxInput("cov_gender_IA", "Interaction with gender", FALSE),
		      	  	div(class="btn-group-vertical",
					  actionButton('add5','Add 5 new participants'),
					  actionButton('add10','Add 10 new participants')
		      		)
				),
				tabPanel("Expert feature: Subgroup analysis", class="disabled",
					h3("Unlock the expert feature: Subgroup analysis!"),
					checkboxInput("subgroups", "Do an expert subgroup analysis", FALSE)
				)
			)
		),		
		
		
		# --------------------------------------------------------------------
		# The output panels, on the right side
		
		column(width=5, 
			conditionalPanel(
				condition = "input.tabs1 == 'New study' | input.tabs1 == 'Now: p-hack!'",					
				htmlOutput("testoverview"),
				htmlOutput("plotoverview"),
				plotOutput("mainplot", 
				  click="mainplot_clicked"           
				  ),
				htmlOutput("plothints")
			),
			conditionalPanel(
				condition = "input.tabs1 == 'Expert feature: Subgroup analysis'",
				HTML("<h3>Subgroup analysis: Age groups by gender</h3>"),
				conditionalPanel(
					condition = "input.subgroups == 1",
					htmlOutput("subgroupOutput")
				)
			)
		),
		
		column(width=3,			
			htmlOutput("studystack")
		)
	)	
))
