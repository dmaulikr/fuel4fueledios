//
//  FoodController.m
//  Fuel4Fueled
//
//  Created by Ellidi Jatgeirsson on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FoodController.h"
#import "FoodTableController.h"


@interface FoodController ()
@end

@implementation FoodController
@synthesize frame;
FoodTableController *tableControl;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    tableControl = [self.storyboard instantiateViewControllerWithIdentifier:@"ftc"];
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
