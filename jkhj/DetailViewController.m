//
//  DetailViewController.m
//  jkhj
//
//  Created by 辉仔 on 16/7/17.
//  Copyright © 2016年 辉君sama. All rights reserved.
//

#import "TableViewController.h"
#import "DetailViewController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "CollectionViewCell.h"
#import "CommentController.h"
#import "readView.h"

@interface DetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *DetailView;
@property (weak, nonatomic) IBOutlet UIButton *CollectionButton;
@property (weak, nonatomic) IBOutlet UIView *starview;
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property(strong,nonatomic)AFHTTPSessionManager*manager;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *CommentButton;
@property (weak, nonatomic) IBOutlet UIImageView *Star1;
@property (weak, nonatomic) IBOutlet UIImageView *Star2;
@property (weak, nonatomic) IBOutlet UIImageView *Star3;
@property (weak, nonatomic) IBOutlet UIImageView *Star4;
@property (weak, nonatomic) IBOutlet UIImageView *Star5;
@property(strong,nonatomic)NSArray *StarArray;
@property (weak, nonatomic) IBOutlet UILabel *Description;
@property (weak, nonatomic) IBOutlet UILabel *display_name;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ContentHight;
@property (weak, nonatomic) IBOutlet UILabel *Date;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TitleViewHight;
@property (weak, nonatomic) IBOutlet UILabel *readcount;
@property(strong,nonatomic)NSString*user_id;
@property (weak, nonatomic) IBOutlet UIView *contentview;
@property(strong,nonatomic)NSDictionary *dics;
@property(strong,nonatomic)UICollectionViewCell* BeSelectCell;
@end

@implementation DetailViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    if ([Defaults boolForKey:@"NightMode"])
    {
        [self.DetailView setBackgroundColor:NightModeBackgroundColor];
        [self.display_name setBackgroundColor:NightModeBackgroundColor];
        [self.name setTextColor: NightModeTextColor];
        [self.Description setTextColor:[UIColor colorWithWhite:0.8 alpha:0.8]];
        [self.collectionview setBackgroundColor:NightModeNavigationColor];
        [self.view setBackgroundColor:NightModeNavigationColor];
        [self.display_name setTextColor:NightModeTextColor];
        [self.Date setTextColor:NightModeTextColor];
    }

    self.CollectionButton.enabled=NO;
    self.CommentButton.enabled=NO;
    self.author.userInteractionEnabled=NO;
    self.display_name.userInteractionEnabled=NO;
    self.StarArray=[[NSArray alloc]initWithObjects:self.Star1, self.Star2, self.Star3, self.Star4, self.Star5,nil];
    self.collectionview.delegate=self;
    self.collectionview.dataSource=self;
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *URL=[NSString stringWithFormat:@"http://picaman.picacomic.com/api/comics/%@",[self.Dic objectForKey:@"id"]];
    [self.manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress)
     {
         
     }
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         self.dics= [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
         NSDictionary *dic=[self.dics objectForKey:@"comic"];
         NSString* strRank=[NSString stringWithFormat:@"%@",[dic objectForKey:@"rank"]];
         NSInteger rank=[strRank integerValue];
         for (int i=0; i<5; i++)
         {
             if (i<rank)
             {
                 UIImageView *image=self.StarArray [i];
                 [image setImage:[UIImage imageNamed:@"Star"]];
             }
             else
             {
                 UIImageView *image=self.StarArray [i];
                 [image setImage:[UIImage imageNamed:@"DarkStar"]];
             }
         }
         [self.display_name setText:[NSString stringWithFormat:@"   Knight Name:%@",[dic objectForKey:@"display_name"]]];
         [self.image sd_setImageWithURL:[dic objectForKey:@"cover_image"]];
         [self.name setText:[dic objectForKey:@"name"]];
         [self.name sizeToFit];
         [self.author setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"author"]]];
         [self.Description setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"description"]]];
         self.user_id=[NSString stringWithFormat:@"%@",[dic objectForKey:@"user_id"]];
         CGSize size = [self.Description sizeThatFits:CGSizeMake(self.Description.frame.size.width, MAXFLOAT)];
         self.ContentHight.constant=self.name.frame.size.height+self.author.frame.size.height+self.starview.frame.size.height+size.height+self.Date.frame.size.height;
         NSDate *newdate = [self stringToDate:[NSString stringWithFormat:@"%@",[dic objectForKey:@"updated_at"]]withDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
         NSDateFormatter*df = [[NSDateFormatter alloc]init];
         [df setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
         [df setLocale:[NSLocale currentLocale]];
         [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
         [self.Date setText:[df stringFromDate:newdate]];
         [self.readcount setText:[NSString stringWithFormat:@"绅士指数:%@",[dic objectForKey:@"views_count"]]];
         NSDictionary*collection=[Defaults objectForKey:@"collection"];
         if ([collection objectForKey:[NSString stringWithFormat:@"%@",[self.Dic objectForKey:@"id"]]])
         {
             UIImage *Star=[UIImage imageNamed:@"Star"];
             Star=[Star imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
             [self.CollectionButton setBackgroundImage:Star forState:UIControlStateNormal];
         }
         [self.collectionview reloadData];
         self.author.userInteractionEnabled=YES;
         self.display_name.userInteractionEnabled=YES;
         self.CommentButton.enabled=YES;
         self.CollectionButton.enabled=YES;
     }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         
     }];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    NSString *str=[NSString stringWithFormat:@"%@",[self.dics objectForKey:@"ep_count"]];
    NSInteger epcount=[str integerValue];
    return epcount;
}

- (IBAction)SearchKinght:(id)sender
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TableViewController *ListVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"ListTableView"];
    ListVC.urlKey=self.user_id;
    ListVC.Classfiy=APIClassfiysearchskinght;
    [self.navigationController pushViewController:ListVC animated:YES];
}

- (IBAction)SearchAuthor:(id)sender
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TableViewController *ListVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"ListTableView"];
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"];
    ListVC.urlKey=[NSString stringWithFormat:@"%@", [self.author.text  stringByAddingPercentEncodingWithAllowedCharacters:characterSet]];
    ListVC.Classfiy=APIClassfiysearchsauthor;
    [self.navigationController pushViewController:ListVC animated:YES];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell*cell=[self.collectionview dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if ([Defaults boolForKey:@"NightMode"])
    {
        [cell setBackgroundColor:[UIColor grayColor]];
        [cell.Lable setTextColor:[UIColor whiteColor]];
    }
    NSInteger ep=indexPath.row+1;
    cell.ep=ep;
    cell.Lable.text=[NSString stringWithFormat:@"第%ld话",(long)ep];
    return  cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.BeSelectCell!=nil)
    {
        if ([Defaults boolForKey:@"NightMode"])
        {
            [self.BeSelectCell setBackgroundColor:[UIColor grayColor]];
        }
        else
        {
            [self.BeSelectCell setBackgroundColor:[UIColor whiteColor]];
        }
    }
    UICollectionViewCell*cell=[self.collectionview cellForItemAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor lightGrayColor]];
    self.BeSelectCell=cell;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toRead"])
    {
        NSIndexPath* IndexPath=self.collectionview.indexPathsForSelectedItems[0];
        readView *RV=[segue destinationViewController];
        RV.ep=IndexPath.row+1;
        NSString *str=[NSString stringWithFormat:@"%@",[self.Dic objectForKey:@"id"]];
        RV.id=[str integerValue];
        RV.comicname=[self.Dic objectForKey:@"name"];
    }
    if ([segue.identifier isEqualToString:@"ToComment"])
    {
        CommentController* CCV=[segue destinationViewController];
        CCV.ComicId=[NSString stringWithFormat:@"%@",[self.Dic objectForKey:@"id"]];
    }
}

- (IBAction)collectionButton:(id)sender
{
    NSDictionary*collection=[Defaults objectForKey:@"collection"];
    if (![collection objectForKey:[NSString stringWithFormat:@"%@",[self.Dic objectForKey:@"id"]]])
    {
        NSDictionary* dic=[[NSDictionary alloc]initWithObjectsAndKeys:
                           [self.Dic objectForKey:@"id"], @"id",
                           [self.Dic objectForKey:@"author"], @"author",
                           [self.Dic objectForKey:@"cover_image"],@"cover_image",
                           [self.Dic objectForKey:@"name"],@"name",
                           [self.Dic objectForKey:@"rank"],@"rank",
                           [self.Dic objectForKey:@"total_page"],@"total_page",nil];
        NSMutableDictionary* dics=[[NSMutableDictionary alloc] initWithDictionary:collection];
        NSString *key=[NSString stringWithFormat:@"%@",[self.Dic objectForKey:@"id"]];
        [dics setObject:dic forKey:key];
        NSDictionary*collection=[[NSDictionary alloc] initWithDictionary:dics];
        [Defaults setObject:collection forKey:@"collection"];
        [Defaults synchronize];
        UIImage *Star=[UIImage imageNamed:@"Star"];
        Star=[Star imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self.CollectionButton setBackgroundImage:Star forState:UIControlStateNormal];
    }
    else
    {
        NSMutableDictionary* dics=[[NSMutableDictionary alloc]initWithDictionary:collection];
        [dics removeObjectForKey:[NSString stringWithFormat:@"%@",[self.Dic objectForKey:@"id"]]];
        NSDictionary*collection=[[NSDictionary alloc] initWithDictionary:dics];
        [Defaults setObject:collection forKey:@"collection"];
        [Defaults synchronize];
        UIImage *Star=[UIImage imageNamed:@"DarkStar"];
        Star=[Star imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self.CollectionButton setBackgroundImage:Star forState:UIControlStateNormal];
    }
}

- (NSDate *)stringToDate:(NSString *)dateString withDateFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    [dateFormatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"] ];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}
@end
