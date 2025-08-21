#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LauncherMenuCustomItem : NSObject
@property(nonatomic) NSString *title, *imageName;
@property(nonatomic, copy) void (^action)(void);
@property(nonatomic) NSArray<UIViewController *> *vcArray;
@end

@interface LauncherMenuViewController : UITableViewController

@end

NS_ASSUME_NONNULL_END
