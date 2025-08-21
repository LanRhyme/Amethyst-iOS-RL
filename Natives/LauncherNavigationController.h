#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSMutableArray<NSDictionary *> *localVersionList, *remoteVersionList;

@interface LauncherNavigationController : UINavigationController

@property(nonatomic) UIProgressView *progressViewMain, *progressViewSub;
@property(nonatomic) UILabel* progressText;

- (void)enterModInstaller;
- (void)enterCustomControls;
- (void)enterModInstallerWithPath:(NSString *)path hitEnterAfterWindowShown:(BOOL)hitEnter;
- (void)fetchLocalVersionList;
- (void)reloadProfileList;
- (void)setInteractionEnabled:(BOOL)enable forDownloading:(BOOL)downloading;
- (void)launchMinecraft:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
