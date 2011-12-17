

#import "GLMGeoViewController.h"

#import <CoreLocation/CoreLocation.h>

#import "LocationManager.h"

@implementation GLMGeoViewController
@synthesize toolbarLabel = _toolbarLabel;

#pragma mark -
#pragma mark Custom Methods

- (void)chooseLocationButtonPressed
{
    //invoque action sheet
    UIActionSheet* actionShit = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Annuler", @"Action sheet cancel button") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Autour de vous", @"Action sheet around you"),NSLocalizedString(@"Autour d'une adresse", @"Action sheet around address"), nil];
    [actionShit showFromBarButtonItem:self.navigationItem.leftBarButtonItem animated:YES];
    [actionShit release];
}

#pragma mark -
#pragma mark Action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: {
            //around me
            [[LocationManager sharedInstance] goToCurrentLocation];
            break;
        }
        case 1: {
            //around adress
            [[LocationManager sharedInstance] chooseCustomLocation];
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
    if ([keyPath isEqualToString:@"currentLocation"]
        || [keyPath isEqualToString:@"customLocation"]) {
        [self performSelector :@selector(refreshData)
                   withObject :nil
                   afterDelay :3.0];
    }
    else if ([keyPath isEqualToString:@"currentPlacemark"]
             || [keyPath isEqualToString:@"customPlacemark"]) 
    {
        [self refreshData];
    } else
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
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
    //set navigation left button  (loc icon)
    TTButton *button = [TTButton buttonWithStyle:@"toolbarButton:"]; 
    button.frame = TTSTYLEVAR(toolbarButtonFrame);
    [button setImage:@"bundle://NavigationBar.bundle/geoloc.png" forState:UIControlStateNormal];
    [button setImage:@"bundle://NavigationBar.bundle/geoloc_on.png" forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(chooseLocationButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [items addObject:[[[UIBarButtonItem alloc] initWithCustomView:button] autorelease]];
    
    _toolbarLabel = [[[TTLabel alloc] initWithText:@"Test"] autorelease];
    [items addObject:[[[UIBarButtonItem alloc] initWithCustomView:_toolbarLabel] autorelease]];
    
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
    [self fillToolbar];
	    
    if (kNavMode == 0) //tabbar
    {
        //set navigation left button  (loc icon)
        TTButton *button = [TTButton buttonWithStyle:@"toolbarButton:"]; 
        button.frame = TTSTYLEVAR(toolbarButtonFrame);
        [button setImage:@"bundle://NavigationBar.bundle/geoloc.png" forState:UIControlStateNormal];
        [button setImage:@"bundle://NavigationBar.bundle/geoloc_on.png" forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(chooseLocationButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    }
    else
    {
        //set navigation left button  (loc icon)
        TTButton *button = [TTButton buttonWithStyle:@"toolbarBackButton:" title:@"Portail"]; 
        button.frame = TTSTYLEVAR(toolbarBackButtonFrame);
        [button addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    }
        
    if ([LocationManager sharedInstance].customPlacemark) {
        [self observeValueForKeyPath:@"customPlacemark" ofObject:nil change:nil context:nil];
    }
    else if ([LocationManager sharedInstance].currentPlacemark)
    {
        [self observeValueForKeyPath:@"currentPlacemark" ofObject:nil change:nil context:nil];
    }
    else
    {
        [self performSelector :@selector(refreshData)
                   withObject :nil
                   afterDelay :1.0];
    }
    
}

- (void) goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) updateCurrentLocation{
	
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
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
    [[LocationManager sharedInstance] removeObserver:self forKeyPath:@"currentLocation"];
	[[LocationManager sharedInstance] removeObserver:self forKeyPath:@"currentPlacemark"];
    [[LocationManager sharedInstance] removeObserver:self forKeyPath:@"customLocation"];
    [[LocationManager sharedInstance] removeObserver:self forKeyPath:@"customPlacemark"];
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
