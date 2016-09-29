//
//  TableViewController.m
//  jkhj
//
//  Created by 辉仔 on 16/7/17.
//  Copyright © 2016年 辉君sama. All rights reserved.
//

#import "TableViewController.h"
#import "TableViewCell.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "DetailViewController.h"
#import "MJRefresh.h"


@interface TableViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)AFHTTPSessionManager*manager;
@property(strong,nonatomic)NSMutableArray *dic;
@property NSInteger NextPage;
@property(strong,nonatomic) NSMutableArray *RankArray;
@end

@implementation TableViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if ([self.urlKey isEqualToString:@"MyCollection"])
    {
        [self.dic removeAllObjects];
        NSDictionary*collection=[Defaults objectForKey:@"collection"];
        NSArray* Array=[collection allKeys];
        for (NSInteger i=0; i<Array.count; i++)
        {
            [self.dic addObject:[collection objectForKey:Array[i]]];
        }
        [self.tableView reloadData];
    }
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    if ([Defaults boolForKey:@"NightMode"])
    {
        [self.tableView setSeparatorColor:NightModeSeparatorColor];
        [self.tableView setBackgroundColor:NightModeBackgroundColor];
    }
    self.RankArray=[NSMutableArray arrayWithCapacity:5];
    self.NextPage=1;
    self.dic=[[NSMutableArray alloc]init];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    if (![self.urlKey isEqualToString:@"MyCollection"])
    {
        self.manager = [AFHTTPSessionManager manager];
        self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        MJRefreshAutoNormalFooter *footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
        [footer setTitle:@"正在寻觅更多魔物书" forState:MJRefreshStateRefreshing];
        [footer setTitle:@"继续寻觅更多魔物书" forState:MJRefreshStateIdle];
        [footer setTitle:@"魔物书已寻遍" forState:MJRefreshStateNoMoreData];
        if ([Defaults boolForKey:@"NightMode"])
        {
            footer.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhite;
            [footer.stateLabel setTextColor:NightModeTextColor];
        }
        else
        {
            footer.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
            [footer.stateLabel setTextColor:[UIColor grayColor]];
        }
        self.tableView.mj_footer=footer;
        [self.tableView.mj_footer beginRefreshing];
    }
}

-(void)loadMore
{
    NSString* URL;
    switch (self.Classfiy)
    {
        case APIClassfiycategories:
            URL=[NSString stringWithFormat:@"http://picaman.picacomic.com/api/categories/%@/page/%ld/comics",self.urlKey,(long)self.NextPage];
            break;
            
        case APIClassfiysearchsauthor:
            URL=[NSString stringWithFormat:@"http://picaman.picacomic.com/api/search/%@/comics/page/%ld",self.urlKey,(long)self.NextPage];
            break;
            
        case APIClassfiysearchskinght:
            URL=[NSString stringWithFormat:@"http://picaman.picacomic.com/api/user/%@/comics/page/%ld",self.urlKey,(long)self.NextPage];
            break;
    }
    [self.manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress)
     {
         
     }
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSArray* a= [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
         [self.dic addObjectsFromArray:a];
         [self.tableView reloadData];
         if (a.count>0)
         {
             self.NextPage++;
             [self.tableView.mj_footer endRefreshing];
         }
         else
         {
             [self.tableView.mj_footer endRefreshingWithNoMoreData];
         }
     }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         [self.tableView.mj_footer endRefreshing];
     }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dic.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if ([Defaults boolForKey:@"NightMode"])
    {
        [cell setBackgroundColor:NightModeBackgroundColor];
        [cell.title setTextColor:NightModeTextColor];
        [cell.PageCount setTextColor:NightModeTextColor];
    }

    NSDictionary* Dic=self.dic[indexPath.row];
    [cell.title setText:[Dic objectForKey:@"name"] ];
    [cell.image sd_setImageWithURL:[Dic objectForKey:@"cover_image"] ];
    NSString* strPageCount=[NSString stringWithFormat:@"%@p",[Dic objectForKey:@"total_page"]];
    [cell.author setText:[Dic objectForKey:@"author"]];
    [cell.PageCount setText:strPageCount];
    NSString* strRank=[NSString stringWithFormat:@"%@",[Dic objectForKey:@"rank"]];
    NSInteger rank=[strRank integerValue];
    [self.RankArray addObject:cell.Star1];
    [self.RankArray addObject:cell.Star2];
    [self.RankArray addObject:cell.Star3];
    [self.RankArray addObject:cell.Star4];
    [self.RankArray addObject:cell.Star5];
    for (int i=0; i<5; i++)
    {
        if (i<rank)
        {
            UIImageView *image=self.RankArray [i];
            [image setImage:[UIImage imageNamed:@"Star"]];
        }
        else
        {
            UIImageView *image=self.RankArray [i];
            [image setImage:[UIImage imageNamed:@"DarkStar"]];
        }
    }
    [self.RankArray removeAllObjects];
    
    if (![self.urlKey isEqualToString:@"where/most-updated"])
    {
        cell.NTR.hidden=YES;
        cell.HouGongSign.hidden=YES;
        cell.BanBook.hidden=YES;
        cell.FuTaSign.hidden=YES;
        cell.GameSign.hidden=YES;
        cell.RawMeatSign.hidden=YES;
        cell.BLSign.hidden=YES;
    }
    
    if (![self.urlKey isEqualToString:@"MyCollection"])
    {
        NSString* str=[NSString stringWithFormat:@"%@",[Dic objectForKey:@"cats"]];
        if([str rangeOfString:@"26"].location !=NSNotFound)
        {
            [cell.BLSign setBackgroundColor:[UIColor colorWithRed:102.0/255 green:204.0/255 blue:255.0/255 alpha:1]];
        }
        else
        {
            [cell.BLSign setBackgroundColor:[UIColor lightGrayColor]];
        }
        if([str rangeOfString:@"31"].location !=NSNotFound)
        {
            [cell.GameSign setBackgroundColor:[UIColor colorWithRed:1 green:127.0/255 blue:0 alpha:1]];
        }
        else
        {
            [cell.GameSign setBackgroundColor:[UIColor lightGrayColor]];
        }
        if([str rangeOfString:@"24"].location !=NSNotFound)
        {
            [cell.RawMeatSign setBackgroundColor:[UIColor colorWithRed:56.0/255 green:1 blue:92.0/255 alpha:1]];
        }
        else
        {
            [cell.RawMeatSign setBackgroundColor:[UIColor lightGrayColor]];
        }
        if([str rangeOfString:@"27"].location !=NSNotFound)
        {
            [cell.BanBook setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:1 alpha:1]];
        }
        else
        {
            [cell.BanBook setBackgroundColor:[UIColor lightGrayColor]];
        }
        if([str rangeOfString:@"10"].location !=NSNotFound)
        {
            [cell.HouGongSign setBackgroundColor:[UIColor redColor]];
        }
        else
        {
            [cell.HouGongSign setBackgroundColor:[UIColor lightGrayColor]];
        }
        
        if([str rangeOfString:@"16"].location !=NSNotFound)
        {
            [cell.NTR setBackgroundColor:[UIColor colorWithRed:0 green:111.0/255 blue:1 alpha:1]];
        }
        else
        {
            [cell.NTR setBackgroundColor:[UIColor lightGrayColor]];
        }
        
        if([str rangeOfString:@"11"].location !=NSNotFound)
        {
            [cell.FuTaSign setBackgroundColor:[UIColor colorWithRed:76.0/255 green:76.0/255 blue:76.0/255 alpha:1]];
        }
        else
        {
            [cell.FuTaSign setBackgroundColor:[UIColor lightGrayColor]];
        }
    }
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Segue"])
    {
        DetailViewController* Detail=[segue destinationViewController];
        NSDictionary* Dic=self.dic[self.tableView.indexPathForSelectedRow.row];
        Detail.Dic=Dic;
    }
}

@end
