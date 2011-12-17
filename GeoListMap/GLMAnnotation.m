//
//  GLMAnnotation.m
//  IziPass
//
//  Created by Martin Guillon on 10/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GLMAnnotation.h"

@implementation GLMAnnotation
@synthesize title = mTitle;
@synthesize subtitle = mSubtitle;
@synthesize item = mItem;
@synthesize image = _image;
@synthesize coordinate;

- (id) initWithCoordinate:(CLLocationCoordinate2D)coord title:(NSString *)title
{
    self = [super init];
    
    if (self != nil)
    {
        coordinate = coord;
        mTitle = [title retain];
    }
    return self;
}

- (id) initWithCoordinate:(CLLocationCoordinate2D)coord title:(NSString *)title subtitle:(NSString *)subtitle
{
    self = [super init];
    
    if (self != nil)
    {
        coordinate = coord;
        mTitle = [title retain];
        mSubtitle = [subtitle retain];
    }
    return self;
}

-(void)dealloc
{
    [_image release];
    [mTitle release];
    [mSubtitle release];
    [mItem release];
    [super dealloc];
}
@end
