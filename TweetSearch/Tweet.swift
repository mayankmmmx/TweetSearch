//
//  Tweet.swift
//  TweetSearch
//
//  Created by Mayank Makwana on 1/1/16.
//  Copyright © 2016 Mayank Makwana. All rights reserved.
//

import UIKit

/*
    Tweet class stores Tweet information that will need to be displayed in table
*/
class Tweet
{
    //Creates and initalizes all Tweet information
    private var authorImage:String = ""
    private var screenName:String = ""
    private var tweetText:String = ""
    private var userLocation:String = ""
    private var inlineImage:String = ""
    private var timeStamp:String = ""
    
    /*
        Initializes new tweet and updates information based on fetched tweet data
    */
    init(authImg: String, name: String, text:String, location:String, inlineImg: String, time:String)
    {
        //initializes all
        self.authorImage = authImg
        self.screenName = name
        self.tweetText = text
        self.userLocation = location
        self.inlineImage = inlineImg
        self.timeStamp = time
    }
    
    /*
        Returns the profile picture as an image based on specified size of image
        Converts URL to image and returns it
    */
    func getAuthorImage(size: CGSize)->UIImage
    {
        return getImageFromURL(authorImage, size: size)
    }
    
    /*
        Returns the screen name
    */
    func getScreenName()->String
    {
        return screenName
    }
    
    /*
        Returns the tweet text
    */
    func getTweetText()->String
    {
        return tweetText
    }
    
    /*
        Returns the location
    */
    func getUserLocation()->String
    {
        return userLocation
    }
    
    /*
        Returns the inline image (if it exists) as an image based on specified size of image
        Converts URL to image and returns it
    */
    func getInlineImage(size: CGSize)->UIImage
    {
        return getImageFromURL(inlineImage, size: size)
    }
    
    /*
        Returns relative stamp of tweet using tweet's posting data
    */
    func getTimeStamp()->String
    {
        return convertToRelativeTime(timeStamp)
    }
    
    /*
        Returns true if the tweet has an inline image and false if it doesn't
    */
    func hasInlineImage()->Bool
    {
        if(inlineImage != "") //checks if inlineImage URL has a url, if it doesnt, return true
        {
            return true
        }
        
        return false
    }
    
    /*
        Uses image URL and specified size, to return an UIImage
    */
    func getImageFromURL(url: String, size:CGSize)->UIImage
    {
        var image = UIImage() //initializes new image
        
        //gets image with url, resizes it, and sets it to image object
        if let imageData = NSData(contentsOfURL: NSURL(string: url)!){ //block main thread!!!
            image = imageResize(UIImage(data: imageData)!, sizeChange: size) //gets image based on url and resizes it according to specification
        }
        return image
    }
    
    /*
        This function resizes images to ensure that image does not look wierdly warped
    */
    func imageResize (imageObj:UIImage, sizeChange:CGSize)-> UIImage
    {
        
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        imageObj.drawInRect(CGRect(origin: CGPointZero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
    }
    
    /*
        Takes in a date and determines relative time based on current time and returns relative time as a string
    */
    func convertToRelativeTime(date: String)->String
    {
        //Date formatter used to parse tweet data
        let df = NSDateFormatter()
        df.formatterBehavior = NSDateFormatterBehavior.Behavior10_4
        df.dateFormat = "EEE MMM dd HH:mm:ss VVVV yyyy" //tweet date format as specified by Twitter Search API
        
        //Initializes the date of tweet and the date of current day
        let tweetDate = df.dateFromString(date)
        let todayDate = NSDate()
        
        //determines time interval in seconds based on current date and tweet date
        var timeInterval = (tweetDate?.timeIntervalSinceDate(todayDate))!
        timeInterval *= -1 //makes sure it is a positive value
        
        if(timeInterval < 60) //if less than a minute
        {
            return Int(timeInterval).description + "s" //returns seconds
        }
        else if (timeInterval < 3600) // if less than an hour
        {
            let diff = Int(round(timeInterval / 60)) //converts timeInterval to minutes
            
            return diff.description + "m" //returns minutes
        }
        else if (timeInterval < 86400) // if less than a day
        {
            let diff = Int(round(timeInterval / 60 / 60)) //converts timeInterval to hours
            return diff.description + "hr" //returns hours
        }
        else if (timeInterval < 2629743) //if less than a month
        {
            let diff = Int(round(timeInterval / 60 / 60 / 24)) //converts timeInterval to days
            return diff.description + "d" //returns days
        }
        else if (timeInterval < 31536000) //if less than a year
        {
            let diff = Int(round(timeInterval / 60 / 60 / 24 / 30)) //converts timeInterval to months
            return diff.description + "mon" //returns months
            
        }
        else //if more than a year
        {
            let diff = Int(round(timeInterval / 60 / 60 / 24 / 365)) //converts time interval to years
            return diff.description + "yr" //returns yrs 
        }
    }

}


