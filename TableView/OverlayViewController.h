//
//  OverlayViewController.h
//  TableView
//
//  Created by Marcus Morrison on 15/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface OverlayViewController : UIViewController {
    RootViewController *rvController;
}

@property (nonatomic, retain) RootViewController *rvController;

@end
