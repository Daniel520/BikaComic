//
//  MainTableViewController.m
//  jkhj
//
//  Created by 辉仔 on 16/8/9.
//  Copyright © 2016年 辉君sama. All rights reserved.
//

#import "MainTableViewController.h"
#import "MainTableViewCell.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "TableViewController.h"
#import "MJRefresh.h"
#import "TableViewController.h"

@interface MainTableViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UISearchBarDelegate>
@property(strong,nonatomic)NSMutableArray*classify;
@property (strong, nonatomic) UISearchBar *SearchBar;
@property (strong, nonatomic) MJRefreshAutoNormalFooter *footer;
@property BOOL DidLoad;
@property(strong,nonatomic)AFHTTPSessionManager*manager;
@end


@implementation MainTableViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.tableView reloadData];
    UITextField*TextField=[[[self.SearchBar.subviews firstObject] subviews] lastObject];
    if ([Defaults boolForKey:@"NightMode"])
    {
        [self.SearchBar setBarTintColor:NightModeNavigationColor];
        [self.SearchBar setTintColor:[UIColor grayColor]];
        [TextField setBackgroundColor:NightModeBackgroundColor];
        [TextField setTextColor:NightModeTextColor];
        [self.tableView setSeparatorColor:NightModeSeparatorColor];
        [self.tableView setBackgroundColor:NightModeBackgroundColor];
        [self.footer.stateLabel setTextColor:NightModeTextColor];
    }
    else
    {
        [self.tableView setBackgroundColor:[UIColor whiteColor]];
        [self.tableView setSeparatorColor:DefaultModeSeparatorColor];
        [self.SearchBar setBarTintColor:[UIColor colorWithRed:189.0/255 green:189.0/255  blue:195.0/255 alpha:1]];
        [TextField setBackgroundColor:[UIColor whiteColor]];
        [TextField setTextColor:[UIColor blackColor]];
        [self.footer.stateLabel setTextColor:[UIColor grayColor]];
    }
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    float tmpSize = [[SDImageCache sharedImageCache] getSize]/1000.0/1000.0;
    if (tmpSize>100)
    {
        NSString* CacheSizeString =  [NSString stringWithFormat:@"缓存的魔物已超过100M,是否要清除?(当前缓存%.1fM)",tmpSize];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"清除魔物(缓存)" message:CacheSizeString preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){}]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                    {
                                        [[SDImageCache sharedImageCache] clearDisk];
                                    }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

-(void)viewDidLoad
{
    [super viewDidLoad];
     self.SearchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    [self.SearchBar layoutIfNeeded];
    self.tableView.tableHeaderView=nil;
    self.classify=[[NSMutableArray alloc]init];
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self.manager GET:[NSString stringWithFormat:@"http://picaman.picacomic.com/api/categories"] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress)
         {
             
         }
                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
         {
             self.classify= [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
             [self.classify removeLastObject];
             [self.tableView reloadData];
             [self.tableView.mj_footer endRefreshingWithNoMoreData];
             self.SearchBar.delegate=self;
             self.SearchBar.placeholder=@"请烙下汝想寻觅的魔物书或魔法师～";
             UIView*Head=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
             [Head addSubview:self.SearchBar];
             self.tableView.tableHeaderView=Head;
         }
                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
         {
             
         }];
    }];
    [self.footer setTitle:@"正在加载更多魔物" forState:MJRefreshStateRefreshing];
    [self.footer setTitle:@"魔物已寻遍" forState:MJRefreshStateNoMoreData];
    if ([Defaults boolForKey:@"NightMode"])
    {
        self.footer.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhite;
    }
    else
    {
        self.footer.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
    }
    self.tableView.mj_footer=self.footer;
   [self.tableView.mj_footer beginRefreshing];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==3)
    {
        [self performSegueWithIdentifier:@"ToKnightRank" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"List" sender:self];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4+self.classify.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainTableViewCell* cell=[self.tableView dequeueReusableCellWithIdentifier:@"MainTableViewCell"];
    if ([Defaults boolForKey:@"NightMode"])
    {
        cell.backgroundColor=NightModeBackgroundColor;
        [cell.Title setTextColor:NightModeTextColor];
    }
    else
    {
        cell.backgroundColor=[UIColor whiteColor];
        [cell.Title setTextColor:[UIColor blackColor]];
    }

    NSDictionary*dic;
    switch (indexPath.row)
    {
        case 0:
            [cell.Title setText:@"最新更新"];
            [cell.Icon setImage:[UIImage imageNamed:@"new"]];
            break;
            
        case 1:
            [cell.Title setText:@"已完结"];
            [cell.Icon setImage:[UIImage imageNamed:@"Over"]];
            break;
            
        case 2:
            [cell.Title setText:@"我的收藏"];
            [cell.Icon setImage:[UIImage imageNamed:@"MyCollection"]];
            break;
            
        case 3:
            [cell.Title setText:@"骑士榜"];
            [cell.Icon setImage:[UIImage imageNamed:@"KnightRank"]];
            break;

            
        default:
            dic=self.classify[indexPath.row-4];
            [cell.Title setText: [dic objectForKey:@"name"]];
            [cell.Icon sd_setImageWithURL:[dic objectForKey:@"cover_image"]];
            break;
    }
    return cell;
}


- (IBAction)clearTmpPics:(id)sender
{
    float tmpSize = [[SDImageCache sharedImageCache] getSize]/1000.0/1000.0;
    
   NSString* CacheSizeString = tmpSize >= 1 ? [NSString stringWithFormat:@"当前缓存的魔物为%.1fM,是否要清除?",tmpSize] : [NSString stringWithFormat:@"当前缓存为%.1fK,是否要清除?",tmpSize * 1000];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"清除魔物(缓存)" message:CacheSizeString preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){}]];

    [alertController addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
    {
        [[SDImageCache sharedImageCache] clearDisk];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TableViewController *ListVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"ListTableView"];
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"];
    ListVC.urlKey=[NSString stringWithFormat:@"%@", [self.SearchBar.text stringByAddingPercentEncodingWithAllowedCharacters:characterSet]];
    ListVC.Classfiy=APIClassfiysearchsauthor;
    [self.navigationController pushViewController:ListVC animated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"List"])
    {
        NSDictionary*dic;
        TableViewController *a=[segue destinationViewController];
        a.Classfiy=APIClassfiycategories;
        switch (self.tableView.indexPathForSelectedRow.row)
        {
            case 0:
                a.urlKey=[NSString stringWithFormat:@"where/most-updated"];
                break;
                
            case 1:
                a.urlKey=[NSString stringWithFormat:@"where/finished"];
                break;
                
            case 2:
                a.urlKey=[NSString stringWithFormat:@"MyCollection"];
                break;
                
            case 3:
                break;
                
            default:
                 dic=self.classify[self.tableView.indexPathForSelectedRow.row-4];
                a.urlKey=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
                break;
        }
    }
}
@end
