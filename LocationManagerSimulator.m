//
//  LocationManagerSimulator.m
//  BasicSatNav
//
//  Created by John McKerrell on 02/12/2009.
//  Copyright 2009 MKE Computing Ltd. All rights reserved.
//

#import "LocationManagerSimulator.h"

// This basically just a random figure found here:
// http://www.developerfusion.com/article/4652/writing-your-own-gps-applications-part-2/3/
#define DOP2METERS 6.0

@implementation LocationManagerSimulator

- (id)init
{
    if (self = [super init]) {
        multiplier = 1.0;
        filename = @"simulated-locations";
        startTime = nil;
        timer = nil;
        oldLocation = nil;
        lastDataIndex = 0;
    }
    return self;
}

- (id)initWithFilename:(NSString*)fn andMultiplier:(float)mult {
    if( self = [self init]) {
        filename = fn;
        multiplier = mult;
    }
    return self;
}

#if TARGET_IPHONE_SIMULATOR

- (void)loadData {
    if( ! filename ) {
        return;
    }
    NSString *fullFilename = [[NSBundle mainBundle] pathForResource:filename ofType:@"plist"];
    NSArray *fileData = [NSArray arrayWithContentsOfFile:fullFilename];
    if( fileData ) {
        NSLog( @"Loaded data from %@", fullFilename );
        data = [fileData retain];
    } else {
        NSLog( @"Couldn't load data from %@", fullFilename );
        filename = nil;
    }
}

- (void)startUpdatingLocation {
    if( timer ) {
        return;
    }

    [self loadData];
    
    if( ! data ) {
        return [super startUpdatingLocation];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                             target:self
                                           selector:@selector(calculatePosition)
                                           userInfo:nil
                                            repeats:YES];
    [timer retain];
    startTime = [NSDate new];
}

- (void)stopUpdatingLocation {
    if( ! filename ) {
        return [super stopUpdatingLocation];
    }
    [timer invalidate];
    [timer release];
    timer = nil;
}

- (CLLocation*) dictToLocation:(NSDictionary*) dict {
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[dict objectForKey:@"lat"] floatValue];
    coordinate.longitude = [[dict objectForKey:@"lon"] floatValue];
    CLLocationDistance altitude = 0.0;
    if( [dict objectForKey:@"ele"] ) {
        altitude = [[dict objectForKey:@"ele"] floatValue];
    }
    
    CLLocationAccuracy hAccuracy = 50.0, vAccuracy = 50.0;
    if( [dict objectForKey:@"hdop"] ) {
        hAccuracy = DOP2METERS * [[dict objectForKey:@"hdop"] floatValue];
    }
    if( [dict objectForKey:@"vdop"] ) {
        vAccuracy = DOP2METERS * [[dict objectForKey:@"vdop"] floatValue];
    }
    
    CLLocation *location = [[CLLocation alloc] 
                            initWithCoordinate:coordinate 
                            altitude:altitude 
                            horizontalAccuracy:hAccuracy 
                            verticalAccuracy:vAccuracy 
                            timestamp:[dict objectForKey:@"time"]];
    return location;
}

- (void)calculatePosition {
    NSUInteger currentDataIndex;
    CLLocation *location = nil;
    if( ! oldLocation ) {
        currentDataIndex = lastDataIndex;
        location = [self dictToLocation:[data objectAtIndex:currentDataIndex]];
    } else {
        NSTimeInterval interval = [startTime timeIntervalSinceNow];
        interval *= multiplier;
        //NSLog( @"Calculate position after %f", interval );
        currentDataIndex = lastDataIndex;
        
        NSDictionary *firstGPXPoint = [data objectAtIndex:0];
        NSDate *firstGPXTime = [firstGPXPoint objectForKey:@"time"];
        // While we haven't reached the end of the datapoints
        // if the interval between the GPX start and the GPX index position is greater than the interval between our start and now
        while( currentDataIndex < [data count] ) {
            NSDictionary *currentGPXPoint = [data objectAtIndex:currentDataIndex];
            NSDate *currentGPXTime = [currentGPXPoint objectForKey:@"time"];
            if( currentGPXTime ) {
                NSTimeInterval gpxInterval = [firstGPXTime timeIntervalSinceDate:currentGPXTime];
                //NSLog( @"gpxInterval=%f", gpxInterval );
                if( gpxInterval < interval ) {
                    // We've gone past the point we wanted to be at
                    break;
                }
            }

            ++currentDataIndex;
        }
        // We'll always go past the point we want to either by reaching the end or going one past the right one
        --currentDataIndex;
        if( currentDataIndex != lastDataIndex ) {
            location = [self dictToLocation:[data objectAtIndex:currentDataIndex]];
        }
    }
    if( location ) {
        [self.delegate locationManager:self didUpdateToLocation:location fromLocation:oldLocation];
        lastDataIndex = currentDataIndex;
        oldLocation = location;
    }
}


#endif

@end
