//
//  RootViewController.m
//  TableView
//
//  Created by Marcus Morrison on 14/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "DetailViewController.h"
#import "OverlayViewController.h"

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Initialize the array.
    listOfItems = [[NSMutableArray alloc] init];
    
    NSArray *countriesToLiveInArray = [NSArray arrayWithObjects:@"Greece", @"Greenland", @"Iceland", @"Ireland", @"Italy", @"New Zealand", @"Norway", @"Switzerland", nil];
    NSDictionary *countriesToLiveInDict = [NSDictionary dictionaryWithObject:countriesToLiveInArray forKey:@"Countries"];
    
    NSArray *countriesLivedInArray = [NSArray arrayWithObjects:@"India", @"United States", nil];
    NSDictionary *countriesLivedInDict = [NSDictionary dictionaryWithObject:countriesLivedInArray forKey:@"Countries"];
    
    [listOfItems addObject:countriesToLiveInDict];
    [listOfItems addObject:countriesLivedInDict];
    
    //Initialize the copy array.
    copyListOfItems = [[NSMutableArray alloc] init];
    
    //Set the title
    self.navigationItem.title = @"Countries";
    
    //Add the search bar
    self.tableView.tableHeaderView = searchBar;
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    
    searching = NO;
    letUserSelectRow = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
    //Add the overlay view.
    if(ovController == nil)
        ovController = [[OverlayViewController alloc] initWithNibName:@"OverlayViewController" bundle:[NSBundle mainBundle]];
    
    CGFloat yaxis = self.navigationController.navigationBar.frame.size.height;
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    //Parameters x = origion on x-axis, y = origon on y-axis.
    CGRect frame = CGRectMake(0, yaxis, width, height);
    ovController.view.frame = frame;
    ovController.view.backgroundColor = [UIColor grayColor];
    ovController.view.alpha = 0.5;
    
    ovController.rvController = self;
    
    [self.tableView insertSubview:ovController.view aboveSubview:self.parentViewController.view];
    
    searching = YES;
    letUserSelectRow = NO;
    self.tableView.scrollEnabled = NO;
    
    //Add the done button.
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                               target:self action:@selector(doneSearching_Clicked:)] autorelease];
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
    
    //Remove all objects first.
    [copyListOfItems removeAllObjects];
    
    if([searchText length] > 0) {
        
        [ovController.view removeFromSuperview];
        searching = YES;
        letUserSelectRow = YES;
        self.tableView.scrollEnabled = YES;
        [self searchTableView];
    }
    else {
        
        [self.tableView insertSubview:ovController.view aboveSubview:self.parentViewController.view];
        
        searching = NO;
        letUserSelectRow = NO;
        self.tableView.scrollEnabled = NO;
    }
    
    [self.tableView reloadData];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {

    [self searchTableView];
}

- (void) searchTableView {
    
    NSString *searchText = searchBar.text;
    NSMutableArray *searchArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dictionary in listOfItems)
    {
        NSArray *array = [dictionary objectForKey:@"Countries"];
        [searchArray addObjectsFromArray:array];
    }
    
    for (NSString *sTemp in searchArray)
    {
        NSRange titleResultsRange = [sTemp rangeOfString:searchText options:NSCaseInsensitiveSearch];
        
        if (titleResultsRange.length > 0)
            [copyListOfItems addObject:sTemp];
    }
    
    [searchArray release];
    searchArray = nil;
}

- (void) doneSearching_Clicked:(id)sender {
    
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    
    letUserSelectRow = YES;
    searching = NO;
    self.navigationItem.rightBarButtonItem = nil;
    self.tableView.scrollEnabled = YES;
    
    [ovController.view removeFromSuperview];
    [ovController release];
    ovController = nil;
    
    [self.tableView reloadData];
}

- (NSIndexPath *)tableView :(UITableView *)theTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(letUserSelectRow)
        return indexPath;
    else
        return nil;
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (searching)
        return 1;
    else
        return [listOfItems count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (searching)
        return [copyListOfItems count];
    else {
        
        //Number of rows it should expect should be based on the section
        NSDictionary *dictionary = [listOfItems objectAtIndex:section];
        NSArray *array = [dictionary objectForKey:@"Countries"];
        return [array count];
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
    
    if(searching) {
        cell.textLabel.text = [copyListOfItems objectAtIndex:indexPath.row];
    } else {
        
        //First get the dictionary object
        NSDictionary *dictionary = [listOfItems objectAtIndex:indexPath.section];
        NSArray *array = [dictionary objectForKey:@"Countries"];
        NSString *cellValue = [array objectAtIndex:indexPath.row];
        cell.textLabel.text = cellValue;
        
        //Concatenate image path from cell label value and file extension
        NSString *cellImage = [cellValue stringByAppendingString:@".png"];
        
        //Assign cell image 
        cell.imageView.image = [UIImage imageNamed:cellImage];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    return cell;        
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Get the selected country
    
    NSString *selectedCountry = nil;
    
    if(searching)
        selectedCountry = [copyListOfItems objectAtIndex:indexPath.row];
    else {
        
        NSDictionary *dictionary = [listOfItems objectAtIndex:indexPath.section];
        NSArray *array = [dictionary objectForKey:@"Countries"];
        selectedCountry = [array objectAtIndex:indexPath.row];
    }
    
    //Initialize the detail view controller and display it.
    DetailViewController *dvController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:[NSBundle mainBundle]];
    dvController.selectedCountry = selectedCountry;
    [self.navigationController pushViewController:dvController animated:YES];
    [dvController release];
    dvController = nil;
} 

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(searching)
        return @"";
    
    if(section == 0)
        return @"Countries to visit";
    else
        return @"Countries visited";
}

/*-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}*/

/*- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    if(searching)
        return nil;
    
    NSArray *searchArray = [NSArray arrayWithObjects:
                            @"{search}", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L",
                            @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"#", nil];
    
    return searchArray;
}*/

/*- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    NSLog([NSString stringWithFormat:@"clicked index : %i",index]);
    if (index == 0) {
        [tableView scrollRectToVisible:[[tableView tableHeaderView] bounds] animated:NO];
        return -1;
    }
    return index;
}*/

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc
{
    [listOfItems release];
    [copyListOfItems release];
    [searchBar release];
    [super dealloc];
}

@end
