
#import "GLMViewController.h"

@interface GLMGeoViewController : GLMViewController<UIActionSheetDelegate>
{
    TTLabel* _toolbarLabel;
}
@property(nonatomic, retain) TTLabel *toolbarLabel;
-(void) fillToolbar;
@end
