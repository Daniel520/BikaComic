//
//  TableViewController.h
//  jkhj
//
//  Created by 辉仔 on 16/7/17.
//  Copyright © 2016年 辉君sama. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface TableViewController : UITableViewController
typedef enum {
    APIClassfiycategories,
    APIClassfiysearchsauthor,
    APIClassfiysearchskinght
}APIClassfiy;
@property(strong,nonatomic)NSString *urlKey;
@property APIClassfiy Classfiy;
@end
