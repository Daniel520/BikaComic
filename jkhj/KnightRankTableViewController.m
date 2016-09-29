//
//  KnightRankTableViewController.m
//  jkhj
//
//  Created by 辉仔 on 16/9/28.
//  Copyright © 2016年 辉仔sama. All rights reserved.
//

#import "KnightRankTableViewController.h"
#import "KnightRankTableViewCell.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "TableViewController.h"

@interface KnightRankTableViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *Separator;
@property (weak, nonatomic) IBOutlet UIView *HeadView;
@property (weak, nonatomic) IBOutlet UILabel *RankTitle;
@property (weak, nonatomic) IBOutlet UILabel *KnightNameTitle;
@property (weak, nonatomic) IBOutlet UILabel *CountTitle;
@property(strong,nonatomic)AFHTTPSessionManager*manager;
@property (strong, nonatomic) MJRefreshAutoNormalFooter *footer;
@property(strong,nonatomic)NSMutableArray*datalist;
@end

@implementation KnightRankTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([Defaults boolForKey:@"NightMode"])
    {
        [self.tableView setBackgroundColor:NightModeBackgroundColor];
        [self.RankTitle setTextColor:NightModeTextColor];
        [self.KnightNameTitle setTextColor:NightModeTextColor];
        [self.CountTitle setTextColor:NightModeTextColor];
        [self.HeadView setBackgroundColor:NightModeBackgroundColor];
        [self.Separator setBackgroundColor:NightModeSeparatorColor];
    }
    self.datalist=[[NSMutableArray alloc]init];
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self.manager GET:[NSString stringWithFormat:@"http://picaman.picacomic.com/api/report/user-upload-count"] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress)
         {
             
         }
                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
         {
             self.datalist= [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
             [self.datalist removeLastObject];
             [self.tableView reloadData];
             [self.tableView.mj_footer endRefreshingWithNoMoreData];
         }
                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
         {
             
         }];
    }];
    [self.footer setTitle:@"正在加载骑士榜" forState:MJRefreshStateRefreshing];
    [self.footer setTitle:@"骑士榜加载完毕" forState:MJRefreshStateNoMoreData];
    if ([Defaults boolForKey:@"NightMode"])
    {
        self.footer.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhite;
        [self.footer.stateLabel setTextColor:NightModeTextColor];
    }
    else
    {
        self.footer.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
        [self.footer.stateLabel setTextColor:[UIColor grayColor]];
    }
    self.tableView.mj_footer=self.footer;
    [self.tableView.mj_footer beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datalist.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KnightRankTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"KnightRankCell" forIndexPath:indexPath];
    NSDictionary* dic=self.datalist[indexPath.row];
    cell.count.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"count"]];
    cell.name.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"display_name"]];
    cell.Rank.text=[NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
    if ([Defaults boolForKey:@"NightMode"])
    {
        [cell setBackgroundColor:NightModeBackgroundColor];
        [cell.count setTextColor:NightModeTextColor];
        [cell.name setTextColor:NightModeTextColor];
        [cell.Rank setTextColor:NightModeTextColor];
        [cell.Separator setBackgroundColor:NightModeSeparatorColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dic=self.datalist[indexPath.row];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TableViewController *ListVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"ListTableView"];
    ListVC.urlKey=[NSString stringWithFormat:@"%@",[dic objectForKey:@"user_id"]];
    ListVC.Classfiy=APIClassfiysearchskinght;
    [self.navigationController pushViewController:ListVC animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation


//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//}


@end
