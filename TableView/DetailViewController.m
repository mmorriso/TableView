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

NSString * const CONF_SERVICE_URI = @"http://www.ezzylearning.com/services/CountryInformationService.asmx";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)buttonClicked:(id)sender {
    
    [self serviceRequest:@"GetPopulationByCountry": lblText.text];
    
    [self serviceRequest:@"GetCapitalByCountry": lblText.text];
    
    [activityIndicator setHidden:FALSE];
    [lblLoad           setHidden:FALSE];
    [activityIndicator startAnimating];
    
}

-(void) serviceRequest:(NSString *) serviceURI:(NSString *) serviceArgument {

    NSString *postString = [NSString stringWithFormat:@""
                            "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                            "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "
                            "xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
                            "<soap12:Body>"
                            "<%@ xmlns=\"%@\">"
                            "<countryName>%@</countryName>"
                            "</%@>"
                            "</soap12:Body>"
                            "</soap12:Envelope>", serviceURI, CONF_SERVICE_URI, serviceArgument, serviceURI];
    
    NSURL *url = [NSURL URLWithString: CONF_SERVICE_URI];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //define message headers
    NSString *msgAction = [NSString stringWithFormat:@"%@/%@", CONF_SERVICE_URI, serviceURI];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [postString length]];
    [req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:msgAction forHTTPHeaderField:@"SOAPAction"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    //define message method and body
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody: [postString dataUsingEncoding:NSUTF8StringEncoding]];
     
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
    if (xmlParser)
    {
        [xmlParser release];
    }
        
    xmlParser = [[[NSXMLParser alloc] initWithData: serviceData] retain];
    [xmlParser setDelegate: self];
    [xmlParser setShouldResolveExternalEntities: YES];
    [xmlParser setShouldProcessNamespaces: YES];
    [xmlParser parse];
    
    [connection release];
    [serviceData release];
    
    [activityIndicator stopAnimating];
    [activityIndicator setHidden:TRUE];
    [lblLoad           setHidden:TRUE];

}

-(void) parser:(NSXMLParser *) parser 
didStartElement:(NSString *) elementName 
  namespaceURI:(NSString *) namespaceURI 
 qualifiedName:(NSString *) qName
    attributes:(NSDictionary *) attributeDict {
    
    if( [elementName isEqualToString:@"GetCapitalByCountryResult"] || [elementName isEqualToString:@"GetPopulationByCountryResult"])
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
    if ([elementName isEqualToString:@"GetCapitalByCountryResult"])
    {
        lblCapital.text = serviceResults;
        [serviceResults setString:@""];
        elementFound = FALSE; 
    } 
    else if ([elementName isEqualToString:@"GetPopulationByCountryResult"])
    {
        lblPopulation.text = serviceResults;
        [serviceResults setString:@""];
        elementFound = FALSE; 
    }

}

- (void)dealloc
{
    [activityIndicator release];
    [xmlParser         release];
    [serviceResults    release];
    [lblText           release];
    [lblLoad           release];
    [lblPopulation     release];
    [lblCapital        release];
    [selectedCountry   release];
    [CONF_SERVICE_URI  release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    lblText.text = selectedCountry;
    
    activityIndicator.hidden = TRUE;
    lblLoad.hidden           = TRUE;
    
    self.navigationItem.title = @"Selected Country";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
