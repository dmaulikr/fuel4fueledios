//
//  FoodTableController.m
//  Fuel4Fueled
//
//  Created by Ellidi Jatgeirsson on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FoodTableController.h"
#import "GroupData.h"

@interface FoodTableController ()

@end

@implementation FoodTableController
@synthesize foodTable;

GroupData *sharedGD;

UITableViewCell *cells[6];

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    sharedGD = [GroupData sharedManager];
    
    UITableViewCell *asian=[foodTable dequeueReusableCellWithIdentifier:@"FoodCell"];
    UITableViewCell *american=[foodTable dequeueReusableCellWithIdentifier:@"FoodCell"];
    UITableViewCell *italian=[foodTable dequeueReusableCellWithIdentifier:@"FoodCell"];
    UITableViewCell *eastern=[foodTable dequeueReusableCellWithIdentifier:@"FoodCell"];
    UITableViewCell *mexican=[foodTable dequeueReusableCellWithIdentifier:@"FoodCell"];
    UITableViewCell *veggie=[foodTable dequeueReusableCellWithIdentifier:@"FoodCell"];
    
    asian.textLabel.text = @"Something Asian...";
    american.textLabel.text = @"Classic American!";
    italian.textLabel.text = @"I'm digging Italian";
    eastern.textLabel.text = @"Middle Eastern?";
    mexican.textLabel.text = @"How bout some Mexican";
    veggie.textLabel.text = @"Vegetarian please!";
    
    cells[0]=asian;
    cells[1]=american;
    cells[2]=italian;
    cells[3]=eastern;
    cells[4]=mexican;
    cells[5]=veggie;
}

-(void)updatePrefs
{
    char byte = 0;
    for (int i=0; i<6; i++) {
        if ([cells[i] isSelected]) {
            byte |= (int)pow(2,i);
        }
    }
    
    [sharedGD setByte1: byte];
}

- (void)viewDidUnload
{
    [self setFoodTable:nil];
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
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cells[indexPath.row];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
