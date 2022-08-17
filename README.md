
![Logo](https://raw.githubusercontent.com/bagheriamin/LinkShorty/main/linkShorty/Assets.xcassets/AppIcon.appiconset/120.png)


# LinkShorty

A simple link shortening app to allow users to enter their long links, and get returned short links for use.


## Technologies Used

**Tech Stack:** 
UIKit, Realm, REST API, Cocoapods

**Architecture:**
MVVM

**Swift:** Programmatic UI, Async/Await, Codable, Singleton Pattern 

**UIKIT:**
UIPasteboard, UITabBarController, UINavigationController, UITableView, UIScrollView, UIStackView, UIAlertViewController


## Demo

![Alt Text](https://raw.githubusercontent.com/bagheriamin/LinkShorty/main/Simulator%20Screen%20Recording%20-%20iPhone%2011%20-%202022-08-17%20at%2015.51.12.gif)




## API Reference

#### To send the GET Request to the API:

```http
  GET http://cutt.ly/api/api.php?key=[API_KEY]&short=[USER_LINK]
```

| Parameter | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `API_KEY` | `string` | **Required**. The API key |
| `USER_LINK` | `string` | **Required**. The users long link |





## Model Used To Decode Returned JSON

![alt text](https://github.com/bagheriamin/LinkShorty/blob/main/carbon-4.png?raw=true)
## Data Persistance

In order to save the users links, whenever a short link is generated, 
it is immedietly created and placed in the users local device storage via Realm:

![alt text](https://raw.githubusercontent.com/bagheriamin/LinkShorty/main/carbon-5.png)

Then, in my LinkHistoryViewController, I pull the data from the realm, put it in a list, and use that list to deque the UITableViewCells, as seen:

*(I would never put all classes like this in the same file, this is actually 3 files put together in one screenshot!)*
![alt text](https://github.com/bagheriamin/LinkShorty/blob/main/carbon-7.png?raw=true)
## Installation

Download the project via Code > Download as ZIP

Then cd via command line to the project and simply run the following in command line.
```bash
  pod install
```
    
