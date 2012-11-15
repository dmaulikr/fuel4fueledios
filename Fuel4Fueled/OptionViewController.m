//
//  OptionViewController.m
//  Fuel4Fueled
//
//  Created by Ellidi Jatgeirsson on 5/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OptionViewController.h"
#import "GroupData.h"
#import "GTMNSString+URLArguments.h"

@interface OptionViewController ()

@end

@implementation OptionViewController
@synthesize title1;
@synthesize rating1;
@synthesize choose1;
@synthesize title2;
@synthesize rating2;
@synthesize choose2;
UIAlertView *alert;
NSMutableData *responseData;

GroupData *sharedGD;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    sharedGD = [GroupData sharedManager];
    
    alert = [[UIAlertView alloc] initWithTitle:@"Fetching options\nPlease Wait..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [alert show];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    // Adjust the indicator so it is up a few pixels from the bottom of the alert
    indicator.center = CGPointMake(alert.bounds.size.width / 2, alert.bounds.size.height - 50);
    [indicator startAnimating];
    [alert addSubview:indicator];
    
    //Realized I hadn't actually threaded appropriately originally.
    [NSThread detachNewThreadSelector:@selector(loadInfo) toTarget:self withObject:nil];
}

-(void) loadInfo
{
    [sharedGD calcPrefs];
    
    [self setOpt1];
    
    [self setOpt2];
    
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)setOpt1
{
    if (sharedGD.nam1) {
        [title1 setText:sharedGD.nam1];
        [rating1 setText:sharedGD.rat1];
    }
}

-(void)setOpt2
{
    if (sharedGD.nam1) {
        [title2 setText:sharedGD.nam2];
        [rating2 setText:sharedGD.rat2];
    }
}

- (void)viewDidUnload
{
    [self setTitle1:nil];
    [self setRating1:nil];
    [self setChoose1:nil];
    [self setTitle2:nil];
    [self setRating2:nil];
    [self setChoose2:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)sendEasyTweet1:(id)sender {
    
    // Set up the built-in twitter composition view controller.
    
    TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
    
    
    
    // Set the initial tweet text. See the framework for additional properties that can be set.
    
    [tweetViewController setInitialText:@"Out to lunch with my colleagues!"];
    
    
    
    // Create the completion handler block.
    
    [tweetViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
        // Dismiss the tweet composition view controller.
        [self dismissModalViewControllerAnimated:YES];
    }];
    
    
    
    // Present the tweet composition view controller modally.
    
    [self presentModalViewController:tweetViewController animated:YES];
    
}

@end
