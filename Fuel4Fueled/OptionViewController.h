//
//  OptionViewController.h
//  Fuel4Fueled
//
//  Created by Ellidi Jatgeirsson on 5/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Twitter/Twitter.h>

@interface OptionViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *title1;
@property (weak, nonatomic) IBOutlet UILabel *rating1;
@property (weak, nonatomic) IBOutlet UIButton *choose1;
@property (weak, nonatomic) IBOutlet UILabel *title2;
@property (weak, nonatomic) IBOutlet UILabel *rating2;
@property (weak, nonatomic) IBOutlet UIButton *choose2;

@end
