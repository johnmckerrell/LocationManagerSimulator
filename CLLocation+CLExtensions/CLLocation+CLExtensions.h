//
//  CLLocation+CLExtensions.h
//
//  Created by Dave Addey on 03/12/2008.
//
#import <CoreLocation/CoreLocation.h>

@interface CLLocation (CLExtensions)

- (double)bearingInRadiansTowardsLocation:(CLLocation *)towardsLocation;
- (CLLocation *)newLocationAtDistance:(CLLocationDistance)atDistance alongBearingInRadians:(double)bearingInRadians;
- (CLLocation *)newLocationAtDistance:(CLLocationDistance)atDistance towardsLocation:(CLLocation *)towardsLocation;

@end
