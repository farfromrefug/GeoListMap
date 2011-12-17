//
//  EventWrapper.h
//  IziPass
//
//  Created by Nicolas Brocard on 14/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@protocol GLMItemWrapper <NSObject>
//@property(nonatomic, retain) NSString	*iziId;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;
//@property(nonatomic, retain) NSString	*category;
@property(nonatomic, retain) NSString	*address;
//@property(nonatomic, retain) NSString	*pageUrl;
//@property(nonatomic, retain) NSString	*imageUrl;
@property(nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (NSString *) displayableDistanceFrom:(CLLocation *)loc;
@end
