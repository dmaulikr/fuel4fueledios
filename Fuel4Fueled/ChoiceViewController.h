//
//  ChoiceViewController.h
//  Fuel4Fueled
//
//  Created by Ellidi Jatgeirsson on 11/15/12.
//
//

#import <UIKit/UIKit.h>

@interface ChoiceViewController : UIViewController
@property (nonatomic) int choice;

@property (strong, nonatomic) IBOutlet UILabel *questionLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)nextPressed;
@end
