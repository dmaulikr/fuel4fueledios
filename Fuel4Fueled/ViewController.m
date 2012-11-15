//
//  ViewController.m
//  Fuel4Fueled
//
//  Created by Ellidi Jatgeirsson on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "OptionViewController.h"
#import "Person.h"
#import "BumpClient.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize byte1 = byte1_;
@synthesize byte2 = byte2_;
@synthesize groupData = _groupData;

CLLocation *currentLocation;
Person *p;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    currentLocation = [self.groupData returnLocation];
    self.byte1=[self.groupData byte1];
    self.byte2=[self.groupData byte2];
    NSString *u=[[UIDevice currentDevice] name];
    Person *p=[[Person alloc] init:u byte1:self.byte1 byte2:self.byte2 loc:currentLocation];
    [self.groupData addPerson: p];
}

/*
 This method is straight out of the Bump API examples, with my own data subbed in.
*/
- (IBAction) configureBump {
    [BumpClient configureWithAPIKey:@"638debb5d918495e92fad17c2d86159a" andUserID:[[UIDevice currentDevice] name]];
    
    [[BumpClient sharedClient] setMatchBlock:^(BumpChannelID channel) { 
        NSLog(@"Matched with user: %@", [[BumpClient sharedClient] userIDForChannel:channel]); 
        [[BumpClient sharedClient] confirmMatch:YES onChannel:channel];
    }];
    
    [[BumpClient sharedClient] setChannelConfirmedBlock:^(BumpChannelID channel) {
        NSLog(@"Channel with %@ confirmed.", [[BumpClient sharedClient] userIDForChannel:channel]);
        //        [[BumpClient sharedClient] sendData:[[[people objectAtIndex:0] uid] dataUsingEncoding:NSUTF8StringEncoding]
        //                                  toChannel:channel];
        char byts[2] = {self.byte1, self.byte2};
        NSData *bytes = [NSData dataWithBytes:byts length:2];
        [[BumpClient sharedClient] sendData:bytes toChannel:channel];
        float lat = currentLocation.coordinate.latitude;
        float lon = currentLocation.coordinate.longitude;
        NSData *latbytes = [NSData dataWithBytes:&lat length:sizeof(float)];
        [[BumpClient sharedClient] sendData:latbytes toChannel:channel];
        NSData *lonbytes = [NSData dataWithBytes:&lon length:sizeof(float)];
        [[BumpClient sharedClient] sendData:lonbytes toChannel:channel];
    }];
    
    [[BumpClient sharedClient] setDataReceivedBlock:^(BumpChannelID channel, NSData *data) {
        NSLog(@"Data received from %@: %@", 
              [[BumpClient sharedClient] userIDForChannel:channel], 
              [NSString stringWithCString:[data bytes] encoding:NSUTF8StringEncoding]);
        if (data.length>8) {
            [p setUid:data.bytes];
        }
        if (data.length==8) {
            double d;
            assert([data length] == sizeof(d));
            memcpy(&d, [data bytes], sizeof(d));
            if (![p location].coordinate.latitude) {
                CLLocation *loc = [[CLLocation alloc] initWithLatitude:d longitude:[p location].coordinate.longitude];
                [p setLocation:loc];
            }else {
                CLLocation *loc = [[CLLocation alloc] initWithLatitude:[p location].coordinate.latitude longitude:d];
                [p setLocation:loc];
            }
        }
        if (data.length==2) {
            unsigned char *c = NULL;
            memcpy(c, [data bytes], 2);
            [p setByte1:c[0]];
            [p setByte2:c[1]];
        }
        //        if (p.location.coordinate.latitude && p.location.coordinate.longitude && p.byte1 && p.byte2 && p.uid) {
        //            [self addPerson: p];
        //        }
    }];
    
    [[BumpClient sharedClient] setConnectionStateChangedBlock:^(BOOL connected) {
        if (connected) {
            NSLog(@"Bump connected...");
        } else {
            NSLog(@"Bump disconnected...");
        }
    }];
    
    [[BumpClient sharedClient] setBumpEventBlock:^(bump_event event) {
        switch(event) {
            case BUMP_EVENT_BUMP:
                NSLog(@"Bump detected.");
                break;
            case BUMP_EVENT_NO_MATCH:
                NSLog(@"No match.");
                break;
        }
    }];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ((OptionViewController *)[((UITabBarController *)segue.destinationViewController).viewControllers objectAtIndex:0]).groupData = self.groupData;
    ((OptionViewController *)[((UITabBarController *)segue.destinationViewController).viewControllers objectAtIndex:1]).groupData = self.groupData;
}

@end
