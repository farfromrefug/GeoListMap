//
//  PartnerMapViewController.h
//  IziPass
//
//  Created by Christophe on 21/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "GLMItemWrapper.h"
#import "MKMapView+Extension.h"

#define kMapDefaultSpanDelta		0.5

@interface GLMMapViewController : UIViewController <MKMapViewDelegate>
{
    MKMapView*                  _mapView;
	NSArray*					mItemsList;
    
    BOOL _zoomFitWithCurrentLocation;
}
@property (nonatomic, assign) MKMapView* mapView;
@property (nonatomic) BOOL zoomFitWithCurrentLocation;

- (void)refreshMapAnnotations;

//-(void)zoomToFitMapAnnotations;
- (id)initWithItemsList:(NSArray*)itemsList;
- (id)initWithItem:(id<GLMItemWrapper>)item;

- (void)setItemsList:(NSArray*)itemsList;
- (void)cleanup;

@end
