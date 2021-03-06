

#import "GLMGeoViewController.h"

#import <CoreLocation/CoreLocation.h>

#import "LocationManager.h"
#import "IPGeoLocFindViewController.h"

@implementation GLMGeoViewController
@synthesize toolbarLabel = _toolbarLabel;
@synthesize geolocButton = _geolocButton;

#pragma mark -
#pragma mark Custom Methods

- (void)chooseLocationButtonPressed
{
    //invoque action sheet
    UIActionSheet* actionShit = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Around You", @"Action sheet around you"),NSLocalizedString(@"Around an address", @"Action sheet around address"), nil];
    [actionShit showFromBarButtonItem:_geolocButton animated:YES];
    [actionShit release];
}

#pragma mark -
#pragma mark Action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: {
            //around me
            UIActivityIndicatorView* view = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
            [view startAnimating];
            
            view.frame = CGRectMake(14, 6,  self.geolocButton.customView.width - 28, self.geolocButton.customView.height - 12);
            [self.geolocButton.customView addSubview:view];
            [(TTButton*)self.geolocButton.customView setImage:nil forState:UIControlStateNormal];
            [(TTButton*)self.geolocButton.customView setImage:nil forState:UIControlStateHighlighted];
            [(TTButton*)self.geolocButton.customView removeTarget:self action:@selector(chooseLocationButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            
//            [LoadingManager showLoading];
            [[LocationManager sharedInstance] goToCurrentLocation];
            break;
        }
        case 1: {
            //around adress
            [[LocationManager sharedInstance] chooseCustomLocationFromController:self];
            break;
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark Key Value Observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
//    BOOL hideLoading = YES;
    [self.geolocButton.customView removeAllSubviews];
    [(TTButton*)self.geolocButton.customView setImage:@"bundle://NavigationBar.bundle/geoloc.png" forState:UIControlStateNormal];
    [(TTButton*)self.geolocButton.customView setImage:@"bundle://NavigationBar.bundle/geoloc_on.png" forState:UIControlStateHighlighted];
    [(TTButton*)self.geolocButton.customView addTarget:self action:@selector(chooseLocationButtonPressed) forControlEvents:UIControlEventTouchUpInside];

    if ([keyPath isEqualToString:@"currentLocation"]
        || [keyPath isEqualToString:@"customLocation"]) {
//        [self performSelector :@selector(refreshData)
//                   withObject :nil
//                   afterDelay :3.0];
//        hideLoading = NO;
        [self refreshData];
    }
    else if ([keyPath isEqualToString:@"currentPlacemark"]
             || [keyPath isEqualToString:@"customPlacemark"]) 
    {
//        hideLoading = NO;
//       [self refreshData];
    } 
    else
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    if (hideLoading)
//        [LoadingManager hideLoading];
}

#pragma mark -
#pragma mark UIViewController Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}

-(void) fillToolbar
{
    NSMutableArray *items = [NSMutableArray array];  
    [items addObject:_geolocButton];
//    _toolbarLabel = [[[TTLabel alloc] initWithText:@"Test"] autorelease];
//    [items addObject:[[[UIBarButtonItem alloc] initWithCustomView:_toolbarLabel] autorelease]];
    
    [items addObject:[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace   
                                                                  target:self action:nil] autorelease]];  
    [self setToolbarItems:items];
    
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    [[LocationManager sharedInstance] addObserver:self forKeyPath:@"currentLocation" options:NSKeyValueObservingOptionNew context:nil];
	[[LocationManager sharedInstance] addObserver:self forKeyPath:@"currentPlacemark" options:NSKeyValueObservingOptionNew context:nil];
    [[LocationManager sharedInstance] addObserver:self forKeyPath:@"customLocation" options:NSKeyValueObservingOptionNew context:nil];
	[[LocationManager sharedInstance] addObserver:self forKeyPath:@"customPlacemark" options:NSKeyValueObservingOptionNew context:nil];
    
	[super viewDidLoad];
    
    TTButton* button = [TTButton buttonWithStyle:@"toolbarButton:"]; 
    button.frame = TTSTYLEVAR(toolbarButtonFrame);
    [button setImage:@"bundle://NavigationBar.bundle/geoloc.png" forState:UIControlStateNormal];
    [button setImage:@"bundle://NavigationBar.bundle/geoloc_on.png" forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(chooseLocationButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.geolocButton = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    
	    
    if (kNavMode == 0) //tabbar
    {
        //set navigation left button  (loc icon)

        self.navigationItem.leftBarButtonItem = self.geolocButton;
    }
    else
    {
        [self fillToolbar];
    }
        
    if ([LocationManager sharedInstance].customPlacemark) {
        [self observeValueForKeyPath:@"customPlacemark" ofObject:nil change:nil context:nil];
    }
    else if ([LocationManager sharedInstance].currentPlacemark)
    {
        [self observeValueForKeyPath:@"currentPlacemark" ofObject:nil change:nil context:nil];
    }
//    else
//    {
//        [self performSelector :@selector(refreshData)
//                   withObject :nil
//                   afterDelay :1.0];
//    }
    [self refreshData];
    
}

- (void) goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) updateCurrentLocation{
	
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
    if (kNavMode == 1) //launcher
    {
        [self.navigationController setToolbarHidden:NO animated:animated];
    }
}

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

-(void)cleanup
{
    TT_RELEASE_SAFELY(_geolocButton);

    @try{
        [[LocationManager sharedInstance] removeObserver:self forKeyPath:@"currentLocation"];
        [[LocationManager sharedInstance] removeObserver:self forKeyPath:@"currentPlacemark"];
        [[LocationManager sharedInstance] removeObserver:self forKeyPath:@"customLocation"];
        [[LocationManager sharedInstance] removeObserver:self forKeyPath:@"customPlacemark"];
    }@catch(id anException){
        //do nothing, obviously it wasn't attached because an exception was thrown
    }
    [super cleanup];
}

- (void)viewDidUnload {
	[self cleanup];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) awakeFromNib {
}

#pragma mark -
#pragma mark Memory Management

- (void)dealloc {
	[self cleanup];
    [super dealloc];
}

@end
