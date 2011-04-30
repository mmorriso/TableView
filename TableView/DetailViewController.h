//
//  DetailViewController.h
//  TableView
//
//  Created by Marcus Morrison on 14/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DetailViewController : UIViewController {
    // GUI elements
    IBOutlet UILabel                    *lblText;
    IBOutlet UILabel                    *lblLoad;
    IBOutlet UILabel                    *lblPopulation;
    IBOutlet UILabel                    *lblCapital;
    IBOutlet UIActivityIndicatorView    *activityIndicator;
    NSString                            *selectedCountry;
    // Web service elements
    NSMutableData   *serviceData;
    NSMutableString *serviceResults;
    NSURLConnection *serviceConnection;
    //XML parser elements
    NSXMLParser *xmlParser;
    BOOL elementFound;
}

@property (nonatomic, retain) NSString                  *selectedCountry;
@property (nonatomic, retain) UIActivityIndicatorView   *activityIndicator;
@property (nonatomic, retain) UILabel                   *lblLoad;
@property (nonatomic, retain) UILabel                   *lblPopulation;
@property (nonatomic, retain) UILabel                   *lblCapital;

- (IBAction)buttonClicked:(id)sender;

@end
