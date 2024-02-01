# Pet Adoption App

A mobile application which enables adoption of pets from a wide range of cats, dogs and parrots.

## Guide
- Make Sure the Device has internet while using the application (Loading may take some time as the data is being fetched from serverless function hosted on public cloud)
- Application may pose as a threat while installing but can be installed without worry
  
---
### Pages
- Home page
  - Consists of search bar, category selector and price & age Filter
  - Displays all the availble pets as per the salected categories and filters
  - Adopted pets will be grayed out and can be viewed but not available to adopt again
  - The Profile Photo Takes you to the History page
- Details page
  - Consists of Hero Image, Name, Price, Age and Gender
  - Consists of Description generated using Lorem Ipsum
  - Adopt Button is there which enbles adopting the pet and celebrations on adopting one with confetti
- History Page
  - Displays all the adopted pets in a beautiful list
  - Delete button is there to undo all adoptions (functionality is there but immediate render is changes is not there just go back to homescreen to view changes)
  - This data is stored locally on the device

---
### Features
- Data is being fetched from a flask application
- Images are hosted and feetched from a cloudinary server which are later cached for fast rendering
- Images in the Details can be tapped upon and can be zoomed in or out
- Consists of editable tags which can used to display important data in efficient way
- Search work with name to filter out the particular names from the list
- Filter aloows to choose from variety of pets according to your needs
- Application supports both light theme and dark theme baed on your devices system theme
- Background color of each pet is randomly generated for new look everytime you load the app
- Hive is uaed to store the user variables and encrypted using hive's lightwieght encryption
- Flutter Bloc is used for state management of the adoption process
- Includes testcases for both unit and widget(UI) testing
  
### Links you can checkout
- You can checkout the api which gets the json file [click here!](https://testdataadoption.vercel.app/getdata)
- Design Inspiration from [Check here!](https://www.uplabs.com/posts/pet-adoption-app-c68e812f-f5a0-4a3e-8b36-d09583fe2a8c)
  
