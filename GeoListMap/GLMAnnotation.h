//
//  GLMAnnotation.h
//  IziPass
//
//  Created by Martin Guillon on 10/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "GLMItemWrapper.h"

@interface GLMAnnotation : NSObject
    <MKAnnotation>
{
	NSString	*mTitle;
	NSString	*mSubtitle;
	id<GLMItemWrapper> mItem;
    CLLocationCoordinate2D coordinate;
    UIImage* _image;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property (nonatomic, retain) id<GLMItemWrapper> item;
@property (nonatomic, retain) UIImage* image;

// add an init method so you can set the coordinate property on startup
- (id) initWithCoordinate:(CLLocationCoordinate2D)coord title:(NSString*) title;
- (id) initWithCoordinate:(CLLocationCoordinate2D)coord title:(NSString*)title subtitle:(NSString*)subtitle;


@end
