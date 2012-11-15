//
//  Person.h
//  Fuel4Fueled
//
//  Created by Ellidi Jatgeirsson on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject
@property (nonatomic, weak) CLLocation *location;
@property (nonatomic) char byte1;
@property (nonatomic) char byte2;
@property (nonatomic, weak) NSString *uid;
-(id) init:(NSString *)uid byte1:(char)b1 byte2:(char)b2 loc:(CLLocation *)l;

@end
