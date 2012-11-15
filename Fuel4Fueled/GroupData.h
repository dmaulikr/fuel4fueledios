//
//  GroupData.h
//  Fuel4Fueled
//
//  Created by Ellidi Jatgeirsson on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Person.h"

@interface GroupData : NSObject <CLLocationManagerDelegate>
@property (nonatomic) char byte1;
@property (nonatomic) char byte2;
@property (nonatomic,weak) NSString *nam1;
@property (nonatomic,weak) NSString *nam2;
@property (nonatomic,weak) NSString *rat1;
@property (nonatomic,weak) NSString *rat2;
-(void)calcPrefs;
-(CLLocation *) returnLocation;
-(void) addPerson: (Person *)p;
-(NSMutableArray *) getPeople;
-(NSString *)bestPlace:(NSString *)food rate:(float)minRate dist:(int) d;
+(id)sharedManager;

@end
