//
//  RespondToUser.m
//  Textpert
//
//  Created by elicit on 02/05/15.
//  Copyright (c) 2015 elicit. All rights reserved.
//

#import "RespondToUser.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "SCLAlertView.h"

@interface RespondToUser ()<UITextViewDelegate>

@end

@implementation RespondToUser

UIImageView *_imageView;

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblname.text=[self.datas valueForKey:@"name"];
     _lblTime.text=[self.datas valueForKey:@"expiry_date"];
    NSString *username = [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"userName"];
    _lblTitle.text = username;
    [self loadChatScreen];
 

      // Do any additional setup after loading the view.
}

-(void)loadChatScreen
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading";
    hud.color = [UIColor colorWithRed:51.0/255.0 green:181.0/255.0 blue:229.0/255.0 alpha:1.0];
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://businessofimagination.com/textpert/screenshots/%@",[self.datas valueForKey:@"path"]]];
//    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://businessofimagination.com/textpert/screenshots/%@",[self.datas valueForKey:@"path"]]]];
    [self downloadImageWithURL:url completionBlock:^(BOOL succeeded, UIImage *image) {
    // TODO:    [_imgChat setImage:image];
        [hud hide:YES];
    }];
    
  
//    UIImage *img=[UIImage imageWithData:imageData];
//    [_imgChat setImage:img];
    
}

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                                   NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
                                   NSString *filePath = [documentsPath stringByAppendingPathComponent:@"chatImage.png"]; //Add the file name
                                   [data writeToFile:filePath atomically:YES];
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}
- (IBAction)didClickSend:(id)sender {
    
    if(_txtResponse.text==0||_txtResponse.textColor==[UIColor whiteColor])
    {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert showWarning:self title:@"Warning" subTitle:@"Please Enter Response" closeButtonTitle:@"Done" duration:0.0f];
    }
    else
    {
  
    NSString *s_id=[self.datas valueForKey:@"s_id"];
    NSString *uid = [[NSUserDefaults standardUserDefaults]
                     stringForKey:@"uid"];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"getResponse",@"todo",s_id,@"s_id",_txtResponse.text,@"response",uid,@"fb_id",nil];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager POST:@"http://businessofimagination.com/textpert/request.php"  parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        NSDictionary *response=responseObject;
        int val=[[response valueForKey:@"success"] intValue];
        
        if(val==1)
        {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert showSuccess:@"Message!" subTitle:[NSString stringWithFormat:@"Successfully sent to %@",_lblname.text] closeButtonTitle:@"Done" duration:0.0f];
         }
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
    
}
    
}



- (IBAction)didClickViewContext:(id)sender {
    _txtResponse.hidden=YES;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:@"chatImage.png"];
    UIImage *image = [UIImage imageWithContentsOfFile:getImagePath];
    _imageView = [[UIImageView alloc] initWithImage: image];
    //_imageView.frame = _chatScrollView.bounds;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _chatScrollView.contentSize = image.size;
    [_chatScrollView addSubview: _imageView];
    _chatScrollView.delegate = self;
    
    _btnSendResponse.hidden=YES;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - textView Delegate methods

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if (_txtResponse.textColor == [UIColor whiteColor]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    if(_txtResponse.text.length == 0){
        textView.textColor = [UIColor whiteColor];
        textView.text = @"\n\nPlease Type Response Here";
        [textView resignFirstResponder];
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        if(textView.text.length == 0)
        {
            textView.textColor = [UIColor whiteColor];
            textView.text = @"\n\nPlease Type Response Here";
        }
        
        return NO;
    }
    return YES;
}

- (IBAction)didClickrespond:(id)sender {
    
    _txtResponse.hidden=NO;
    // TODO: _imgChat.image=nil;
    _btnSendResponse.hidden=NO;
}
- (IBAction)didClickback:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
