//
//  DistanceTableController.h
//  Fuel4Fueled
//
//  Created by Ellidi Jatgeirsson on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DistanceTableController : UITableViewController
@property (weak, nonatomic) IBOutlet UITableView *distTable;
-(void)updatePrefs;

@end
