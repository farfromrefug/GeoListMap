
#define kListMode			0
#define kMapMode			1

@class GLMMapViewController;

@class LoadingViewController;
@interface GLMViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource, TTURLRequestDelegate>
{

    IBOutlet UITableView*		mTableView;
    
    IBOutlet UIView*            mNoResultView;
	
	GLMMapViewController*		mMapViewController;
	
	NSMutableArray*				mTableData;
	        
    NSInteger _currentDisplayMode;
    
    IBOutlet UIImageView* mBgImageView;
    	
    IBOutlet UIView *mContainer;
    LoadingViewController* mLoadingViewController;
    
    UIBarButtonItem* _mapListButton;
}
@property(nonatomic, retain) UIBarButtonItem* mapListButton;

- (void)setDisplayMode:(NSInteger)mode;
- (void) switchDisplayMode;
- (void) refreshData;
- (void) refreshAfterData;
- (void)cleanup;
- (Class)classForMapController;

@end
