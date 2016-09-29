//
//  CommentController.m
//  jkhj
//
//  Created by 辉仔 on 16/8/11.
//  Copyright © 2016年 辉君sama. All rights reserved.
//

#import "CommentController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "CommentCell.h"
#import "CommentModel.h"


@interface CommentController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentTextViewH;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLable;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BottomViewH;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIView *TopView;
@property (weak, nonatomic) IBOutlet UIView *BottomView;
@property (weak, nonatomic) IBOutlet UITableView *CommentTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BottomHieght;
@property(strong,nonatomic)AFHTTPSessionManager*manager;
@property NSInteger PageCount;
@property(strong,nonatomic)NSMutableArray* CommentModelArray;
@property(strong,nonatomic)NSString* uuid;
@end

@implementation CommentController

-(void)viewDidLoad
{
    [super viewDidLoad];
    if ([Defaults boolForKey:@"NightMode"])
    {
        [self.view setBackgroundColor:NightModeNavigationColor];
        [self.CommentTableView setSeparatorColor:NightModeSeparatorColor];
        [self.CommentTableView setBackgroundColor:NightModeBackgroundColor];
        [self.TopView setBackgroundColor:NightModeNavigationColor];
        [self.commentTextView setBackgroundColor:NightModeBackgroundColor];
        [self.commentTextView setTextColor:NightModeTextColor];
        [self.BottomView setBackgroundColor:NightModeNavigationColor];
        self.commentTextView.layer.borderWidth=1;
        self.commentTextView.layer.borderColor=[UIColor clearColor].CGColor;
        [self.sendButton setTitleColor:NightModeTintColor forState:UIControlStateNormal];
    }
    else
    {
        self.commentTextView.layer.borderWidth=0;
    }
    self.sendButton.enabled=NO;
    self.commentTextView.tag=1;
    self.commentTextView.layer.cornerRadius=7;
    self.commentTextView.userInteractionEnabled=NO;
    self.uuid=[Defaults objectForKey:@"uuid"];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardwill:)
                                                name:UIKeyboardWillShowNotification object:nil];
    self.commentTextView.delegate=self;
    self.CommentModelArray =[[NSMutableArray alloc]init];
    self.PageCount=1;
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    MJRefreshAutoNormalFooter *footer =[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(GetComment)];
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
    [footer setTitle:@"正在寻觅更多伟论" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"继续寻觅更多伟论" forState:MJRefreshStateIdle];
    [footer setTitle:@"伟论已寻遍" forState:MJRefreshStateNoMoreData];
    self.CommentTableView.mj_footer=footer;
    [self.CommentTableView.mj_footer beginRefreshing];
}


-(void)GetComment;
{
    NSString* Url=[NSString stringWithFormat:@"http://picaman.picacomic.com/api/comics/%@/comments/page/%ld",self.ComicId,(long)self.PageCount];
//    NSString* Url=[NSString stringWithFormat:@"http://127.0.0.1/php/GET.php"];
    [self.manager GET:Url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress)
    {
        
    }
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        self.sendButton.enabled=YES;
        self.commentTextView.userInteractionEnabled=YES;
        NSArray* CommentArray= [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        for (NSDictionary* Model in CommentArray)
        {
            CommentModel* Models=[[CommentModel alloc]init];
            Models.display_name=[NSString stringWithFormat:@"%@",[Model objectForKey:@"display_name"]];
            Models.created_at=[NSString stringWithFormat:@"%@",[Model objectForKey:@"created_at"]];
            Models.comment=[NSString stringWithFormat:@"%@",[Model objectForKey:@"comment"]];
            Models.comment_index=[NSString stringWithFormat:@"%@",[Model objectForKey:@"comment_index"]];
            [self.CommentModelArray addObject:Models];
        }
        if (CommentArray.count>0)
            self.PageCount++;
        [self.CommentTableView reloadData];
        if (CommentArray.count>0&&CommentArray.count==20)
        {
            [self.CommentTableView.mj_footer endRefreshing];
        }
        else
        {
            [self.CommentTableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         [self dismissViewControllerAnimated:YES completion:nil];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.CommentModelArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCell* cell=[self.CommentTableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    if (cell == nil)
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommentCell"];
    if ([Defaults boolForKey:@"NightMode"])
    {
        [cell.created_at setTextColor:NightModeTextColor];
        [cell.comment setTextColor:NightModeTextColor];
        [cell.comment_index setTextColor:NightModeTextColor];
        [cell setBackgroundColor:NightModeBackgroundColor];
        [self.sendButton setTitleColor:NightModeTextColor forState:UIControlStateNormal];
    }
    CommentModel* Models=self.CommentModelArray[indexPath.row];
    cell.display_name.text=Models.display_name;
    [cell.display_name sizeToFit];
    cell.created_at.text=Models.created_at;
    cell.comment.text=Models.comment;
    [cell.comment sizeToFit];
    NSString*comment_index=[NSString stringWithFormat:@"%@",Models.comment_index];
    cell.comment_index.text=[NSString stringWithFormat:@"第%ld楼",[comment_index integerValue]+1];
    cell.Height=12+cell.display_name.frame.size.height+cell.created_at.frame.size.height+cell.comment.frame.size.height+5;
    Models.Height=cell.Height;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentModel* Models=self.CommentModelArray[indexPath.row];
    return  Models.Height <= 100? 100 : Models.Height ;
}

- (IBAction)Eixt:(id)sender
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag!=1)
    {
        [self.view endEditing:YES];
        self.BottomHieght.constant=0;
    }
}

-(void)keyboardwill:(NSNotification *)sender
{
    NSDictionary *dict=[sender userInfo];
    NSValue *value=[dict objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardrect = [value CGRectValue];
    CGFloat height=keyboardrect.size.height;
    self.BottomHieght.constant=height;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([self.commentTextView.text isEqualToString:@""])
    {
        self.placeholderLable.hidden=NO;
    }
    else
    {
        self.placeholderLable.hidden=YES;
    }
    self.commentTextViewH.constant=self.commentTextView.contentSize.height;
    self.BottomViewH.constant=14+self.commentTextViewH.constant;
}

- (IBAction)SendAction:(id)sender
{
    if ([self.commentTextView.text length]>3)
    {
        NSString*display_name=[NSString stringWithFormat:@"%@",[Defaults objectForKey:@"GentlemanName"]];
        NSDictionary* dic=[[NSDictionary alloc]initWithObjectsAndKeys:self.commentTextView.text, @"comment",display_name,@"display_name",self.uuid,@"uuid",nil];
        NSString* URL=[NSString stringWithFormat:@"http://picaman.picacomic.com/api/comics/%@/comment",self.ComicId];
        [self.manager POST:URL parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            self.commentTextView.text=@"";
            [self.CommentModelArray removeAllObjects];
            NSInteger PageCounts=self.PageCount-1;
            self.PageCount=1;
            for (NSInteger i=0; i<PageCounts; i++)
            {
                [self GetComment];
            }
            [self.CommentTableView reloadData];
            [self.view endEditing:YES];
            self.BottomHieght.constant=0;
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"你太短小了～" message:@"最少3个字喔～" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"恩" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){}]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

@end
