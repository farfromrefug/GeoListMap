
#import "GLMViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "GLMItemWrapper.h"
#import "GLMMapViewController.h"

#import "LoadingViewController.h"
#import "CustomTitleView.h"

@interface GLMViewController ()
@end

@implementation GLMViewController


//#pragma mark -
//#pragma mark CBCTabDelegate
//
//- (void)willSelectTab:(BCTab *) tabButton
//{
//    if ([[[TTNavigator navigator] visibleViewController] isEqual:self]
//        && _currentDisplayMode == kMapMode)
//    {
//        [self switchDisplayMode];
//    }
//}

#pragma mark -
#pragma mark Custom Methods

- (void)setDisplayMode:(NSInteger)mode animated:(BOOL)animated {
    if (mode == _currentDisplayMode)
        return;
    
    switch (mode) {
        case kMapMode:
        {
//            mBgImageView.alpha = 0;
            
            
            CATransform3D transform;
            
            if (animated) {
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.5];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            }
                
            transform = mMapViewController.view.layer.transform;
            transform = CATransform3DRotate(transform, M_PI, 0, 1, 0);
            mMapViewController.view.layer.transform = transform;
            
            transform = mTableView.layer.transform;
            transform = CATransform3DRotate(transform, M_PI, 0, 1, 0);
            mTableView.layer.transform = transform;
            
            
            
            [mContainer bringSubviewToFront:mMapViewController.view];
            [mContainer bringSubviewToFront:mLoadingViewController.view];
            [mMapViewController viewDidAppear:animated];
            //                [self.view bringSubviewToFront:mNoResultView];
            //				[self.view bringSubviewToFront:mFilterController.view];
            
            if (animated) {
                [UIView commitAnimations];
            }
            
//            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//            button.frame = CGRectMake(0, 0, 43, 35);
//            [button addTarget:self action:@selector(switchDisplayMode) forControlEvents:UIControlEventTouchUpInside];
//            [button setImage:[UIImage imageNamed:@"NavigationBar.bundle/list.png"] forState:UIControlStateNormal];
//            [button setImage:[UIImage imageNamed:@"NavigationBar.bundle/list_on.png"] forState:UIControlStateHighlighted];
//            self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
            
            TTButton *button = (TTButton*)self.navigationItem.rightBarButtonItem.customView; 
            [button setImage:@"bundle://NavigationBar.bundle/list.png" forState:UIControlStateNormal];
            [button setImage:@"bundle://NavigationBar.bundle/list_on.png" forState:UIControlStateHighlighted];
            
            break;
        }
        case kListMode:
        {
            
            CATransform3D transform;
            
            if (animated) {
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.5];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            }
            
            transform = mMapViewController.view.layer.transform;
            transform = CATransform3DRotate(transform, M_PI, 0, -1, 0);
            mMapViewController.view.layer.transform = transform;
            
            transform = mTableView.layer.transform;
            transform = CATransform3DRotate(transform, M_PI, 0, -1, 0);
            mTableView.layer.transform = transform;
            
            [mContainer bringSubviewToFront:mTableView];
            [mContainer bringSubviewToFront:mLoadingViewController.view];
            //                [self.view bringSubviewToFront:mNoResultView];
            //                [self.view bringSubviewToFront:mFilterController.view];
            
            if (animated)
                [UIView commitAnimations];
            
//            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//            button.frame = CGRectMake(0, 0, 43, 35);
//            [button addTarget:self action:@selector(switchDisplayMode) forControlEvents:UIControlEventTouchUpInside];
//            [button setImage:[UIImage imageNamed:@"NavigationBar.bundle/map.png"] forState:UIControlStateNormal];
//            [button setImage:[UIImage imageNamed:@"NavigationBar.bundle/map_on.png"] forState:UIControlStateHighlighted];
//            self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
            TTButton *button = (TTButton*)self.navigationItem.rightBarButtonItem.customView; 
            [button setImage:@"bundle://NavigationBar.bundle/map.png" forState:UIControlStateNormal];
            [button setImage:@"bundle://NavigationBar.bundle/map_on.png" forState:UIControlStateHighlighted];
            
//            [self performSelector:@selector(showBg) withObject:nil afterDelay:0.4];
            
            break;
        }
        default:
            break;
    }
    _currentDisplayMode = mode;
}

- (void)setDisplayMode:(NSInteger)mode{
    [self setDisplayMode:mode animated:mNoResultView.hidden];
}
//
- (void) switchDisplayMode
{
    switch (_currentDisplayMode) {
        case kMapMode:
        {
            [self setDisplayMode:kListMode animated:mNoResultView.hidden];
            break;
        }
        case kListMode:
        {
            [self setDisplayMode:kMapMode animated:mNoResultView.hidden];
            break;
        }
        default:
            break;
    }
}

- (void)showBg {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    mBgImageView.alpha = 1;
    [UIView commitAnimations];
}

- (void) refreshData {
    
}

- (void) refreshAfterData 
{
    [mMapViewController setItemsList:mTableData];
    [mTableView reloadData];
    
    BOOL noresult = [mTableData count] <= 0;
    
    mNoResultView.hidden = !noresult;
    mMapViewController.view.hidden = noresult;
    mTableView.hidden = noresult;
    [self.navigationItem.rightBarButtonItem setEnabled:!noresult];
}

#pragma mark -
#pragma mark TTURLRequest delegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidStartLoad:(TTURLRequest*)request {
    [mLoadingViewController showLoading];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidFinishLoad:(TTURLRequest*)request {
    [mLoadingViewController hideLoading];
}

- (void)requestDidCancelLoad:(TTURLRequest*)request{
    [request release];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {
    mNoResultView.hidden = !([mTableData count] <= 0);
    [mLoadingViewController hideLoading];
}

#pragma mark -
#pragma mark BCTabBar additions
//
//- (NSString *)iconImageNameForURL:(NSString *) url {
//    return @"BCTabBarController.bundle/tab_offres.png";
//}
//
//- (NSString *)selectedIconImageNameSuffix
//{
//    return @"_on";
//}
//
//- (UIViewContentMode)imageContentModeForURL:(NSString *) url
//{
////    if ([url isEqualToString:kURLList])
////        return UIViewContentModeRight;
////    else
////        return UIViewContentModeLeft;
//    return UIViewContentModeCenter;
//}



#pragma mark -
#pragma mark UIViewController Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    _currentDisplayMode = kListMode;
    
	[super viewDidLoad];
	
	mMapViewController = [[GLMMapViewController alloc] initWithItemsList:mTableData];
	
	
	CALayer *layer = mMapViewController.view.layer;
	CATransform3D transform = layer.transform;
	transform = CATransform3DRotate(transform, M_PI, 0, 1, 0);
	
	mMapViewController.view.layer.transform = transform;
	
	mMapViewController.view.layer.doubleSided = NO;
    
	[mMapViewController.view setHidden:YES];
	
	[mContainer addSubview:mMapViewController.view];
	mMapViewController.view.frame = mContainer.bounds;
	
	mTableView.layer.doubleSided = NO;
	
	[mContainer bringSubviewToFront:mTableView];
//    [mContainer bringSubviewToFront:mNoResultView];
    mNoResultView.hidden = !([mTableData count] <= 0);
    
    mLoadingViewController = [[[LoadingViewController alloc] init] retain];
    [mContainer addSubview:mLoadingViewController.view];
    [mLoadingViewController hideLoading];
    
    self.navigationItem.titleView = [[[CustomTitleView alloc] initWithTitle:@"ListMap"] autorelease];

        
    TTButton *button = [TTButton buttonWithStyle:@"toolbarButton:"]; 
    button.frame = TTSTYLEVAR(toolbarButtonFrame);
    [button setImage:@"bundle://NavigationBar.bundle/map.png" forState:UIControlStateNormal];
    [button setImage:@"bundle://NavigationBar.bundle/map_on.png" forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(switchDisplayMode) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [mMapViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [mMapViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
	[mTableData release];
	[mMapViewController release];
    
    [mLoadingViewController release];
    mLoadingViewController = nil;
    [mContainer release];
    mContainer = nil;
    [super viewDidUnload];
}

- (void) awakeFromNib {
}

#pragma mark -
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [mTableData count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat) tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 85;
}

#pragma mark -
#pragma mark RefreshableTableViewHolder Methods

- (void)refreshCellAtIndexPath:(NSIndexPath *)_indexPath {
    if (_indexPath) {
        if (_indexPath.section == 0 && _indexPath.row < [mTableData count]) {
            @try {
                [self performSelectorOnMainThread:@selector(reloadRowsAtIndexPaths:) withObject:[NSArray arrayWithObject:_indexPath] waitUntilDone:NO];
            }
            @catch (NSException * e) {
                NSLog(@"Error reloading table, ignored: %@", e);
                [mTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            }
        }
    }
}

- (void)reloadRowsAtIndexPaths:(NSArray *)arr {
    [mTableView reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark -
#pragma mark Memory Management

-(void)cleanup
{
    TT_RELEASE_SAFELY(mTableView); 
    TT_RELEASE_SAFELY(mTableData); 
    TT_RELEASE_SAFELY(mNoResultView); 
    TT_RELEASE_SAFELY(mLoadingViewController); 
    TT_RELEASE_SAFELY(mContainer); 
}

- (void)dealloc {
    [self cleanup];
    [super dealloc];
}

@end
