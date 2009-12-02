//
//  LocationManagerSimulator.h
//  BasicSatNav
//
//  Created by John McKerrell on 02/12/2009.
//  Copyright 2009 MKE Computing Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface LocationManagerSimulator : CLLocationManager {
    NSString *filename;
    NSDate *startTime;
    NSTimer *timer;
    CLLocation *oldLocation;
    float multiplier;
    NSArray *data;
    NSUInteger lastDataIndex;
}

- (id)init;

- (id)initWithFilename:(NSString*)fn andMultiplier:(float)mult;

#if TARGET_IPHONE_SIMULATOR

- (void)loadData;

- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

- (void)calculatePosition;

- (CLLocation*) dictToLocation:(NSDictionary*) dict;

#endif

@end
