//
//  DistanceTableController.m
//  Fuel4Fueled
//
//  Created by Ellidi Jatgeirsson on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DistanceTableController.h"
#import "GroupData.h"

@interface DistanceTableController ()

@end

@implementation DistanceTableController
@synthesize distTable;

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
    
    UITableViewCell *small=[distTable dequeueReusableCellWithIdentifier:@"DistCell"];
    UITableViewCell *med=[distTable dequeueReusableCellWithIdentifier:@"DistCell"];
    UITableViewCell *large=[distTable dequeueReusableCellWithIdentifier:@"DistCell"];
    
    small.textLabel.text = @"Across the street. Tops.";
    med.textLabel.text = @"Walking distance is fine";
    large.textLabel.text = @"Anywhere in the city";
    
    cells[0]=small;
    cells[1]=med;
    cells[2]=large;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)updatePrefs
{
    char byte = 0;
    if ([cells[0] isSelected]) {
        byte |= 64;
    }
    if ([cells[1] isSelected]) {
        byte |= 128;
    }
    if ([cells[2] isSelected]) {
        byte |= 192;
    }
    
    char foodByte = [sharedGD byte1];
    byte |= foodByte;
    [sharedGD setByte1: byte];
}

- (void)viewDidUnload
{
    [self setDistTable:nil];
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
