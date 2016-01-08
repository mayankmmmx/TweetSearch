//
//  TweetCell.swift
//  TweetSearch
//
//  Created by Mayank Makwana on 1/2/16.
//  Copyright © 2016 Mayank Makwana. All rights reserved.
//

import UIKit


class TweetCell: UITableViewCell {
    
    //Labels
    private var screenName = UILabel()
    private var tweetText = UITextView()
    private var location = UILabel()
    private var timeStamp = UILabel()
    
    //Dimensions
    private let screenSize: CGRect = UIScreen.mainScreen().bounds
    private var tweetHeight = CGFloat()
    private var tweetWidth = CGFloat()
   
    //Image stuff
    private var profileImage: UIImageView = UIImageView()
    private var inlineImage: UIImageView = UIImageView()
    
    /*
        Default initializer for cell
    */
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //Makes the cells unselectable
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        //Profile Image Settings
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = 8
        
        //Inline Image Settings
        inlineImage.clipsToBounds = true
        inlineImage.layer.cornerRadius = 8
        
        //Sets font for screenName
        screenName.font = UIFont(name: UIFont.fontNamesForFamilyName("Helvetica")[0] , size: 14)
        
        //Sets font and textbox options for tweet
        tweetText.font = UIFont(name: UIFont.fontNamesForFamilyName("Helvetica")[1] , size: 15.5)
        tweetText.scrollEnabled = false;
        tweetText.editable = false;
        tweetText.selectable = false;
        
        //Sets font for location and timestamp
        location.font = UIFont(name: UIFont.fontNamesForFamilyName("Helvetica")[5] , size: 11)
        timeStamp.font = UIFont(name: UIFont.fontNamesForFamilyName("Helvetica")[5] , size: 10)
        
        //Adding all content to cell
        self.contentView.addSubview(profileImage)
        self.contentView.addSubview(screenName)
        self.contentView.addSubview(tweetText)
        self.contentView.addSubview(location)
        self.contentView.addSubview(timeStamp)
        self.contentView.addSubview(inlineImage)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    /*
        This function displays the tweets in each cell. If the tweet has an inline image, the image is also displayed
    */
    func setAllLabels(tweet: Tweet, height: CGFloat)
    {
        //Sets bounds for all labels/textboxes/images based on if the tweet has an inline image or not
        setAllBounds(height)

        //Sets the tweet text and image accordingly
        profileImage.image = tweet.getAuthorImage(CGSize(width: screenSize.width*0.15, height: screenSize.width*0.15))
        screenName.text = tweet.getScreenName()
        tweetText.text = tweet.getTweetText()
        location.text = tweet.getUserLocation()
        timeStamp.text = tweet.getTimeStamp()
        
        //If there is an inline image, then the inline image is set
        if(tweet.hasInlineImage())
        {
            inlineImage.image = tweet.getInlineImage(CGSize(width: screenSize.width*0.75, height: height*0.1))
        }
    }
    
    /*
        This function sets the dimensions for every element in the cell based on the height of the row.
        Ensures that the inline image can fit
    */
    func setAllBounds(rowHeight: CGFloat)
    {
        //Height and width of cell
        tweetHeight = rowHeight
        tweetWidth = screenSize.width
        
        //Sets the dimensions of every element in cell
        profileImage.frame = CGRectMake(tweetWidth*0.03, tweetHeight*0.12, tweetWidth*0.15, tweetWidth*0.15)
        screenName.frame = CGRectMake(tweetWidth*0.19,tweetHeight*0.05, tweetWidth*0.74, tweetHeight*0.2)
        tweetText.frame = CGRectMake(tweetWidth*0.18, tweetHeight*0.20, tweetWidth*0.82, tweetHeight*0.75)
        location.frame = CGRectMake(tweetWidth*0.19, tweetHeight*0.85, tweetWidth*0.81, tweetHeight*0.1)
        timeStamp.frame = CGRectMake(tweetWidth*0.93, tweetHeight*0.08, tweetWidth*0.9, tweetHeight*0.1)
        
        //If there is an inline image, then dimensions for the inline image is placed
        if(rowHeight == 300)
        {
            inlineImage.frame = CGRectMake(tweetWidth*0.19, tweetHeight*0.5, tweetWidth*0.75, tweetHeight*0.35)
        }
        
    }
}
