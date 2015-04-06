
#import <UIKit/UIKit.h>
@class MBProgressHUD;

@interface FKViewController : UIViewController<UIPickerViewDataSource
	, UIPickerViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>

{
    
 NSDictionary* code;
 NSMutableArray *_buttons;  //


}


@property(nonatomic,retain)MBProgressHUD *HUD;

@property(nonatomic,copy)NSString *string;
@property (strong, nonatomic) IBOutlet UIPickerView *picker;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIView *editorBar;
@property (nonatomic ,retain) UIButton *sendImageButton;

@property (nonatomic ,retain)UIImage *image;  
- (IBAction)upload:(id)sender;
@end
