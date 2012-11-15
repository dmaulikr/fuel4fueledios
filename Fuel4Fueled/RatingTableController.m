//
//  RatingTableController.m
//  Fuel4Fueled
//
//  Created by Ellidi Jatgeirsson on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RatingTableController.h"
#import "GroupData.h"

@interface RatingTableController ()

@end

@implementation RatingTableController
@synthesize rateTable;

GroupData *sharedGD;

UITableViewCell *cells[3];

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    sharedGD = [GroupData sharedManager];
    
    UITableViewCell *bad=[rateTable dequeueReusableCellWithIdentifier:@"RateCell"];
    UITableViewCell *ok=[rateTable dequeueReusableCellWithIdentifier:@"RateCell"];
    UITableViewCell *good=[rateTable dequeueReusableCellWithIdentifier:@"RateCell"];
    
    bad.textLabel.text = @"As long as it's not awful...";
    ok.textLabel.text = @"Fairly nice";
    good.textLabel.text = @"Absolutely fantastic";
    
    cells[0]=bad;
    cells[1]=ok;
    cells[2]=good;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)updatePrefs
{
    int byte = 0;
    if ([cells[0] isSelected]) {
        byte = 1;
    }
    if ([cells[1] isSelected]) {
        byte = 2;
    }
    if ([cells[2] isSelected]) {
        byte = 3;
    }
    
    [sharedGD setByte2: byte];
}

- (void)viewDidUnload
{
    [self setRateTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cells[indexPath.row];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
