# Source the librarys to include
source("include.R")
# Source the functions for loading the data
source("../functions/data/dataloading.R")



################################################################################
#Load all stored data
# Loading the attribute names for the dropdown of the select input
personsDataTable <- loadPersonsDataset()
columChoicesPersonsTable <- 1:ncol(personsDataTable)
names(columChoicesPersonsTable) <- names(personsDataTable)


################################################################################
### Header:
ds_header = dashboardHeader(title = "MineR",
                            dropdownMenu(
                              type = "message",
                              messageItem(from = "WHO Breaking News:",
                                          message = "Minecraft cures ADHD.")
                            ))


################################################################################
### Sidebar:
ds_sidebar = dashboardSidebar(
  sidebarMenu(
    id = "menuTasks",
    
    ###**************************
    ### MenueItem 1: Project Introduction
    ###**************************
    menuItem(
      "Project Introduction",
      tabName = "introduction",
      icon = icon("th")
    ),
    ###**************************
    ### MenueItem 2: Experiment Overview
    ###**************************
    menuItem(
      "The Experiment",
      tabName = "experiment",
      icon = icon("flask")
    ),
    ###**************************
    ### MenueItem 3: Dataset
    ###**************************
    menuItem(
      "The Dataset",
      tabName = "rawData",
      icon = icon("database")
    ),
    
    ###**************************
    ### MenueItem 4: Memorizing Experiment
    ###**************************
    menuItem(
      "Memorizing Experiment",
      tabName = "memorizing",
      icon = icon("brain")
    ),
    ###**************************
    ### MenueItem 5: Trajectory feature exploration
    ###**************************
    menuItem(
      "Trajectory feature exploration",
      tabName = "trjFeatures",
      icon = icon("rocket")
    ),
    ###**************************
    ### MenueItem 6: Clustering
    ###**************************
    menuItem(
      "Clustering",
      tabName = "clustering",
      icon = icon("chart-pie")
    )
  )
)

################################################################################
### Dashboard Content:
ds_body = dashboardBody(tabItems(
  ###****************************************************************************************************************************************************************
  ### Page 1: Indroduction: webiste screencast, project description
  ###****************************************************************************************************************************************************************
  tabItem(
    tabName = "introduction",
    h1("Project Introduction"),
    #======================================
    # Page 1: fluidRow 1: Project Description
    #======================================
    fluidRow(
      box(
        width = 12,
        "This webpage is the result of the semester project of the course",
        tags$b("Data Science with R"),
        "held in the winter semester 2018/2019 at the computer science faculty at the Otto-von-Guericke university Magdeburg by M.Sc. Uli Niemann from the",
        tags$a(href = "http://www.kmd.ovgu.de", "KMD Lab",target="_blank"),
        ". Further details regarding the lecture can be found on the official",
        tags$a(href = "https://kmd.cs.ovgu.de/teaching/DataSciR/index.html", "course website",target="_blank"),
        ".",
        "This project was done as a team consisting of the members",
        tags$b("Johannes Dambacher"),
        "and",
        tags$b("Alexander Wagner"),
        ".",
        "The general project idea as well as an detailed time plan can be found in the " ,
        tags$a(href = "https://drive.google.com/file/d/14JyjdShlHViJ199tRS3etAleqFE1tPem/view?usp=sharing", "project proposal",target="_blank"),
        ".",
        "The basic idea of the course was to choose a dataset and to to gain new insights using the language R. We have decided to use a dataset from the ",
        tags$a(
          href = " http://www.kkjp.ovgu.de/Forschung.html",
          "Universitätsklinik für Psychiatrie, Psychotherapie und Psychosomatische Medizin des Kindes- und Jugendalters (KKJP)",target="_blank"
        ),
        "at the medical faculty of the university of Magdeburg. Further information regarding the process how the dataset was generated can be found in the experiment tab. The dataset itself can be explored in the dataset tab.",
        
        "The whole code for this project is stored in this",
        tags$a(href = "https://gitlab.com/vornamenachname/datascience_r", "GitLab Repository",target="_blank"),
        ".",
        "All visualizations as well as the generating code can also be viewed in this R Markdown document.",
        "If you want to get a short introduction for this application, please see the video below.",
        tags$br(),
        tags$br()
      )
    ),
    #======================================
    # Page 1: fluidRow 2: Screencast
    #======================================
    fluidRow(
      tags$video(
        id = "video2",
        type = "video/mp4",
        src = "VR1.0.mp4",
        controls = "controls",
        width = '920',
        height = '540',
        style = "display: block; margin-left: auto; margin-right: auto;"
        
      )
    ),
    tags$br(),
    tags$br(),
    #======================================
    # Page 1: fluidRow 3: Icons
    #======================================
    fluidRow(
      width = 12,
      column(
        width = 4,
        tags$img(
          src = 'datascir.png',
          width = '78',
          height = '91',
          align = "center",
          style = "display: block; margin-left: auto; margin-right: auto;"
        )
      ),
      column(
        width = 4,
        tags$img(src = 'fin_transp.png', align = "center", style =
                   "display: block; margin-left: auto; margin-right: auto;")
      ),
      column(
        width = 4,
        tags$img(src = 'medlogo_transp.png', align = "center", style =
                   "display: block; margin-left: auto; margin-right: auto;")
      )
    )
  ),
  ###****************************************************************************************************************************************************************
  ### Page 2: Raw Data Overview; table, scatterplots,
  ###****************************************************************************************************************************************************************
  tabItem(
    tabName = "rawData",
    h1("The dataset"),
    #======================================
    # Page 2: fluidRow 1: Important data figures overview
    #======================================
    fluidRow(
      box(
        title = 'Key Figures',
        width = 12,
        collapsible = 12,
        fluidRow(
          valueBoxOutput('personFiles'),
          valueBoxOutput('personAttributes'),
          valueBoxOutput('personInstances')
          
        ),
        #======================================
        # Page 2: fluidRow 2: Important data figures overview
        #======================================
        fluidRow(
          valueBoxOutput('trajectoryFiles'),
          valueBoxOutput('trajectoryAttributes'),
          valueBoxOutput('trajectoryInstances')
        )
      )
    ),
    #======================================
    # Page 2: fluidRow 3: Description about the dataset
    #======================================
    fluidRow(
      width = 12,
      box(
        title = "Description",
        width = 12,
        collapsible = TRUE,
        collapsed = TRUE,
        
        "The overall recorded data set consists of the trajectory data of 66 test persons in the virtual world as well as several other variables such as sex, age and others.
        The data set is divided into trajectory data (in the following named",
        tags$em("Trajectory data"),
        ") and information of the test persons (in the following named",
        tags$em("Test subject data"),
        ") in separate csv files.",
        
        "The trajectory data was retrieved by tracking the test persons movement within a 3D virtual Minecraft world.
        The sample rate was set to a tenth of a second. The data contains a time stamp and the x,y and z coordinate of the test persons avatar in the virtual world at a given time.
        Due to the software based digital tracking within a virtual world the sample points contain an exact time stamp and neither noise, nor outlier nor ambiguities or other measurement based bias.
        The time spent in the virtual world should range from 10 to 20 minutes where the test persons could freely stop exploring the world after 10 minutes.
        The data set of the test persons contains variables such as sex, age and others as well as the number of words remembered correctly/wrongly on the first/second day,
        the virtual world id for day one/two and several scores obtained using a questionnaire related to immersion, exploration behavior and similar.
        The full list of attributes of the used data sets are listed below.",
        
        tags$br(),
        tags$br(),
        "In summary:",
        tags$br(),
        tags$b("Test subject data:"),
        tags$ul(
          tags$li("1 csv file"),
          tags$li("63 instances"),
          tags$li("31 attributes")
        ),
        tags$b("Trajectory data:"),
        tags$ul(
          tags$li("130 csv files"),
          tags$li("~7000 instances each"),
          tags$li("4 attributes")
        ),
        
        "In the following tables you can get an insight into the dataset.",
        tags$br()
        )
      ),
    
    
    #======================================
    # Page 2: fluidRow 4: Person data overview
    #======================================
    fluidRow(
      width = 12,
      tabBox(
        title = "Test persons data",
        side = "right",
        width = 12,
        selected = "Raw Data",
        tabPanel(
          "Raw Data",
          width = 12,
          pickerInput(
            inputId = "id_pickerInputDTpersonsRaw1",
            label = "Select columns to display:",
            choices = columChoicesPersonsTable[-1],
            options = list(
              `actions-box` = TRUE,
              size = 10,
              `selected-text-format` = "count > 3"
            ),
            multiple = TRUE,
            selected = columChoicesPersonsTable[2:7]
          ),
          DT::dataTableOutput("gx_DT_personsDataTable")
        ),
        tabPanel(
          "Scatterplot matrix",
          h2(width = 12, "Test persons data as scatterplot matrix"),
          width = 12,
          pickerInput(
            inputId = "id_pickerInputDTpersonsRaw2",
            label = "Select columns to display:",
            choices = columChoicesPersonsTable[-1],
            options = list(
              `actions-box` = TRUE,
              size = 10,
              `selected-text-format` = "count > 3"
            ),
            multiple = TRUE,
            selected = columChoicesPersonsTable[2:7]
          ),
          plotlyOutput("gx_splom_personsDataTable")
        ),
        tabPanel(
          "Correlation",
          h2(width = 12, "Correlation of attributes"),
          width = 12,
          pickerInput(
            inputId = "id_pickerInputRegression",
            label = "Select columns to display:",
            choices = columChoicesPersonsTable[-1],
            multiple = TRUE,
            options = pickerOptions(
              maxOptions = 2
            ),
            selected = columChoicesPersonsTable[2:3]
          ),
          plotlyOutput("gx_regression")
        )
      )
    ),
    #======================================
    # Page 2: fluidRow 5: Trajectory data overview
    #======================================
    fluidRow(
      width = 12,
      box(
        title = "Trajectory and room data",
        width = 12,
        collapsible = T,
        tabBox(
          title = "First Day",
          side = "right",
          selected = "Trajectory",
          tabPanel(
            "Rooms entered",
            "Times room entered",
            plotlyOutput("gx_roomEntriesBarDayOne")
          ),
          tabPanel(
            "Time per room",
            "Time spent per room",
            plotlyOutput("gx_roomHistBarDayOne")
          ),
          tabPanel(
            "Trajectory",
            dropdownButton(
              tags$h3("List of Input"),
              sliderInput(
                "colorInput",
                "Select time intervall",
                min = 0,
                max = 100,
                value = c(0, 100)
              ),
              sliderInput(
                "z_level",
                "Select z intervall for plotting",
                min = -6,
                max = 35,
                value = c(-6, 35)
              ),
              checkboxInput("showRoomInput", "Show rooms", value = FALSE),
              circle = TRUE,
              status = "primary",
              icon = icon("gear"),
              width = "300px",
              tooltip = tooltipOptions(title = "Click to see inputs !")
            ),
            plotlyOutput("gx_3d_trajectoryDayOne")
            
          )
        ),
        tabBox(
          title = "Second Day",
          side = "right",
          selected = "Trajectory",
          tabPanel(
            "Rooms entered",
            "Times room entered",
            plotlyOutput("gx_roomEntriesBarDayTwo")
          ),
          tabPanel(
            "Time per room",
            "Time spent per room",
            plotlyOutput("gx_roomHistBarDayTwo")
          ),
          tabPanel(
            "Trajectory",
            plotlyOutput("gx_3d_trajectoryDayTwo"),
            verbatimTextOutput("value")
          )
        )
      )
    ),
          fluidRow(
            box(
              title = 'World summarys',
              width = 12,
              collapsible = T,
              collapsed = T,
              fluidRow(
                box(title = "Mansion",
                    status = "primary",
                    plotlyOutput('boxplotWorldOne')),
                box(title = "Mansion altered",
                    status = "primary",
                    plotlyOutput('boxplotWorldTwo')),
                box(title = "Pirate ship",
                    status = "primary",
                    plotlyOutput('boxplotWorldThree')))))
                       
  ),
  
  
  ###****************************************************************************************************************************************************************
  ### Page 3: Experiment description and videos of the different Minecraft worlds
  ###****************************************************************************************************************************************************************
  tabItem(
    tabName = "experiment",
    h1("Experiment Overview"),
    #======================================
    # Page 3: fluidRow 1: Experiment description
    #======================================
    fluidRow(
      width = 12,
      box(
        width = 12,
        title = "Data generation process",
        solidHeader = F,
        collapsible = F,
        column(
          width = 6,
          "The data was recorded during a study on the impact of exploring novelty onto the learning success of children. The study group consisted of children having different types of ADHD and an control group.
          For the experiment both groups (with ADHD and the control group) had to attend the study on three different days:",
          tags$br(),
          tags$b("On the first day"),
          "the test persons got familiarized with the virtual world by spending between 10 and 20 minutes exploring one of the two worlds (see the worlds in the videos below).
          ",
          tags$br(),
          tags$b("On the second day"),
          " the test persons had to learn",
          tags$em("20 new vocabularies"),
          "and recall them afterwards. After the recalling the test persons had again the task to explore a virtual world for 10 to 20 minutes. The virtual world on day one and day two were the same for some test persons and different for others.",
          tags$br(),
          tags$b("On the third day"),
          "the vocabularies had to be recalled again by the test persons (see the process overview in the image on the right). Further test persons will perform the experiment in the future and thus enlarge the data set successively."
        ),
        column(
          width = 6,
          align = "center",
          img(src = "process.png", width = 400)
        )
      )
    ),
    #======================================
    # Page 3: fluidRow 2: Videos of the Minecraft worlds
    #======================================
    fluidRow(
      height = 500,
      tabBox(
        title = "Minecraft World´s",
        height = "auto",
        width = 12,
        side = 'right',
        tabPanel(
          "The Mansion",
          tags$video(
            id = "video1",
            type = "video/mp4",
            src = "VR1.0.mp4",
            controls = "controls",
            width = '920',
            height = '540',
            style = "display: block; margin-left: auto; margin-right: auto;"
          )
        ),
        tabPanel(
          "The Mansion (altered)",
          tags$video(
            id = "video2",
            type = "video/mp4",
            src = "VR1.1.mp4",
            controls = "controls",
            width = '920',
            height = '540',
            style = "display: block; margin-left: auto; margin-right: auto;"
          )
        ),
        tabPanel(
          "The pirate island",
          tags$video(
            id = "video3",
            type = "video/mp4",
            src = "VR2.0.mp4",
            controls = "controls",
            width = '920',
            height = '540',
            style = "display: block; margin-left: auto; margin-right: auto;"
          )
        )
      )
      
    )
    
  ),
  
  
  ###****************************************************************************************************************************************************************
  ### Page 4: Results of the memorizing experiment
  ###****************************************************************************************************************************************************************
  tabItem(
    tabName = "memorizing",
    h1("Memorizing Experiment"),
    #======================================
    # Page 4: fluidRow 1: Important figures
    #======================================
    fluidRow(
      title = ' Results',
      width = 12,
      box(
        title = 'Key figures' ,
        width = 12,
        collapsible = T,
        fluidRow(
          title = 'Experiment information',
          width = 12,
          valueBoxOutput('wordsValueBox'),
          valueBoxOutput('avgDirectRecallBox'),
          valueBoxOutput('avgDelayedRecallBox')
        )
        ,
        fluidRow(
          title = 'Distribution of persons with respect to the different worlds',
          width = 12,
          valueBoxOutput('sameWorldBox'),
          valueBoxOutput('newWorldBox'),
          valueBoxOutput('partialNewWorldBox')
        ),
        fluidRow(
          title = ' Distribution of ADHD Type with respect to the different worlds',
          width = 12,
          box(
            title = 'ADHD distribution among groups',
            width = 12,
            collapsible = T,
            collapsed = T,
            fluidRow(
              width = 12,
              column(width = 4,
                     plotlyOutput('sameWorldBar')),
              column(width = 4,
                     plotlyOutput('newWorldBar')),
              column(width = 4,
                     plotlyOutput('partialNewWorldBar'))
            )
          )
        )
      )
    ),
    #======================================
    # Page 4: fluidRow 2: Description of the following plots
    #======================================
    fluidRow(
      box(
        title = 'Description',
        width = 12,
        collapsible = T,
        collapsed = T,
        'The above',
        tags$b('Key figures'),
        'show in the first row important information regarding the conducted memorizing experiment that is also described in the Experiment tab.',
        'The persons had to memorize and remember 20 words directly and also after a certain time period. The average remebered words are represented by the',
        tags$em('Average Direct Recall'),
        'box, while the average results of the delayed test are shown in the',
        tags$em('Average Delayed Recall'),
        'box.',
        'The boxes in the second row of the tab show the distribution of the visited worlds.',
        'The bar charts below further detail the distribution of ADHD types among the different experiment groups (Same world, New world, Partial new world).',
        tags$br(),
        'In the four box plots below the direct and delayed recall of the memorized words is visualized with respect to ADHD type in the different experiment groups.'
      )
    ),
    #======================================
    # Page 4: fluidRow 3: Boxplots showing the short term and long term memory results
    #======================================
    fluidRow(
      box(
        title = 'Long and short term memory recall comparison',
        width = 12,
        collapsible = T,
        fluidRow(
          box(
            title = "Overall",
            status = "primary",
            plotlyOutput("boxplotOverall")
            
          ),
          box(
            title = "Partial New World",
            status = "primary",
            plotlyOutput("boxplotPartialNewWorld")
          ),
          fluidRow(
            box(
              title = "New World",
              status = "primary",
              plotlyOutput("boxplotNewWorld")
            ),
            box(
              title = "Same World",
              status = "primary",
              plotlyOutput("boxplotSameWorld")
            )
          )
          
        )
      )
    )
  ),
  
  ###****************************************************************************************************************************************************************
  ### Page 5: Trajectroy features
  ###****************************************************************************************************************************************************************
  tabItem(
    tabName = "trjFeatures",
    h1("Trajectory feature exploration"),
    fluidRow(
      width = 12,
      title = '',
      box(
        width = 12,
        title = 'Direction of Movement',
        collapsible = T
      ),
      box(
        width = 12,
        title = 'Average time per room',
        collapsible = T
      ),
      box(
        width = 12,
        title = 'Percentage of rooms visited',
        collapsible = T
      ),
      box(
        width = 12,
        title = 'Rooms visited multiple times',
        collapsible = T
      ),
      box(
        width = 12,
        title = 'Overall time spent in the world',
        collapsible = T
      )
    )
  ),
  ###****************************************************************************************************************************************************************
  ### Page 6: Clustering plus visualization
  ###****************************************************************************************************************************************************************
  tabItem(tabName = "clustering",
          h1("Clustering"),
          fluidRow(
            title = 'clustering',
            width = 12,
            box(
              title = 'Description',
              width = 12,
              collapsible = T
            )
          ,
            box(
              title = 'Clustering results',
              width = 12,
              collapsible = T
            ),
          box(
            title = 'Clustering analysis',
            width = 12,
            collapsible = T
          ))
)))

################################################################################
### DashboardPage: (must be last)
dashboardPage(ds_header, ds_sidebar, ds_body)
