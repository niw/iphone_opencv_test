#import <UIKit/UIKit.h>

@class OpenCVTestViewController;

@interface OpenCVTestAppDelegate : NSObject <UIApplicationDelegate> {
    IBOutlet UIWindow *window;
    IBOutlet OpenCVTestViewController *viewController;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) OpenCVTestViewController *viewController;
@end