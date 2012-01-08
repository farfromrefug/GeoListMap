
#import "GLMViewController.h"

@interface GLMGeoViewController : GLMViewController<UIActionSheetDelegate>
{
    TTLabel* _toolbarLabel;
    UIBarButtonItem* _geolocButton;
}
@property(nonatomic, retain) TTLabel *toolbarLabel;
@property(nonatomic, retain) UIBarButtonItem* geolocButton;
-(void) fillToolbar;
@end
