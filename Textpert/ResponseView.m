//
//  ResponseView.m
//  Textpert
//
//  Created by elicit on 02/05/15.
//  Copyright (c) 2015 elicit. All rights reserved.
//

#import "ResponseView.h"
#import "SWRevealViewController.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "SCLAlertView.h"

@interface ResponseView ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *responses;
    int count;
    IBOutlet UITableView *objTable;
    NSDictionary *datas;
    UILabel *lblMessage;
    
 
}
@end
@implementation ResponseViewCell

@end

@implementation ResponseView

- (void)viewDidLoad {
    [self LabelCreation];
    [super viewDidLoad];
    objTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [objTable setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    objTable.showsVerticalScrollIndicator = objTable.showsHorizontalScrollIndicator = NO;
    [self getUserResponse];
    NSString *viewType = [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"viewType"];
    if([viewType isEqualToString:@"sideview"])
    {
        SWRevealViewController *revealViewController = self.revealViewController;
        if ( revealViewController )
            
        {
            [_btnBack addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        }
        
    }
    else
    {;
        [_btnBack addTarget:self action:@selector(didClickback:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)getUserResponse
{
    NSString *uid = [[NSUserDefaults standardUserDefaults]
                     stringForKey:@"uid"];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"userResponse",@"todo",uid,@"fb_id", nil];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading";
    hud.color = [UIColor colorWithRed:51.0/255.0 green:181.0/255.0 blue:229.0/255.0 alpha:1.0];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager POST:@"http://businessofimagination.com/textpert/request.php"  parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        NSDictionary *response=responseObject;
        int val=[[response valueForKey:@"success"] intValue];
        NSDictionary *responseValue=[response valueForKey:@"0"];
        if([[responseValue valueForKey:@"fb_id"] isEqualToString:@"NA"])
        {
           count=0;
        }
        else if(val==1)
        {
        lblMessage.text=@"No Responses Found";
        responses=responseObject;
        count=[[responses valueForKey:@"totalCount"] intValue];
        [objTable reloadData];
        
        }
        _responseCount.text=[NSString stringWithFormat:@"%d",count];
        [hud hide:YES];
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              lblMessage.text=error.description;
          }];
}

-(void)LabelCreation
{
    lblMessage = [UILabel new];
    lblMessage.frame = CGRectMake(0, 0, 320, 50);
    [lblMessage setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    lblMessage.font = [UIFont boldSystemFontOfSize:18];
    lblMessage.numberOfLines = 2;
    lblMessage.lineBreakMode = NSLineBreakByWordWrapping;
    lblMessage.shadowColor = [UIColor lightTextColor];
    lblMessage.textColor = [UIColor darkGrayColor];
    lblMessage.shadowOffset = CGSizeMake(0, 1);
    lblMessage.backgroundColor = [UIColor clearColor];
    lblMessage.textAlignment =  NSTextAlignmentCenter;
    [objTable insertSubview:lblMessage belowSubview:objTable];
    [lblMessage setHidden:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(count == 0)
    {
        [lblMessage setHidden:NO];
        objTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        return 0;
        
    }
    else
    {
        
        [lblMessage setHidden:YES];
        objTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ResponseViewCell *cell = (ResponseViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellID" forIndexPath:indexPath];
    
    if (!cell) {
        cell=[[ResponseViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
    }
    
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSString *index=[NSString stringWithFormat:@"%ld",indexPath.row];
    datas=[responses valueForKey:index];
    [cell.txtResponse setTitle:[datas valueForKey:@"response"] forState:UIControlStateNormal];
    cell.textpertname.text=[datas valueForKey:@"name"];
    
    cell.btnCopy.tag=indexPath.row;
    [cell.btnCopy addTarget:self action:@selector(didClickCopy:) forControlEvents:UIControlEventTouchUpInside];
    [cell.star1 addTarget:self action:@selector(didClickStar:) forControlEvents:UIControlEventTouchUpInside];
    [cell.star2 addTarget:self action:@selector(didClickStar:) forControlEvents:UIControlEventTouchUpInside];
    [cell.star3 addTarget:self action:@selector(didClickStar:) forControlEvents:UIControlEventTouchUpInside];
    [cell.star4 addTarget:self action:@selector(didClickStar:) forControlEvents:UIControlEventTouchUpInside];
    [cell.star5 addTarget:self action:@selector(didClickStar:) forControlEvents:UIControlEventTouchUpInside];
    
    // Get user profile picture and set in cell
    // TODO: cell.userImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icn%ld.png", (long)indexPath.row]];
    
    return cell;
}

-(void)didClickCopy:(UIButton *)sender
{
    NSString *index=[NSString stringWithFormat:@"%ld",sender.tag];
    datas=[responses valueForKey:index];
//  NSString *flag=[[NSUserDefaults standardUserDefaults] valueForKey:@"flag"];
//    if([flag isEqualToString:@"1"])
//    {
        datas=[responses valueForKey:index];
        NSString *copyStringverse = [datas valueForKey:@"response"];
        UIPasteboard *pb = [UIPasteboard generalPasteboard];
        [pb setString:copyStringverse];
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    [alert showSuccess:@"Message!" subTitle:@"Copied the Response" closeButtonTitle:@"Done" duration:0.0f];
//    }
//    else{
//        SCLAlertView *alert = [[SCLAlertView alloc] init];
//        [alert showWarning:self title:@"Message" subTitle:@"Please Add Rating to Textpert" closeButtonTitle:@"Done" duration:0.0f];
//    }
}
-(void)didClickStar:(UIButton *)sender
{
    [sender setBackgroundImage:[UIImage imageNamed:@"StarFullNew.png"] forState:UIControlStateNormal];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"flag"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (void)didClickback:(id)sender
{
   [self.navigationController popToRootViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
