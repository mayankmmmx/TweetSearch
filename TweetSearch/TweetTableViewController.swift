//
//  TweetTableViewController.swift
//  TweetSearch
//
//  Created by Mayank Makwana on 1/1/16.
//  Copyright © 2016 Mayank Makwana. All rights reserved.
//

import UIKit
import SwifteriOS
import CoreLocation


class TweetTableViewController: UITableViewController,CLLocationManagerDelegate, UITextFieldDelegate {
    
    private let locationManager = CLLocationManager() //Manages user location
    private var currentLocation = CLLocationCoordinate2D() //Stores user location as coordinates
    private var allTweets:[Tweet] = [] //array filled with all fetched tweets
    private var searchTerm = String() //search term/phrase user has looked up
    private let swifter = Swifter(consumerKey: "fx95oKhMHYgytSBmiAqQ", consumerSecret: "0zfaijLMWMYTwVosdqFTL3k58JhRjZNxd2q0i9cltls", oauthToken: "2305278770-GGw8dQQg3o5Vqfx9xHpUgJ0CDUe3BoNmUNeWZBg", oauthTokenSecret: "iEzxeJjEPnyODVcoDYt5MVvrg90Jx2TOetGdNeol6PeYp") //Swifter object that interacts Twitter API initiated with given consumer key/secret and oath token/secret
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sets up location services to get user location
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation() //starts updating location
        }
        
        //Launches an alert box to notify user of instructions
        let alert = UIAlertController(title: "Welcome", message: "To find tweets near you, enter a search term or phrase in the search box", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allTweets.count
    }
    
    /*
        Presents tweet in each cell based on settings configured in TweetCell.swift
    */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //Sets up reusable cell as well as custom cell
        tableView.registerClass(TweetCell.self, forCellReuseIdentifier: "Cell")
        let tweetCell: TweetCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! TweetCell
        
        //Current height of cell
        var currentHeight = CGFloat()
        
        //Determiens currentHeight of cell based on if the cell has an inlineImage. This data is sent to the setAllLabels method of the tweet cell
        if(allTweets[indexPath.row].hasInlineImage())
        {
            currentHeight = 300
        }
        else
        {
            currentHeight = 150
        }
        
        //Sets all labels and images in TweetCell based on Tweet specifications
        tweetCell.setAllLabels(allTweets[indexPath.row], height: currentHeight)
    
        return tweetCell
    }
    
    /*
        Sets height of each cell based on if the tweet has an inline image
    */
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        //If there is an inline image in this specific tweet, double the normal tweet height, else leave it at the normal height
        if(allTweets[indexPath.row].hasInlineImage())
        {
            return 300
        }
        else
        {
            return 150
        }
    }

    /*
        Sets up search bar
    */
    @IBOutlet weak var searchBar: UITextField!{
        didSet{
            searchBar.delegate = self
        }
    }
    
    /*
        Gets value from search bar and sets it to searchTerm variable and executes search
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == searchBar {
            textField.resignFirstResponder()
            searchTerm = searchBar.text! //sets the search term to the searchBar value
            sendQuery() //executes search based on search term
        }
        return true
    }

    /*
        Fetches all tweets based on search specification (as JSON), parses them to Tweet objects, stores them in allTweets array, and reloads view to display tweets
    */
    func sendQuery()
    {
        let geoCode:String = currentLocation.latitude.description + "," + currentLocation.longitude.description + ",5mi" //User current coordinates as well as 5mi radius to create a geofence
        
        allTweets.removeAll() //empties allTweets array to ensure that each search has independent results
        
        //Performs fetch to get most recent tweets based on user search and user location (5mi radius of user)
        print(swifter)
        swifter.getSearchTweetsWithQuery(searchTerm, geocode: geoCode, lang: nil, locale: nil, resultType: "recent", count: 100, until: nil, sinceID: nil, maxID: nil, includeEntities: true, callback: nil, success: { (statuses, searchMetadata) -> Void in
            
            //If there are results, parse them into tweets and add to array, else display error message to retry
            if(statuses!.endIndex > 0 ) //if there are more than 0 tweets
            {
                for index in 0...statuses!.endIndex-1 //iterate through the statuses JSON
                {
                    var proPic = String() //stores profile picture URL
                    var screenName = String() //stores user screen name
                    var tweetText = String() //stores the tweet's text
                    var userLocation = String() //stores the user's location
                    var inlineImage = String() //stores an inline image URL (if exists)
                    var timeStamp = String() //stores the time stamp of the tweet
                    
                    if(statuses![index]["geo"] != nil) //ensures that the tweet has a location
                    {
                        //Parses profile picture URL and stores it
                        if let statusImage = statuses?[index]["user"]["profile_image_url"].string
                        {
                            proPic = statusImage.stringByReplacingOccurrencesOfString("_normal", withString: "", options: NSStringCompareOptions.BackwardsSearch, range: nil)
                        }
                        
                        //Parses screen name and stores it
                        if let statusName = statuses?[index]["user"]["screen_name"].string {
                            screenName = statusName;
                        }
                    
                        //Parses tweet text and stores it
                        if let statusText = statuses?[index]["text"].string {
                            tweetText = statusText
                        }
                    
                        //Parses tweet location and stores it
                        if let statusLocation =  statuses?[index]["place"]["full_name"].string {
                            userLocation = statusLocation
                        }
                        
                        //Parses tweet timestamp and stores it
                        if let statusTime =  statuses?[index]["created_at"].string {
                            timeStamp = statusTime
                        }
                    
                        //Parses inline image URL and stores it
                        if let statusInline =  statuses?[index]["entities"]["media"][0]["media_url"].string {
                            inlineImage = statusInline
                        }
                        
                        //Creates tweet object using above information
                        let temp = Tweet(authImg: proPic, name: screenName, text: tweetText, location: userLocation, inlineImg: inlineImage, time: timeStamp)
                        self.allTweets.append(temp) //adds tweet to allTweets array
                    }
                }
            }
            
            else //If there are no tweets matching the search term, alert user
            {
                //Sends an alert telling user to try again with a different term/phrase
                let alert = UIAlertController(title: "Try Again", message: "No tweets found!", preferredStyle: UIAlertControllerStyle.Alert) //creates alert with message
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)) //adds ok button
                self.presentViewController(alert, animated: true, completion: nil) //adds button to view
            }
            
            self.tableView.reloadData() //reloads table data with new tweets

        }, failure: { (error) -> Void in })
        
    }
    
    /*
        Updates location and sets coordinates of user's location to currentLocation
    */
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        currentLocation = (manager.location?.coordinate)! //sets coordinates
    }
}