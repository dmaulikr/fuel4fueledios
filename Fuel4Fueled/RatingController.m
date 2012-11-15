//
//  RatingController.m
//  Fuel4Fueled
//
//  Created by Ellidi Jatgeirsson on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RatingController.h"
#import "RatingTableController.h"

@interface RatingController ()

@end

@implementation RatingController
@synthesize frame;
RatingTableController *tableControl;

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
    tableControl = [self.storyboard instantiateViewControllerWithIdentifier:@"rtc"];
    [frame addSubview:[tableControl view]];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [tableControl updatePrefs];
}

- (void)viewDidUnload
{
    [self setFrame:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
