# PsychologyApp-BingeEating

##Web Application ( -Sumeesh Nagisetty)

All the pages in the web app are built based on Bootstrap. All the different pages are

  - Login Page
  - Dashboard
  - Add Participant Page
  - Participant Detail Page ( graphs built using HighCharts Framework - http://www.highcharts.com/)
  - Appointment/Calendar Page (built using FullCalendar framework - https://fullcalendar.io/)
  - Add Supporter Page
  - Notes Page (built using summernote framework - http://summernote.org/)
  
###Login Page -

  Simple login page using basic bootstrap format to login the supporter/admin.
  
  Given the login details, the application will internally evaluate the details whether the details belong to admin / supporter and moves to respective dashboard page.
  
  ![Alt text](/Screens/login.png?raw=true "Login Page")
  
###Dashboard Page -

  Dashboard page for the supporter are restricted to adding/remove participant, viewing participant details, making appointments with the participant, sending notes to the participant(s).
  For Admin, adding/removing the supporter is one additional feature which is not given to the supporter.
  
  ![Alt text](/Screens/dashboard1.png?raw=true "Dashboard Page")
  
####Functionalities in this Page
  - Participant Table: All the participant for the particular supporter are present in the table(Obtained through JSON data). This is provided with Search(filter) and Sort(orderBy) features to quick identification of the participant.

  ![Alt text](/Screens/dashboard2.png?raw=true "Dashboard Page")

  - Remove Participant: Remove button in provided within the page so that the participant is removed from the supporter list ( used ng-click to remove the participant without refreshing - single page app). function is used in controller to remove the row in real-time from the view.
  
  ![Alt text](/Screens/removeUser.png?raw=true "remove user")
  
  - Send Notification: Supporter can broadcast/send a short message to the participant which will appear as mobile app notification to the participant. This is enabled using modals. Only the notification enabled participant cna access this feature.
  
  ![Alt text](/Screens/dashboardModal.png?raw=true "remove user")
  
###Add Participant/Supporter Page - 
  
  This is simple form page to collect the participan/Supportert details and post it to the database.
  
###Participant Detail Page - 

  This page show the progress and other details of the participant to the supporter.
  
####Functionalities in this Page
  - Graph - This graph represents the binges, good days of the participant in a week period. These graphs are built with help of HighCharts framework.
  - Advancing Step Meter - This meter helps the supporter to promote/demote the participant to higher/lower level respectively. This whole progress bar is built using angular-template for easy access in the html section.
  - Information Table - All the details in the table are obtained in form JSON. (ejs file can access the data which is send while call the page)
  
  ![Alt text](/Screens/userScreen.png?raw=true "Participant Screen")
  
###Appointment/Calendar Page - 

  This page is built using the FullCalendar Framework, which allow us to create events and sent the details in JSON form, and adding event from JSON data.
  
####Functionalities in this Page
- Getting Appointment Details - JSON data can be used to display event in the calendar

  ![Alt text](/Screens/Calendar.png?raw=true "Calendar")

- Creating an Appointment - By Clicking the space where you want to create an appointment will by default create an hour meeting event.
- Deleting an Appointment - By clcking 'x' on the rignt-bottom corner of the event will delete the event completely from the database and a new view is rendered.

  ![Alt text](/Screens/removeEvent.png?raw=true "remove event")
  
- Modifying an Appointment - Dragging and drop works to change the event from space to another, or drag the bottom end of the event will give you access to modify the duration of the event.

  ![Alt text](/Screens/changeEvent.png?raw=true "Modify Event")

- Adding Notes for Appointment - By clicking on the event will open up a modal. This modal is text editor, where I used summernote framework to add notes. Summernote will allow us to save the notes in hypertext format which will allow us to save all the beautification(style,colors,size,images, etc.).

  ![Alt text](/Screens/notes.png?raw=true "Notes")


###Framework/Technolgies/Packages used -

  - Angular JS
  - EJS
  - HTML
  - CSS
  - Javascript
  - FullCalendar
  - SummerNote
  - Font Awesome (for all the beautiful icons used in the app)
  - Node JS (back-end stuff - getting and posting data and accessing database).
