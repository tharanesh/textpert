//
//  UploadImageVc.m
//  TextPert
//
//  Created by elicit on 18/04/15.
//  Copyright (c) 2015 elicit. All rights reserved.
//

#import "UploadImageVc.h"
#import "SWRevealViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "SCLAlertView.h"
#import "GoogleWearAlertObjc.h"

@interface UploadImageVc ()<UIImagePickerControllerDelegate,UITextFieldDelegate>
{
    UIDatePicker *datePicker;
    UITextField *pickerfld;
    NSString *expiryDate;
    NSData *imgData;
    BOOL isTextpert;
}
@end

@implementation UploadImageVc

- (void)viewDidLoad {
    
    [super viewDidLoad];
   // [self textPertChecking];
    self.txtDuration.layer.masksToBounds = YES;
    self.txtDuration.layer.cornerRadius=10.0;
    self.txtDuration.layer.borderColor=[[UIColor whiteColor] CGColor];
    self.txtDuration.layer.borderWidth=1.0f;
    [self.txtDuration setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    _btnUpload.layer.cornerRadius=5.0;
    _btnUpload.layer.borderWidth=1.0;
    _btnUpload.layer.borderColor=[UIColor whiteColor].CGColor;
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
        
    {
        [_sidebtn addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
  imgData= [[NSData alloc]init];
    // Do any additional setup after loading the view.
}
-(void)textPertChecking
{
    NSString *uid = [[NSUserDefaults standardUserDefaults]
                     stringForKey:@"uid"];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"textpertStatus",@"todo",uid,@"fb_id", nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager POST:@"http://businessofimagination.com/textpert/user.php"  parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        NSDictionary *dict=responseObject;
        NSArray *arr=[dict valueForKey:@"0"];
        NSString *str=[arr valueForKey:@"textpert_mode"];
        if([str isEqualToString:@"1"])
        {
            isTextpert=YES;
        }
        else
        {
            isTextpert=NO;

        }
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              
   }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)textFieldDidBeginEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    datePicker = [[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message"
                                       message:@"Select Date And Time"
                                      delegate:self
                             cancelButtonTitle:@"Ok"
                             otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    pickerfld = [alert textFieldAtIndex:0];
    pickerfld.inputView = datePicker;
    [pickerfld setTextAlignment:NSTextAlignmentCenter];
    [datePicker addTarget:self action:@selector(didClickDatePicker:) forControlEvents:UIControlEventValueChanged];
    [alert show];

}

- (void)didClickDatePicker:(id)sender {
    
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"yyyy-MM-dd hh:mm a"];
    [dateFormat2 setDateFormat:@"yyyy-MM-dd HH:mm"];

    //[dateFormat setDateFormat:@"HH:mm"];
    NSString *date = [dateFormat1 stringFromDate:datePicker.date];
    expiryDate = [dateFormat2 stringFromDate:datePicker.date];
    _txtExpirydateAndtime.text=date;
    pickerfld.textColor=[UIColor blackColor];
    pickerfld.text=date;
     NSLog(@"date is >>> , %@",expiryDate);
    
}
- (IBAction)didClickImageBrowseBtn:(id)sender {
//    if(!isTextpert)
//    {
   
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [imagePicker setDelegate:self];
    [self presentViewController:imagePicker animated:YES completion:nil];
//    }
//    else
//    {
//        SCLAlertView *alert = [[SCLAlertView alloc] init];
//        [alert showWarning:self title:@"Warning" subTitle:@"Please Change to UserMode" closeButtonTitle:@"Done" duration:0.0f];
//    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
 
//  NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    imgData = UIImageJPEGRepresentation(image, 1.0);
   // encodedString = [self base64forData:imageData];
    [self dismissViewControllerAnimated:YES completion:^{}];
    
   [[GoogleWearAlertObjc getInstance]prepareNotificationToBeShown:[[GoogleWearAlertViewObjc alloc]initWithTitle:@"Uploaded" andImage:nil andWithType:success andWithDuration:2.5 inViewController:self atPostion:Top canBeDismissedByUser:NO]];
   
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didClickUpload:(id)sender {
  
    if(_txtExpirydateAndtime.text.length==0)
    {
       
        SCLAlertView *alert = [[SCLAlertView alloc] init];
       [alert showWarning:self title:@"Warning" subTitle:@"Please Enter time duration" closeButtonTitle:@"Done" duration:0.0f];
       
    }
    else if (imgData.length == 0)
    {
      SCLAlertView *alert = [[SCLAlertView alloc] init];
      [alert showWarning:self title:@"Warning" subTitle:@"Please Upload Image" closeButtonTitle:@"Done" duration:0.0f];
    }
    else
    {
     
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    NSString *userId = [[NSUserDefaults standardUserDefaults]stringForKey:@"uid"];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://businessofimagination.com/textpert/upload.php"]];
    NSDictionary *parameters = @{@"todo": @"uploadSS", @"file_expiry" : expiryDate, @"fb_id" : userId};
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    AFHTTPRequestOperation *op = [manager POST:@"rest.of.url" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //do not put image inside parameters dictionary as I did, but append it!
        [formData appendPartWithFileData:imgData name:@"upload_file" fileName:@"ScreenImage.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [alert showSuccess:@"Message!" subTitle:@"Successfully sent to Textperts" closeButtonTitle:@"Done" duration:0.0f];
         imgData= [[NSData alloc]init];
        _txtExpirydateAndtime.text=@"";
        NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        
        [alert showError:self title:@"Error..."
                subTitle:operation.responseString
        closeButtonTitle:@"OK" duration:0.0f];
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
    }];
    [op start];
    }
}
@end
