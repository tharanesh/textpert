//
//  RequestFromUserVC.m
//  Textpert
//
//  Created by elicit on 02/05/15.
//  Copyright (c) 2015 elicit. All rights reserved.
//

#import "RequestFromUserVC.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "RespondToUser.h"
#import "SWRevealViewController.h"

@interface RequestFromUserVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *requests;
    int count;
    IBOutlet UITableView *objTable;
    NSDictionary *datas;
 
}
@end
@implementation RequestFromUserCell

@end

@implementation RequestFromUserVC

- (void)viewDidLoad {
    [super viewDidLoad];
   objTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [objTable setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    objTable.showsVerticalScrollIndicator = objTable.showsHorizontalScrollIndicator = NO;

    NSString *viewType = [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"viewType"];
    if([viewType isEqualToString:@"sideview"])
    {
        SWRevealViewController *revealViewController = self.revealViewController;
        if ( revealViewController )
            
        {
            [_backBtn addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        }
 
    }
    else
    {
       [_backBtn addTarget:self action:@selector(didClickbackbtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self getUserRequest];
    // Do any additional setup after loading the view.
}

-(void)getUserRequest
{
    NSString *uid = [[NSUserDefaults standardUserDefaults]
                     stringForKey:@"uid"];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"getRequest",@"todo",uid,@"fb_id", nil];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading";
    hud.color = [UIColor colorWithRed:51.0/255.0 green:181.0/255.0 blue:229.0/255.0 alpha:1.0];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager POST:@"http://businessofimagination.com/textpert/request.php"  parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        requests=responseObject;
        count=[[requests valueForKey:@"totalCount"] intValue];
        [objTable reloadData];
        _requestsCount.text=[NSString stringWithFormat:@"%d",count];
        [hud hide:YES];
            }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
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
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RequestFromUserCell *cell = (RequestFromUserCell *)[tableView dequeueReusableCellWithIdentifier:@"CellID" forIndexPath:indexPath];
    
    // Configure the cell...
    if(cell==nil)
    {
        cell=[[RequestFromUserCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
    }
  //  cell.lblMessage
    cell.backgroundColor=[UIColor clearColor];
    // Configure the cell...
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    NSString *index=[NSString stringWithFormat:@"%ld", (long)indexPath.row];
    datas=[requests valueForKey:index];
    cell.lblname.text=[datas valueForKey:@"name"];
    cell.lblExpery.text=[datas valueForKey:@"expiry_date"];
    [cell.lblMessage setTitle:[NSString stringWithFormat:@"View %@ Conversation",[datas valueForKey:@"name"]] forState:UIControlStateNormal];
    
       //    cell.backgroundColor=[UIColor colorWithRed:0/255.0 green:153/255.0 blue:204/255.0 alpha:1.0];
    // cell.textLabel.textColor=[UIColor whiteColor];
    
    //  img.image=[UIImage imageNamed:[NSString stringWithFormat:@"icn%d.png",indexPath.row]];
    
    return cell;
}

- (void)didClickbackbtn:(id)sender {
   
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *index=[NSString stringWithFormat:@"%ld", (long)indexPath.row];
    datas=[requests valueForKey:index];
    [self performSegueWithIdentifier:@"textpertrespond" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    RespondToUser *objVc=[segue destinationViewController];
    objVc.datas=datas;
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
