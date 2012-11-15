//
//  FoodTableController.h
//  Fuel4Fueled
//
//  Created by Ellidi Jatgeirsson on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodTableController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *foodTable;
-(void)updatePrefs;


@end
