//
//  DetailViewController.m
//  TableView
//
//  Created by Marcus Morrison on 14/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"

@implementation DetailViewController

@synthesize selectedCountry;
@synthesize activityIndicator;
@synthesize lblLoad;
@synthesize lblPopulation;
@synthesize lblCapital;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)buttonClicked:(id)sender {
    NSString *postString = 
        [NSString stringWithFormat:@"countryName=%@", lblText.text];
    // DEBUG log the proposed post string to console
    //NSLog(postString);
    
    NSURL *url = [NSURL URLWithString: 
                  @"http://www.ezzylearning.com/services/CountryInformationService.asmx/GetPopulationByCountry"];
    /*NSURL *url = [NSURL URLWithString: 
                  @"http://www.ezzylearning.com/services/CountryInformationService.asmx/GetCapitalByCountry"];*/
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = 
        [NSString stringWithFormat:@"%d", [postString length]];
    
    [req addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody: [postString 
                       dataUsingEncoding:NSUTF8StringEncoding]];
    
    [activityIndicator setHidden:FALSE];
    [lblLoad           setHidden:FALSE];
    [activityIndicator startAnimating];
    
    serviceConnection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (serviceConnection) {
        serviceData = [[NSMutableData data] retain];
    }    
}

-(void) connection:(NSURLConnection *) connection 
didReceiveResponse:(NSURLResponse *) response {
    [serviceData setLength: 0];
}

-(void) connection:(NSURLConnection *) connection 
    didReceiveData:(NSData *) data {
    [serviceData appendData:data];
}

-(void) connection:(NSURLConnection *) connection 
  didFailWithError:(NSError *) error {
    [serviceData release];
    [connection release];
}

-(void) connectionDidFinishLoading:(NSURLConnection *) connection {
    //NSLog(@"DONE. Received Bytes: %d", [serviceData length]);
    NSString *theXML = [[NSString alloc] 
                        initWithBytes: [serviceData mutableBytes] 
                        length:[serviceData length] 
                        encoding:NSUTF8StringEncoding];
    // DEBUG log the xml response to console
    //NSLog(theXML);
    [theXML release];    
    [activityIndicator stopAnimating];
    [activityIndicator setHidden:TRUE];
    [lblLoad           setHidden:TRUE];
    
    if (xmlParser)
    {
        [xmlParser release];
    }
        
    xmlParser = [[NSXMLParser alloc] initWithData: serviceData];
    [xmlParser setDelegate: self];
    [xmlParser setShouldResolveExternalEntities: YES];
    [xmlParser setShouldProcessNamespaces: YES];
    [xmlParser parse];
    
    [connection release];
    [serviceData release];
}

-(void) parser:(NSXMLParser *) parser 
didStartElement:(NSString *) elementName 
  namespaceURI:(NSString *) namespaceURI 
 qualifiedName:(NSString *) qName
    attributes:(NSDictionary *) attributeDict {
    
    // TODO extend to other tags used by web service
    if( [elementName isEqualToString:@"string"])
    {
        if (!serviceResults)
        {
            serviceResults = [[NSMutableString alloc] init];
        }
        elementFound = TRUE;
    }
}

-(void)parser:(NSXMLParser *) parser foundCharacters:(NSString *)string
{
    if (elementFound)
    {
        [serviceResults appendString: string];
    }
}

-(void)parser:(NSXMLParser *)parser 
didEndElement:(NSString *)elementName 
 namespaceURI:(NSString *)namespaceURI 
qualifiedName:(NSString *)qName
{
    //NSString *resource = [namespaceURI lastPathComponent];
    //NSLog(namespaceURI);
    //NSLog(qName);
    //NSLog(resource);
    
    // TODO extend to other tags used by web service
    if ([elementName isEqualToString:@"string"])
    {
        //NSLog(serviceResults);        
        lblPopulation.text = serviceResults;
        [serviceResults setString:@""];
        elementFound = FALSE; 
    }
}

- (void)dealloc
{
    [activityIndicator release];
    [xmlParser release];
    [serviceResults release];    
    [lblText release];
    [lblLoad release];
    [lblPopulation release];
    [lblCapital release];
    [selectedCountry release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Display the selected country
    lblText.text = selectedCountry;
    
    // Hide the activity indicator
    activityIndicator.hidden = TRUE;
    lblLoad.hidden           = TRUE;
    
    // Set the title of the navigation bar
    self.navigationItem.title = @"Selected Country";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
