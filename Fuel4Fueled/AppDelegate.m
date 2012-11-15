//
//  AppDelegate.m
//  Fuel4Fueled
//
//  Created by Ellidi Jatgeirsson on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/*
 This revised version has a very different layout from the first one: I've tried to strictly delineate the
 models from the controllers, and kept the views coming from the storyboard, by putting all methods relating
 to the data received from people in the singleton class 'GroupData.' 
 
 All controllers do just what they're supposed to do: control the views. No more dealing with model data.
 
 The AppDelegate (as you see below) only starts the application. I got rid of all the protocals that I 
 didn't use that were leftover at the top of some of my controllers from an earlier iteration of the code. 
 
 I correctly implemented (I think) the table views. 
 
 I reorganized the code in places to have more wrapper methods when possible, to make it easier to read.
 
 I kept the location updates starting at the beginning so as to get a more accurate fix, but configured
 the Bump API later in the app, once all the options have been chosen (see ViewController.m).
 
 I removed the reference to an unimplemented method which made the app crash (it was a debugging type thing).
 
 I looked at where I suspected the pure C code you took issue with was and tried to think of how to change
 it. See the comment in GroupData.m just above the calcPrefs method.
 */

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}

@end
