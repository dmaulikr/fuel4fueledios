//
//  Person.m
//  Fuel4Fueled
//
//  Created by Ellidi Jatgeirsson on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Person.h"

@implementation Person
@synthesize uid;
@synthesize byte1;
@synthesize byte2;
@synthesize location;


-(id) init:(NSString *)u byte1:(char)b1 byte2:(char)b2 loc:(CLLocation *)l
{
    uid=u;
    byte1=b1;
    byte2=b2;
    location=l;
    return self;
}

@end
