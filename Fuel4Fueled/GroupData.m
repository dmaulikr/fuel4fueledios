//
//  GroupData.m
//  Fuel4Fueled
//
//  Created by Ellidi Jatgeirsson on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GroupData.h"
#import "SBJson.h"
#import "GooglePlacesObject.h"
#import "GooglePlacesConnection.h"

@implementation GroupData
@synthesize byte1 = byte1_;
@synthesize byte2 = byte2_;
@synthesize nam1 = nam1_;
@synthesize nam2 = nam2_;
@synthesize rat1 = rat1_;
@synthesize rat2 = rat2_;

CLLocationManager *locManager;
CLLocation *currentLocation;
CLLocation *loc;
NSMutableArray *people;

-(void)addPerson:(Person *)person
{
    if (!people) {
        people=[[NSMutableArray alloc] initWithCapacity:1];
    }
    [people addObject:person];
}

-(NSMutableArray *)getPeople
{
    return people;
}

/*
 I think this must be the method to which you were referring when you were talking about too much pure C
 code (otherwise, not quite sure, though I use char's etc in other places). You asked if it can be 
 replaced by obj-c code. The answer, I think, is yes and no. I've tried to make this version of the app
 compatible with the Android version I made before for you guys, and as such I need to use the bytes that
 are exchanged in the same way. I could avoid the byte arithmetic, but it would take much longer in most
 cases. So in that sense, no.
 
 On the other hand, if I were to make this incompatible with the Android version, then yes; I could 
 exchange boolean values, or even whole obj-c objects, which would allow me to skip using bytes etc 
 altogether. 
 
 If you're referring to a different method or code snippet, if you'll point it out to me, I'd be happy to
 take a look at it and adjust it appropriately.
*/
-(void)calcPrefs
{
    int foodTypes[6]={0,0,0,0,0,0};
    int distOpts[3]={0,0,0};
    int rateOpts[3]={0,0,0};
    float baryLat = 0;
    float baryLon = 0;
    for (int i = 0; i<[people count]; i++) {
        Person *p = [people objectAtIndex:i];
        
        for (int j = 0; j<6; j++) {
            if ((([p byte1]>>j)&1)>0) {
                foodTypes[j]++;
            }
        }
        
        char b = [p byte1]>>6;
        switch (b) {
            case 1:
                distOpts[0]++;
                break;
            case -2:
                distOpts[1]++;
                break;
            case -1:
                distOpts[2]++;
                break;
            default:
                break;
        }
        
        switch ([p byte2]) {
            case 0x01:
                rateOpts[2]++;
                break;
            case 0x02:
                rateOpts[1]++;
                break;
            case 0x03:
                rateOpts[0]++;
                break;
            default:
                break;
        }
        
        baryLat+=p.location.coordinate.latitude;
        baryLon+=p.location.coordinate.longitude;
    }
    
    baryLon /= [people count];
    baryLat /= [people count];
    
    loc=[[CLLocation alloc] initWithLatitude:baryLat longitude:baryLon];
    
    int first=0;
    int second=0;
    int third=0;
    for (int i =0; i<6; i++) {
        if (foodTypes[i]>=foodTypes[first]) {
            third=second;
            second=first;
            first=i;
        }
    }
    
    int d=[self calcDist:distOpts];
    
    int s=[self calcStars:rateOpts];
    
    [self setPlaces:first second:second third:third stars:s dist:d];
}

-(int)calcDist:(int[])distOpts
{
    int d=2;
    if (distOpts[0]/(distOpts[0]+distOpts[1]+distOpts[2])>.3) {
        d=0;
    }else if (distOpts[1]>distOpts[2]) {
        d=1;
    }
    return d;
}

-(int)calcStars:(int[])rateOpts
{
    int s=0;
    if (rateOpts[2]/(rateOpts[0]+rateOpts[1]+rateOpts[2])>.3 && rateOpts[2]/(rateOpts[0]+rateOpts[1]+rateOpts[2])!=1) {
        s=2;
    }else if (rateOpts[2]<rateOpts[1]) {
        s=1;
    }
    return s;
}

-(void)setPlaces:(int)first second:(int)second third:(int)third stars:(int)s dist:(int)d
{
    NSString *foods[6] = {@"asian+thai+indian+chinese+sushi+japanese",@"burgers+wings+pizza+bbq+fries",@"italian",@"middle+eastern",@"mexican",@"vegetarian"};
    int dists[3] = {400,1000,4000};
    float stars[3] = {1.0,3.0,4.5};
    
    NSString *ref1 = [self bestPlace: foods[first] rate: stars[s] dist: dists[d]];
    
    if (ref1) {
        NSString *ref2 = [self bestPlace: foods[second] rate: stars[s] dist: dists[d]];
        if (ref2) {
            [self setRef1:ref1];
            [self setRef2:ref2];
        }else {
            NSString *ref2 = [self bestPlace: foods[third] rate: stars[s] dist: dists[d]];
            if (ref2) {
                [self setRef1:ref1];
                [self setRef2:ref2];
            }else {
                [self setRef1:ref1];
            }
        }
    }else {
        NSString *ref1 = [self bestPlace: foods[second] rate: stars[s] dist: dists[d]];
        if (ref1) {
            NSString *ref2 = [self bestPlace: foods[third] rate: stars[s] dist: dists[d]];
            if (ref2) {
                [self setRef1:ref1];
                [self setRef2:ref2];
            }else {
                [self setRef1:ref1];
            }
        }else {
            NSString *ref1 = [self bestPlace: foods[third] rate: stars[s] dist: dists[d]];
            if (ref1){
                [self setRef1:ref1];
            }else {
                //set neither
            }
        }
    }
}

-(NSString *)bestPlace:(NSString *)food rate:(float)minRate dist:(int) d
{
    NSString *place;
    
    NSString *googleApi = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&rankby=distance&types=&keyword=%@&sensor=true&key=AIzaSyCgw9fpcQE3Qy7v2MBhrwEuuwExef0a8Ck",loc.coordinate.latitude,loc.coordinate.longitude,food];
    
    NSString *finalURL = [googleApi  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:finalURL];
    
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    NSError* error = [[NSError alloc] init];
    NSURLResponse *response = [[NSURLResponse alloc] init];
    NSData *connect = [[NSData alloc] init];
    connect = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    
    SBJsonParser *json          = [[SBJsonParser alloc] init];
    
	NSString *responseString    = [[NSString alloc] initWithData:connect encoding:NSUTF8StringEncoding];	
	NSError *jsonError          = nil;
	
	NSDictionary *parsedJSON    = [json objectWithString:responseString error:&jsonError];
    
	if ([jsonError code]==0) 
    {
        NSString *responseStatus = [NSString stringWithFormat:@"%@",[parsedJSON objectForKey:@"status"]];
        
        if ([responseStatus isEqualToString:@"OK"]) 
        {
            if ([parsedJSON objectForKey: @"results"] != nil) {
                //Perform Place Search results
                NSDictionary *gResponseData  = [parsedJSON objectForKey: @"results"];
                NSMutableArray *googlePlacesObjects = [NSMutableArray arrayWithCapacity:[[parsedJSON objectForKey:@"results"] count]]; 
                
                for (NSDictionary *result in gResponseData) 
                {
                    [googlePlacesObjects addObject:result];
                }
                
                for (int x=0; x<[googlePlacesObjects count]; x++) 
                {                
                    GooglePlacesObject *object = [[GooglePlacesObject alloc] initWithJsonResultDict:[googlePlacesObjects objectAtIndex:x] andUserCoordinates:loc.coordinate];
                    [googlePlacesObjects replaceObjectAtIndex:x withObject:object];
                }
                
                for (int i=0; i<[googlePlacesObjects count]; i++) {
                    GooglePlacesObject *o = [googlePlacesObjects objectAtIndex:i];
                    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
                    [f setNumberStyle:NSNumberFormatterDecimalStyle];
                    //                    NSNumber * myRate = [f numberFromString:[o rating]];
                    //                    [f setNumberStyle:NSNumberFormatterDecimalStyle];
                    float rate = [[o rating] floatValue];
                    NSNumber * myDist = [f numberFromString:[o distanceInFeetString]];
                    
                    if ([myDist floatValue]*.3048<=d) {
                        if (rate>=minRate) {
                            place=[o reference];
                            minRate=rate;
                        }
                    }
                    
                }
            }
            
        }
	}
    return place;
}

-(void)setRef1:(NSString *)ref
{
    NSString *googleApi = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?reference=%@&sensor=true&key=%@",ref, @"AIzaSyCgw9fpcQE3Qy7v2MBhrwEuuwExef0a8Ck"];
    
    NSString *finalURL = [googleApi  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:finalURL];
    
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    NSError* error = nil;
    NSURLResponse *response;
    NSData *connect= [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    SBJsonParser *json          = [[SBJsonParser alloc] init];
    
	NSString *responseString    = [[NSString alloc] initWithData:connect encoding:NSUTF8StringEncoding];	
	NSError *jsonError          = nil;
	
	NSDictionary *parsedJSON    = [json objectWithString:responseString error:&jsonError];
    
	if ([jsonError code]==0) 
    {
        NSString *responseStatus = [NSString stringWithFormat:@"%@",[parsedJSON objectForKey:@"status"]];
        
        if ([responseStatus isEqualToString:@"OK"]) 
        {
            if ([parsedJSON objectForKey: @"results"] == nil) {
                //Perform Place Details results
                NSDictionary *gResponseDetailData = [parsedJSON objectForKey: @"result"];
                NSMutableArray *googlePlacesDetailObject = [NSMutableArray arrayWithCapacity:1];  //Hard code since ONLY 1 result will be coming back
                
                GooglePlacesObject *detailObject = [[GooglePlacesObject alloc] initWithJsonResultDict:gResponseDetailData andUserCoordinates:loc.coordinate];
                [googlePlacesDetailObject addObject:detailObject];
                
                self.nam1=[detailObject name];
                self.rat1=[NSString stringWithFormat:@"%f",[[detailObject rating] floatValue]];
            }
        }
    }
}

-(void)setRef2:(NSString *)ref
{
    NSString *googleApi = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?reference=%@&sensor=true&key=%@",ref, @"AIzaSyCgw9fpcQE3Qy7v2MBhrwEuuwExef0a8Ck"];
    
    NSString *finalURL = [googleApi  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:finalURL];
    
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    NSError* error = nil;
    NSURLResponse *response;
    NSData *connect= [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    SBJsonParser *json          = [[SBJsonParser alloc] init];
    
	NSString *responseString    = [[NSString alloc] initWithData:connect encoding:NSUTF8StringEncoding];	
	NSError *jsonError          = nil;
	
	NSDictionary *parsedJSON    = [json objectWithString:responseString error:&jsonError];
    
	if ([jsonError code]==0) 
    {
        NSString *responseStatus = [NSString stringWithFormat:@"%@",[parsedJSON objectForKey:@"status"]];
        
        if ([responseStatus isEqualToString:@"OK"]) 
        {
            if ([parsedJSON objectForKey: @"results"] == nil) {
                //Perform Place Details results
                NSDictionary *gResponseDetailData = [parsedJSON objectForKey: @"result"];
                NSMutableArray *googlePlacesDetailObject = [NSMutableArray arrayWithCapacity:1];  //Hard code since ONLY 1 result will be coming back
                
                GooglePlacesObject *detailObject = [[GooglePlacesObject alloc] initWithJsonResultDict:gResponseDetailData andUserCoordinates:loc.coordinate];
                [googlePlacesDetailObject addObject:detailObject];
                
                self.nam2=[detailObject name];
                self.rat2=[NSString stringWithFormat:@"%f",[[detailObject rating] floatValue]];
            }
        }
    }
}

-(void)startUpdating
{    
    locManager = [[CLLocationManager alloc] init];
    locManager.delegate = self;
    locManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locManager startUpdatingLocation];
}

-(void)stopUpdating
{
    [locManager stopUpdatingLocation];
}

#pragma mark 
#pragma mark locationManager delegate methods 


- (void)locationManager: (CLLocationManager *)manager
    didUpdateToLocation: (CLLocation *)newLocation
           fromLocation: (CLLocation *)oldLocation
{
    currentLocation = newLocation;
}

-(CLLocation *) returnLocation
{
    [self stopUpdating];
    return currentLocation;
}

#pragma mark Singleton Methods

+ (id)sharedManager {
    static GroupData *sharedGroupData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGroupData = [[self alloc] init];
    });
    return sharedGroupData;
}

- (id)init {
    if (self = [super init]){
        [self startUpdating];
    }
    return self;
}

@end
