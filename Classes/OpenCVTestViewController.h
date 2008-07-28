#import <UIKit/UIKit.h>

@interface OpenCVTestViewController : UIViewController {
	IBOutlet UIImageView *imageView;
}

- (IBAction)loadImage:(id)sender;
- (IBAction)edgeDetect:(id)sender;

@property (nonatomic, retain) UIImageView *imageView;
@end