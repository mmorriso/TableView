//
//  DetailViewController.h
//  TableView
//
//  Created by Marcus Morrison on 14/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DetailViewController : UIViewController {
    IBOutlet UILabel *lblText;
    NSString *selectedCountry;
}

@property (nonatomic, retain) NSString *selectedCountry;

@end
