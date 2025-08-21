#import "RightPanelViewController.h"
#import "authenticator/BaseAuthenticator.h"
#import "AccountListViewController.h"
#import "LauncherProfilesViewController.h"
#import "LauncherNavigationController.h"
#import "LauncherSplitViewController.h"
#import "UIButton+AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "utils.h"

@interface RightPanelViewController ()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *accountTypeLabel;
@property (nonatomic, strong) UIButton *launchButton;
@property (nonatomic, strong) UIButton *profilesButton;
@property (nonatomic, strong) UIButton *accountButton;

@end

@implementation RightPanelViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:20/255.0 green:80/255.0 blue:40/255.0 alpha:1.0];

    // Account Button (replaces old account menu)
    self.accountButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.accountButton addTarget:self action:@selector(selectAccount:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.accountButton];

    self.avatarImageView = [[UIImageView alloc] init];
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.avatarImageView.layer.cornerRadius = 50;
    self.avatarImageView.clipsToBounds = YES;
    [self.accountButton addSubview:self.avatarImageView];

    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:18];
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.accountButton addSubview:self.nameLabel];

    self.accountTypeLabel = [[UILabel alloc] init];
    self.accountTypeLabel.font = [UIFont systemFontOfSize:14];
    self.accountTypeLabel.textColor = [UIColor whiteColor];
    self.accountTypeLabel.textAlignment = NSTextAlignmentCenter;
    [self.accountButton addSubview:self.accountTypeLabel];

    // Launch Button
    self.launchButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.launchButton setTitle:localize(@"launcher.menu.launch", nil) forState:UIControlStateNormal];
    [self.launchButton addTarget:self action:@selector(launchGameAction:) forControlEvents:UIControlEventTouchUpInside];
    self.launchButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.launchButton.backgroundColor = [UIColor systemGreenColor];
    self.launchButton.tintColor = [UIColor whiteColor];
    self.launchButton.layer.cornerRadius = 10;
    [self.view addSubview:self.launchButton];

    // Profiles Button
    self.profilesButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.profilesButton setTitle:localize(@"launcher.menu.profiles", nil) forState:UIControlStateNormal];
    [self.profilesButton addTarget:self action:@selector(profilesAction) forControlEvents:UIControlEventTouchUpInside];
    self.profilesButton.titleLabel.font = [UIFont systemFontOfSize:16];
    self.profilesButton.backgroundColor = [UIColor systemGray2Color];
    self.profilesButton.tintColor = [UIColor whiteColor];
    self.profilesButton.layer.cornerRadius = 10;
    [self.view addSubview:self.profilesButton];

    [self setupConstraints];
    [self updateAccountInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAccountInfo) name:@"AccountChanged" object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (LauncherNavigationController *)contentNavigationController {
    return (LauncherNavigationController *)self.splitViewController.viewControllers[0];
}

- (void)setupConstraints {
    self.accountButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.avatarImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.accountTypeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.launchButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.profilesButton.translatesAutoresizingMaskIntoConstraints = NO;

    [NSLayoutConstraint activateConstraints:@[        // Account Button centered in the view
        [self.accountButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.accountButton.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [self.accountButton.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:0.8],

        // Avatar
        [self.avatarImageView.topAnchor constraintEqualToAnchor:self.accountButton.topAnchor],
        [self.avatarImageView.centerXAnchor constraintEqualToAnchor:self.accountButton.centerXAnchor],
        [self.avatarImageView.widthAnchor constraintEqualToConstant:100],
        [self.avatarImageView.heightAnchor constraintEqualToConstant:100],

        // Name Label
        [self.nameLabel.topAnchor constraintEqualToAnchor:self.avatarImageView.bottomAnchor constant:8],
        [self.nameLabel.leadingAnchor constraintEqualToAnchor:self.accountButton.leadingAnchor],
        [self.nameLabel.trailingAnchor constraintEqualToAnchor:self.accountButton.trailingAnchor],

        // Account Type Label
        [self.accountTypeLabel.topAnchor constraintEqualToAnchor:self.nameLabel.bottomAnchor constant:4],
        [self.accountTypeLabel.leadingAnchor constraintEqualToAnchor:self.accountButton.leadingAnchor],
        [self.accountTypeLabel.trailingAnchor constraintEqualToAnchor:self.accountButton.trailingAnchor],
        [self.accountTypeLabel.bottomAnchor constraintEqualToAnchor:self.accountButton.bottomAnchor],

        // Profiles button at the bottom
        [self.profilesButton.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-20],
        [self.profilesButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.profilesButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [self.profilesButton.heightAnchor constraintEqualToConstant:50],

        // Launch button above profiles button
        [self.launchButton.bottomAnchor constraintEqualToAnchor:self.profilesButton.topAnchor constant:-10],
        [self.launchButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.launchButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [self.launchButton.heightAnchor constraintEqualToConstant:50],
    ]];
}

- (void)updateAccountInfo {
    NSDictionary *selected = BaseAuthenticator.current.authData;

    if (selected == nil) {
        self.nameLabel.text = localize(@"login.option.select", nil);
        self.accountTypeLabel.text = @"";
        self.avatarImageView.image = [UIImage imageNamed:@"DefaultAccount"];
        return;
    }

    BOOL isDemo = [selected[@"username"] hasPrefix:@"Demo."];
    self.nameLabel.text = [selected[@"username"] substringFromIndex:(isDemo ? 5 : 0)];

    if (isDemo) {
        self.accountTypeLabel.text = localize(@"login.option.demo", nil);
    } else if (selected[@"xboxGamertag"] == nil) {
        self.accountTypeLabel.text = localize(@"login.option.local", nil);
    } else {
        self.accountTypeLabel.text = selected[@"xboxGamertag"];
    }

    NSURL *url = [NSURL URLWithString:[selected[@"profilePicURL"] stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"]];
    [self.avatarImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"DefaultAccount"]];
}

- (void)selectAccount:(UIButton *)sender {
    AccountListViewController *vc = [[AccountListViewController alloc] init];
    vc.whenDelete = ^void(NSString* name) {
        if ([name isEqualToString:getPrefObject(@"internal.selected_account")]) {
            BaseAuthenticator.current = nil;
            setPrefObject(@"internal.selected_account", @"");
            [self updateAccountInfo];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AccountChanged" object:nil];
        }
    };
    vc.whenItemSelected = ^void() {
        setPrefObject(@"internal.selected_account", BaseAuthenticator.current.authData[@"username"]);
        [self updateAccountInfo];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AccountChanged" object:nil];
    };
    vc.modalPresentationStyle = UIModalPresentationPopover;
    vc.preferredContentSize = CGSizeMake(350, 250);

    UIPopoverPresentationController *popoverController = vc.popoverPresentationController;
    popoverController.sourceView = sender;
    popoverController.sourceRect = sender.bounds;
    popoverController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)launchGameAction:(UIButton *)sender {
    [[self contentNavigationController] launchMinecraft:sender];
}

- (void)profilesAction {
    LauncherProfilesViewController *profilesVC = [[LauncherProfilesViewController alloc] init];
    [[self contentNavigationController] pushViewController:profilesVC animated:YES];
}

@end
