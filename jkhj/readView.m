//
//  readView.m
//  jkhj
//
//  Created by 辉仔 on 16/7/18.
//  Copyright © 2016年 辉君sama. All rights reserved.
//

#import "readView.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
@interface readView ()<UIScrollViewDelegate>
@property (strong,nonatomic ) UIView         *readView1;
@property (strong,nonatomic ) UIView         *readView2;
@property (strong,nonatomic ) UIView         *readView3;
@property (weak, nonatomic  ) IBOutlet UIBarButtonItem      *PageItem;
@property (strong, nonatomic) UILabel              *PageLabel;
@property (weak, nonatomic  ) IBOutlet UIScrollView         *scrollView;
@property (weak, nonatomic  ) IBOutlet UIToolbar            *toolbar;
@property BOOL navigationControllerIsHidden;
@property (strong,nonatomic ) AFHTTPSessionManager *manager;
@property (strong,nonatomic ) NSDictionary         *dics;
@property (strong,nonatomic ) UIScrollView         *readScrollView1;
@property (strong,nonatomic ) UIScrollView         *readScrollView2;
@property (strong,nonatomic ) UIScrollView         *readScrollView3;
@property (strong,nonatomic ) UIImageView          * imageview1;
@property (strong,nonatomic ) UIImageView          * imageview2;
@property (strong,nonatomic ) UIImageView          * imageview3;
@property NSInteger currentPage;
@property NSInteger count;
@property (weak, nonatomic) IBOutlet UINavigationItem *Title;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *EP;
@property (weak, nonatomic  ) IBOutlet UISlider             *PageSlider;
@property (strong,nonatomic ) NSArray              * array;
@end

@implementation readView

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.PageLabel=[[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-150, [UIScreen mainScreen].bounds.size.height/2-50, 300, 100)];
    if ([Defaults boolForKey:@"NightMode"])
    {
        [self.view setBackgroundColor:NightModeBackgroundColor];
        [self.toolbar setBarTintColor:NightModeNavigationColor];
        [self.PageLabel setTextColor:NightModeTextColor];
        [self.PageSlider setThumbTintColor:[UIColor lightGrayColor]];
        [self.PageSlider setTintColor:NightModeBackgroundColor];
        [self.PageItem setTintColor:NightModeTextColor];
        [self.EP setTintColor:NightModeTextColor];
    }
    [self SetUp];
}

-(void)SetUp
{
    [self.PageItem setTitle:[NSString stringWithFormat:@"???"]];
    [self.EP setTitle:[NSString stringWithFormat:@"第%ld话",(long)self.ep]];
    [self.Title setTitle:self.comicname];
    self.PageSlider.enabled                   = NO;
    [self.PageSlider addTarget:self action:@selector(SliderValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.scrollView addSubview:self.PageLabel];
    [self.PageLabel setFont:[UIFont systemFontOfSize:85]];
    [self.PageLabel setTextAlignment:NSTextAlignmentCenter];
    [self.PageLabel setText:@"1"];
    self.currentPage                          = 1;
    self.scrollView.delegate                  = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.imageview1=[[UIImageView alloc] init];
    self.imageview2=[[UIImageView alloc] init];
    self.imageview3=[[UIImageView alloc] init];
    self.readView1=[[UIView alloc]init];
    self.readView2=[[UIView alloc]init];
    self.readView3=[[UIView alloc]init];


    self.readScrollView1=[[UIScrollView alloc]init];
    [self.readScrollView1 addSubview:self.readView1];
    [self.readView1 addSubview:self.imageview1];
    self.readScrollView1.tag=1;
    self.readScrollView1.delegate=self;
    self.readScrollView1.minimumZoomScale=1;
    self.readScrollView1.maximumZoomScale=2;
    self.readScrollView1.bounces=YES;
    
    self.readScrollView2=[[UIScrollView alloc]init];
    [self.readScrollView2 addSubview:self.readView2];
    [self.readView2 addSubview:self.imageview2];
    self.readScrollView2.tag=2;
    self.readScrollView2.delegate=self;
    self.readScrollView2.minimumZoomScale=1;
    self.readScrollView2.maximumZoomScale=2;
    self.readScrollView2.bounces=YES;

    
    self.readScrollView3=[[UIScrollView alloc]init];
    [self.readScrollView3 addSubview:self.readView3];
    [self.readView3 addSubview:self.imageview3];
    self.readScrollView3.tag=3;
    self.readScrollView3.delegate=self;
    self.readScrollView3.minimumZoomScale=1;
    self.readScrollView3.maximumZoomScale=2;
    self.readScrollView3.bounces=YES;

    
    [self.scrollView addSubview:self.readScrollView1];
    [self.scrollView addSubview:self.readScrollView2];
    [self.scrollView addSubview:self.readScrollView3];
    self.toolbar.hidden                       = YES;
    [super.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationControllerIsHidden         = YES;
    self.manager                              = [AFHTTPSessionManager manager];
    self.manager.responseSerializer           = [AFHTTPResponseSerializer serializer];
    NSString *URL=[NSString stringWithFormat:@"http://picaman.picacomic.com/api/comics/%ld/ep/%ld",(long)self.id,(long)self.ep];
    [self.manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress)
     {

     }
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         self.array=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
         [self.scrollView setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width*self.array.count,0)];
         self.count                                = self.array.count;
         [self SetImageWithImageView:self.imageview1 readScrollView:self.readScrollView1  ReadViews:self.readView1  PageCount:0];
         if (self.array.count>1)
         {
             [self SetImageWithImageView:self.imageview2 readScrollView:self.readScrollView2 ReadViews:self.readView2 PageCount:1];
         }
         if (self.array.count>2)
         {
             [self SetImageWithImageView:self.imageview3 readScrollView:self.readScrollView3 ReadViews:self.readView3 PageCount:2];
         }
         self.PageSlider.minimumValue              = 1;
         self.PageSlider.maximumValue              = self.array.count;
         [self.PageItem setTitle:[NSString stringWithFormat:@"1/%lu",(unsigned long)self.array.count]];
         self.PageSlider.enabled                   = YES;
     }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {

     }];
}

-(void)SliderValueChanged
{
    NSInteger a=(int)self.PageSlider.value;
    self.PageSlider.value=a;
    [self.PageItem setTitle:[NSString stringWithFormat:@"%ld/%lu",(long)a,(unsigned long)self.array.count]];
    [self.scrollView setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width*(a-1), 0) animated:NO];
    [self readScrollViewReturnToTheOriginal];
    [self ChangePageWhitPage:a];
    if (a==1)
    {
        [self SetImageWithImageView:self.imageview1 readScrollView:self.readScrollView1 ReadViews:self.readView1 PageCount:0];
        [self SetImageWithImageView:self.imageview2 readScrollView:self.readScrollView2 ReadViews:self.readView2 PageCount:1];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.PageLabel setFrame:CGRectMake(self.scrollView.contentOffset.x, [UIScreen mainScreen].bounds.size.height/2-50, [UIScreen mainScreen].bounds.size.width, 100)];
    NSInteger a= self.scrollView.contentOffset.x/self.scrollView.contentSize.width*self.count+1.5;
    NSString* str=[NSString stringWithFormat:@"%ld",(long)a];
    [self.PageLabel setText:str];
    self.PageSlider.value=a;
    [self.PageItem setTitle:[NSString stringWithFormat:@"%ld/%lu",(long)a,(unsigned long)self.array.count]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger NextPage=self.scrollView.contentOffset.x/self.scrollView.contentSize.width*self.count+1;
    [self ChangePageWhitPage:NextPage];
    self.currentPage=NextPage;
}

-(void)ChangePageWhitPage:(NSInteger) NextPage
{
    if (NextPage!=self.currentPage)
    {
        [self readScrollViewReturnToTheOriginal];
    }
    
    if (NextPage-self.currentPage>1||NextPage-self.currentPage<-1)
    {
        switch (NextPage%3)
        {
            case 0:
                if (NextPage<self.array.count)
                    [self SetImageWithImageView:self.imageview1 readScrollView:self.readScrollView1 ReadViews:self.readView1 PageCount:NextPage];
                    
                if (NextPage>=2)
                    [self SetImageWithImageView:self.imageview2 readScrollView:self.readScrollView2 ReadViews:self.readView2 PageCount:(NextPage-2)];
                    
                [self SetImageWithImageView:self.imageview3 readScrollView:self.readScrollView3 ReadViews:self.readView3 PageCount:(NextPage-1)];
                
                break;
                
                
            case 1:
                [self SetImageWithImageView:self.imageview1 readScrollView:self.readScrollView1 ReadViews:self.readView1 PageCount:(NextPage-1)];
                
                if (NextPage<self.array.count)
                    [self SetImageWithImageView:self.imageview2 readScrollView:self.readScrollView2 ReadViews:self.readView2 PageCount:(NextPage)];

                if (NextPage>=2)
                    [self SetImageWithImageView:self.imageview3 readScrollView:self.readScrollView3 ReadViews:self.readView3 PageCount:(NextPage-2)];

                break;
                
            case 2:
                [self SetImageWithImageView:self.imageview1 readScrollView:self.readScrollView1 ReadViews:self.readView1 PageCount:(NextPage-2)];
                
                [self SetImageWithImageView:self.imageview2 readScrollView:self.readScrollView2 ReadViews:self.readView2 PageCount:(NextPage-1)];
                
                if (NextPage<self.array.count)
                    [self SetImageWithImageView:self.imageview3 readScrollView:self.readScrollView3 ReadViews:self.readView3 PageCount:(NextPage)];

                break;
                
            default:
                break;
        }
    }
    else
    {
        if (NextPage>self.currentPage)
        {
            if (NextPage>self.array.count-1)
            {
                return;
            }
            switch (NextPage%3)
            {
                case 0:
                     [self SetImageWithImageView:self.imageview1 readScrollView:self.readScrollView1 ReadViews:self.readView1 PageCount:(NextPage)];
                    break;
                    
                case 1:
                     [self SetImageWithImageView:self.imageview2 readScrollView:self.readScrollView2 ReadViews:self.readView2 PageCount:(NextPage)];
                    break;
                    
                case 2:
                     [self SetImageWithImageView:self.imageview3 readScrollView:self.readScrollView3 ReadViews:self.readView3 PageCount:(NextPage)];

                    
                default:
                    break;
            }
        }
        if (NextPage<self.currentPage)
        {
            if(NextPage-2>=0)
            {
                switch (NextPage%3)
                {
                    case 0:
                        [self SetImageWithImageView:self.imageview2 readScrollView:self.readScrollView2 ReadViews:self.readView2 PageCount:(NextPage-2)];
                        break;
                        
                    case 1:
                        [self SetImageWithImageView:self.imageview3 readScrollView:self.readScrollView3 ReadViews:self.readView3 PageCount:(NextPage-2)];
                        break;
                        
                    case 2:
                        [self SetImageWithImageView:self.imageview1 readScrollView:self.readScrollView1 ReadViews:self.readView1 PageCount:(NextPage-2)];
                        break;
                        
                    default:
                        break;
                }
            }
            else
            {
                  [self SetImageWithImageView:self.imageview1 readScrollView:self.readScrollView1 ReadViews:self.readView1 PageCount:0];
            }
        }
    }
}

-(void)SetImageWithImageView:(UIImageView*)ImageView readScrollView:(UIScrollView*)readScrollview ReadViews:(UIView*) readView PageCount:(NSInteger)PageTag
{
    NSDictionary *dic=self.array[PageTag];
    CGFloat X=[UIScreen mainScreen].bounds.size.width*(PageTag);
    CGFloat width=self.scrollView.frame.size.width;
    CGFloat height;
    if (self.toolbar.hidden==YES)
    {
        height=self.scrollView.frame.size.height;
    }
    else
    {
        height=self.scrollView.frame.size.height+44;
    }
    [readScrollview setFrame:CGRectMake(X, 0,width,height)];
    [readView setFrame:CGRectMake(0, 0,width,height)];
    float H=[[NSString stringWithFormat:@"%@",[dic objectForKey:@"height"]] floatValue];
    float W=[[NSString stringWithFormat:@"%@",[dic objectForKey:@"width"]] floatValue];
    if (H>W)
    {
        [ImageView setFrame:CGRectMake(0, 0,width,height)];
    }
    else
    {
        height=H/W*width;
        CGFloat Y=(self.scrollView.frame.size.height+44)/2-(height/2);
        [ImageView setFrame:CGRectMake(0, Y,width,height)];
    }
    [ImageView sd_setImageWithURL:[dic objectForKey:@"url"]];
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    switch (scrollView.tag)
    {
        case 1:
            return self.readView1;
            break;
            
        case 2:
            return  self.readView2;
            break;
            
        case 3:
            return  self.readView3;
            break;
            
        default:
                return  nil;
            break;
    }
}

-(void)readScrollViewReturnToTheOriginal
{
    [self.readScrollView1 setZoomScale:1];
    [self.readScrollView2 setZoomScale:1];
    [self.readScrollView3 setZoomScale:1];
}

- (IBAction)touch:(id)sender
{
    self.navigationControllerIsHidden=!self.navigationControllerIsHidden;
    [super.navigationController setNavigationBarHidden:self.navigationControllerIsHidden animated:YES];
    self.toolbar.hidden=self.navigationControllerIsHidden;
}

@end
