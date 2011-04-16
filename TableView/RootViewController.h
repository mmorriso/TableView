//
//  RootViewController.h
//  TableView
//
//  Created by Marcus Morrison on 14/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OverlayViewController;

@interface RootViewController : UITableViewController {
    NSMutableArray *listOfItems;
    NSMutableArray *copyListOfItems;
    OverlayViewController *ovController;
    IBOutlet UISearchBar *searchBar;
    BOOL searching;
    BOOL letUserSelectRow;
}

- (void) searchTableView;
- (void) doneSearching_Clicked:(id)sender;

@end
