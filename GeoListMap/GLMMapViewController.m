//
//  GL_mapViewController.m
//  IziPass
//
//  Created by Christophe on 21/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GLMMapViewController.h"
#import "GLMAnnotation.h"
#import "CustomTitleView.h"

@interface GLMMapViewController (Private)
- (void)refreshMapAnnotations;
-(void)_init;
@end


@implementation GLMMapViewController
@synthesize  mapView = _mapView;
@synthesize zoomFitWithCurrentLocation = _zoomFitWithCurrentLocation;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self)
	{
		// Custom initialization.
        [self _init];
	}
	return self;
}

- (id)initWithItemsList:(NSArray*)itemsList
{
	self = [super initWithNibName:nil bundle:nil];
	if (self)
	{
		// Custom initialization.
        [self _init];
		mItemsList = [itemsList retain];
	}
	return self;
}

- (id)initWithItem:(id<GLMItemWrapper>)item
{
	self = [super initWithNibName:nil bundle:nil];
	if (self)
	{
		// Custom initialization.
        [self _init];
        mItemsList = [[NSArray arrayWithObject:item] retain];

	}
	return self;
}

-(void)_init
{
    mItemsList = nil;
    _zoomFitWithCurrentLocation = NO;
    _mapView = [[MKMapView alloc] init];
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _mapView.delegate = self;
    [_mapView setUserTrackingMode:MKUserTrackingModeNone];
}

- (void)setItemsList:(NSArray*)itemsList
{
	if (mItemsList != nil)
	{
		[mItemsList release];
		mItemsList = nil;
	}
	
	mItemsList = [itemsList retain];
	
	
	[self refreshMapAnnotations];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
	[super viewDidLoad];
        
    self.navigationItem.titleView = [[[CustomTitleView alloc] initWithTitle:NSLocalizedString(@"Map", nil) ] autorelease];
    _mapView.frame = self.view.bounds;
    [self.view addSubview:_mapView];

    
    //Create the custom back button
//    TTButton *button = [TTButton buttonWithStyle:@"toolbarBackButton:" title:@"Retour"]; 
//    button.frame = TTSTYLEVAR(toolbarBackButtonFrame);
//    [button addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
	CLLocationCoordinate2D franceCenterCoordinate;
	franceCenterCoordinate.latitude = kFranceCenterLatitude;
	franceCenterCoordinate.longitude = kFranceCenterLongitude;
	
	MKCoordinateRegion region = MKCoordinateRegionMake(franceCenterCoordinate, MKCoordinateSpanMake(kFranceCenterSpan, kFranceCenterSpan));
	[_mapView setRegion:region];
	
	[self refreshMapAnnotations];
}

- (void) goBack
{    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    //set navgation bar image
//    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
//    appDelegate.titleBarType = kBarHome;
//    [self.navigationController.navigationBar setNeedsDisplay];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    //set navgation bar image
    //    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    //    appDelegate.titleBarType = kBarHome;
    //    [self.navigationController.navigationBar setNeedsDisplay];
}


-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self zoomToFitMapAnnotations];
    for(NSObject<MKAnnotation>* annotation in [_mapView selectedAnnotations])
    {
        [_mapView deselectAnnotation:annotation animated:NO];
        [_mapView selectAnnotation:annotation animated:YES];
    }
    
}

#pragma mark -
#pragma mark Memory Management Methods
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
	[self cleanup];
	[super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

-(void)cleanup
{ 
    [_mapView release];
}

- (void)dealloc
{
	[self cleanup];
	[super dealloc];
}

- (void)zoomToUserLocation
{
    if (!_mapView.userLocation || _mapView.userLocationVisible)
        return;
    
    MKCoordinateRegion region;
    region.center = _mapView.userLocation.location.coordinate;
    region.span = MKCoordinateSpanMake(2.0, 2.0);
    region = [self.mapView regionThatFits:region];
    [self.mapView setRegion:region animated:YES];
}

-(void)zoomToFitMapAnnotations
{
    DLog(@"nb annot %d", [_mapView.annotations count]);
    if([_mapView.annotations count] == 0 || ( _mapView.userLocation && [_mapView.annotations count] == 1))
    {
        
        if (_mapView.userLocation != nil)
            [self zoomToUserLocation];
        return; 
    }
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(NSObject<MKAnnotation>* annotation in _mapView.annotations)
    {
        if (!_zoomFitWithCurrentLocation && [annotation isKindOfClass:[ MKUserLocation class]])
            continue;
        
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = ([_mapView.annotations count] == 1)? kMapDefaultSpanDelta:fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.3; // Add a little extra space on the sides
    region.span.longitudeDelta = ([_mapView.annotations count] == 1)? kMapDefaultSpanDelta:fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.3; // Add a little extra space on the sides
    
    region = [_mapView regionThatFits:region];
    [_mapView setRegion:region animated:YES];
}
#pragma mark -
#pragma mark Map Custom Methods
- (void)refreshMapAnnotations
{	
	
	// remove all current annotations
	NSMutableArray* annotationToRemove = [NSMutableArray arrayWithCapacity:0];
	for (NSObject<MKAnnotation>* annotation in [_mapView annotations])
	{
		if ([annotation isKindOfClass:[GLMAnnotation class]])
		{
			[annotationToRemove addObject:annotation];
		}
	}
	[_mapView removeAnnotations:annotationToRemove];
    
	for (id<GLMItemWrapper> item in mItemsList)
	{
        if (!item) continue;
        
        CLLocationCoordinate2D coord;
        coord.longitude = item.coordinate.longitude;
        coord.latitude = item.coordinate.latitude;
        GLMAnnotation* annot = [[GLMAnnotation alloc] initWithCoordinate:coord title:item.title subtitle:item.subtitle];
        annot.item = item;
        
        if (![[_mapView annotations] containsObject:annot])
        {
            [_mapView addAnnotation:annot];
        }
	}
    
    [self zoomToFitMapAnnotations];
}

#pragma mark -
#pragma mark Map View Delegate Methods
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    [_mapView selectAnnotation:[[_mapView annotations] objectAtIndex:0] animated:NO];
}

//- (void) mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
//    
//    CGRect visibleRect = [mapView annotationVisibleRect]; 
//    
//    for (MKAnnotationView *view in views) {
//        CGRect endFrame = view.frame;
//        
//        CGRect startFrame = endFrame;
//        startFrame.origin.y = visibleRect.origin.y - startFrame.size.height;
//        view.frame = startFrame;
//        
//        [UIView beginAnimations:@"drop" context:NULL]; 
//        [UIView setAnimationDuration:1];
//        
//        view.frame = endFrame;
//        
//        [UIView commitAnimations];
//    } // end of for 
//} // end of delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	static NSString* annotationViewId = @"AnnotationView";
	MKPinAnnotationView* annotationView = nil;
	
	
	
	if( [annotation isKindOfClass:[GLMAnnotation class]])
	{
        annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationViewId];
        
		if (annotationView == nil) 
		{
			annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewId] autorelease];
		}
		
		annotationView.canShowCallout = YES;
		
		UIButton* pickUpButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		[pickUpButton setFrame:CGRectMake(0, 0, 30, 30) ];
		annotationView.rightCalloutAccessoryView = pickUpButton;
        
        if (((GLMAnnotation*)annotation).image)
        {
            UIImageView *imgView = [[UIImageView alloc] initWithImage:((GLMAnnotation*)annotation).image];
            annotationView.leftCalloutAccessoryView = imgView;
            [imgView release];
        }
		
		annotationView.pinColor = MKPinAnnotationColorGreen;
	}
	
	
	return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if (![view.annotation isKindOfClass:[GLMAnnotation class]]) {
        DLog(@"view.annotation is not an PartnerWrapper: %@", view.annotation);
        return;
    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [self zoomToFitMapAnnotations];
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    DLog(@"regionWillChangeAnimated:");
}

@end
