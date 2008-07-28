#import <UIKit/UIKit.h>

@interface OpenCVTestViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
	IBOutlet UIImageView *imageView;
}

- (IBAction)loadImage:(id)sender;
- (IBAction)edgeDetect:(id)sender;
- (IBAction)faceDetect:(id)sender;

@property (nonatomic, retain) UIImageView *imageView;
@end