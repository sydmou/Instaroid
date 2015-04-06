

#import "FKViewController.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"

@interface FKViewController ()
{
	NSArray* images;
}
@end
@implementation FKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   UIButton *testButton= (UIButton*)[self.view viewWithTag:1];
    CGRect frame = CGRectMake(0, self.view.bounds.size.height-65, 320, 30);
    testButton.frame=frame;
    
    
    
    UIButton *testButton2= (UIButton*)[self.view viewWithTag:2];
    CGRect frame1 = CGRectMake(0, self.view.bounds.size.height-120, 320, 30);
    testButton2.frame=frame1;
    
    
    
    
    UIImageView *imagebiew=(UIImageView*)[self.view viewWithTag:3];
    CGRect frame2 = CGRectMake(0, testButton.frame.origin.y-280, 320, 200);
    imagebiew.frame=frame2;
    
    //imagebiew.contentMode=UIViewContentModeScaleAspectFill;
    
    
    UIImageView *imagebiew1=(UIImageView*)[self.view viewWithTag:4];
    CGRect frame3 = CGRectMake(85, imagebiew.frame.origin.y-130, 150, 107);
    imagebiew1.frame=frame3;

//    CGFloat y= 10;
//     frame.origin.y = y;
//    //[testButton drawRect:frame];
//    testButton.frame=frame;
    
   // testButton.bounds.origin.y=self.view.bounds.origin.y-50;
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    imgView.frame = self.view.bounds;
    imgView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view insertSubview:imgView atIndex:0];
    
    
    
	self.picker.dataSource = self;
	self.picker.delegate = self;

	//images = @[@"logo", @"java" , @"android"];
       NSLog(@"sand box：%@",NSHomeDirectory());
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{

	return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView
	numberOfRowsInComponent:(NSInteger)component
{
	return images.count;
}
#define kImageTag 1
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:
	(NSInteger)row forComponent:(NSInteger)component
	reusingView:(UIView *)view
{

	
	if(view.tag != kImageTag)
	{
		view = [[UIView alloc] init];
	
		view.tag = kImageTag;

		view.userInteractionEnabled = NO;
		UIImageView* iv = [[UIImageView alloc] initWithImage:
			[UIImage imageNamed:[images objectAtIndex:row]]];
		iv.frame = CGRectMake(0 , 0  , 48 ,48);
		iv.contentMode = UIViewContentModeScaleAspectFit;
		[view addSubview:iv];
	}
	return view;
}

// UIPickerViewDelegate return height
- (CGFloat)pickerView:(UIPickerView *)pickerView
rowHeightForComponent:(NSInteger)component
{
	return 48;
}
// UIPickerViewDelegate return width
- (CGFloat)pickerView:(UIPickerView *)pickerView
	widthForComponent:(NSInteger)component
{
	return 48;
}
- (IBAction)upload:(id)sender
{
    
    
    [self ShowLoading];
    

//	NSInteger selectedRow = [self.picker selectedRowInComponent:0];

//	NSString* fileName = [images objectAtIndex:selectedRow];
//    
//   // NSString* fileName = @"currentImage";
//    NSData*data=UIImageJPEGRepresentation(self.image, 0.3);
    

//	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"image"
//		ofType:@"png"];
 //   NSString *filePath = [[NSBundle mainBundle] pathForResource:@"currentImage"
   NSString *filePath= [ NSString stringWithFormat:@"%@/%@" ,[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"],@"image.png"];
    // ofType:@"png"];
    
    NSLog(@"------slef image%@------",filePath);
    

	NSURL* url = [NSURL URLWithString:
		@"http://instaroid.client.vivaneo.fr/upload"];
	__block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];

	[request setPostValue:@"onther paramètre" forKey:@"name"];

    NSLog(@"------%@---",filePath);
	[request setFile:filePath
	
        withFileName:nil
		andContentType:@"image/png"
		forKey:@"image"];
	
	[request setCompletionBlock:^{
		NSString *responseString = [request responseString];
       NSString *string2 = [responseString substringWithRange:NSMakeRange(9, 4)];
       // code=responseString;
       // NSLog(@"--------------%@-------code",code[]);
		[[[UIAlertView alloc] initWithTitle:@"Votre Code"
			message:string2 delegate:self
			cancelButtonTitle:@"OK" otherButtonTitles:nil]
		 show];
        
       // [self selectImage];
        [self HideLoading];
	}];
    
	// fail
	[request setFailedBlock:^{
		NSError *error = request.error;
		NSLog(@"获取服务器响应出现错误%@" , error);
	}];

	[request startAsynchronous];
}

//select picture
- (void)selectImage
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Fermer" destructiveButtonTitle:@"📷" otherButtonTitles:@"Album De Photos", nil];
    [actionSheet showInView:self.view];
    
}
- (IBAction)selectImage:(id)sender {
    
    
    
    
    
    [self selectImage];
}

#pragma mark --- UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerControllerSourceType sourceType;
    
    if (buttonIndex == 0) {
        //carema
        BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (!isCamera) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"No Carema" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            return;
            
        }
        sourceType =  UIImagePickerControllerSourceTypeCamera;
        
        
    }else if (buttonIndex == 1){
        //blum
        sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
        
    }else if (buttonIndex == 2){
        //cansel
        return;
    }
    //[_textView resignFirstResponder];
    UIImagePickerController *imagePiker = [[UIImagePickerController alloc] init];
    imagePiker.sourceType = sourceType;
   
    imagePiker.delegate = self;
    [self presentModalViewController:imagePiker animated:YES];
    
}
#pragma mark --- UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIButton *testButton= (UIButton*)[self.view viewWithTag:2];
    testButton.hidden=NO;
    NSLog(@"-----%@---",info);
    
    
    
    UIButton *button1 = [_buttons objectAtIndex:0];
    UIButton *button2 = [_buttons objectAtIndex:1];
    
    button1.transform = CGAffineTransformIdentity;
    button2.transform = CGAffineTransformIdentity;
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    self.image = image;
    self.imageView.image=image;
    [picker dismissModalViewControllerAnimated:YES];
  //  NSData *imageData=UIImagePNGRepresentation(self.image);
    NSData*imageData=UIImageJPEGRepresentation(self.image, 0.1);
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];
    
    NSString *fullPathToFile=[documentsDirectory stringByAppendingPathComponent:@"image.png"];
    
    
    
    [imageData writeToFile:fullPathToFile atomically:NO];
    
    
    
    
    NSURL* videoURL = [info valueForKey:UIImagePickerControllerMediaURL];
    
    NSString* videoPath = [videoURL path];
    
    
    NSLog(@"----%@---%@--",videoURL,videoPath);
    
    
    NSString *Path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    
    NSLog(@"----adress---%@",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]);
    
    self.imageView.hidden=NO;
    
    self.string=Path;
    
    
    //add small picture
    if (self.sendImageButton == nil) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        button.frame = CGRectMake(8, 22, 25, 25);
        [button addTarget:self action:@selector(seeBigImageAction) forControlEvents:UIControlEventTouchUpInside];
        
        self.sendImageButton = button;
    }
    [ self.sendImageButton  setImage:self.image forState:UIControlStateNormal];
   // [self.editorBar addSubview:self.sendImageButton];
    
  
    //        UIButton *button1 = [_buttons objectAtIndex:0];
    //        UIButton *button2 = [_buttons objectAtIndex:1];
    [UIView animateWithDuration:1 animations:^{
        
        button1.transform = CGAffineTransformTranslate(button1.transform, 20, 0);
        button2.transform = CGAffineTransformTranslate(button2.transform, 5, 0);
        
    }];
    [picker dismissModalViewControllerAnimated:YES];
    
 //   [_textView becomeFirstResponder];
}

#pragma mark--loader pour faire patienter l'utilisateur

-(void)ShowLoading{
    
    self.HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.dimBackground=YES;
    self.HUD.labelText=@"Veuillez patienter";
    
}

-(void)HideLoading{
    
    [self.HUD hide:YES afterDelay:1];
    
}

@end
