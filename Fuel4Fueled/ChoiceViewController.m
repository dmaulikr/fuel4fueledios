//
//  ChoiceViewController.m
//  Fuel4Fueled
//
//  Created by Ellidi Jatgeirsson on 11/15/12.
//
//

#import "ChoiceViewController.h"
#import "ViewController.h"

@interface ChoiceViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSArray *questions;
@property (nonatomic, strong) NSArray *options;
@property (nonatomic) int optionChosen;
@end

#define FOOD_CHOICE 0
#define DIST_CHOICE 1
#define QUAL_CHOICE 2

@implementation ChoiceViewController
@synthesize choice = _choice;
@synthesize questions = _questions;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.questions = [[NSArray alloc] initWithObjects:@"What kind of food are you in the mood for?",
                      @"How far will you travel for this fabled feast?",
                      @"How nice should this place be?", nil];
	
    switch (self.choice) {
        case FOOD_CHOICE:
        {
            [self.navigationController.navigationItem setTitle:@"Food"];
            [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:.682 green:0 blue:0 alpha:1]];
            
            self.groupData = [[GroupData alloc]init];
            
            self.questionLabel.text = [self.questions objectAtIndex:FOOD_CHOICE];
            self.options = [[NSArray alloc]initWithObjects:@"Something Asian...",
                            @"Classic American!",
                            @"I'm digging Italian",
                            @"Middle Eastern?",
                            @"How bout some Mexican",
                            @"Vegetarian please!", nil];
            [self.tableView setDelegate:self];
            [self.tableView setDataSource:self];
            [self.tableView setAllowsMultipleSelection:YES];
        }
            break;
        case DIST_CHOICE:
        {
            [self.navigationController.navigationItem setTitle:@"Distance"];
            self.questionLabel.text = [self.questions objectAtIndex:DIST_CHOICE];
            self.options = [[NSArray alloc]initWithObjects:@"Across the street. Tops.",
                            @"Walking distance is fine",
                            @"Anywhere in the city", nil];
            [self.tableView setDelegate:self];
            [self.tableView setDataSource:self];
            [self.tableView setAllowsMultipleSelection:NO];
        }
            break;
        case QUAL_CHOICE:
        {
            [self.navigationController.navigationItem setTitle:@"Rating"];
            self.questionLabel.text = [self.questions objectAtIndex:QUAL_CHOICE];
            self.options = [[NSArray alloc]initWithObjects:@"As long as it's not awful...",
                            @"Fairly nice",
                            @"Absolutely fantastic", nil];
            [self.tableView setDelegate:self];
            [self.tableView setDataSource:self];
            [self.tableView setAllowsMultipleSelection:NO];
        }
            break;
    }
}

-(void)updatePrefs
{
    switch (self.choice) {
        case FOOD_CHOICE:
            break;
        case DIST_CHOICE:
        {
            char byte = 0;
            switch (self.optionChosen) {
                case 0:
                {
                    byte |= 64;
                }
                    break;
                case 1:
                {
                    byte |= 128;
                }
                    break;
                case 2:
                {
                    byte |= 192;
                }
                    break;
            }
            
            char foodByte = [self.groupData byte1];
            byte |= foodByte;
            [self.groupData setByte1: byte];
        }
            break;
        case QUAL_CHOICE:
        {
            [self.groupData setByte2: self.optionChosen];
        }
            break;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Bump"]) {
        ((ViewController *)segue.destinationViewController).groupData = self.groupData;
    }else{
        ((ChoiceViewController *)segue.destinationViewController).groupData = self.groupData;
    }
}

#pragma mark - TableView Datasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Choice Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.textLabel.text = [self.options objectAtIndex:indexPath.row];
    
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[UIColor colorWithRed:.682 green:0 blue:0 alpha:1]];
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.choice == FOOD_CHOICE) {
        self.groupData.byte1 ^= (int)pow(2, self.optionChosen);
    }else{
        self.optionChosen = indexPath.row;
    }
}

- (void)viewDidUnload {
    [self setQuestionLabel:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}
- (IBAction)nextPressed
{
    [self updatePrefs];
    if (self.choice == QUAL_CHOICE) {
        [self performSegueWithIdentifier:@"Bump" sender:self];
    }else{
        ChoiceViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"ChoiceIdentifier"];
        next.choice = self.choice + 1;
        [self.navigationController pushViewController:next animated:YES];
    }
}
@end
