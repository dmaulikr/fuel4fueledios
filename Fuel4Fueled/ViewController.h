//
//  ViewController.h
//  Fuel4Fueled
//
//  Created by Ellidi Jatgeirsson on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupData.h"

@interface ViewController : UIViewController
@property (nonatomic) char byte1;
@property (nonatomic) char byte2;
@property (nonatomic) GroupData *groupData;

- (IBAction) configureBump;

@end
