//
//  PopViewVC.h
//  TimeHomeApp
//
//  Created by UIOS on 16/3/14.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BaseViewController.h"

@interface PopViewVC : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *table_H;
@property (nonatomic,copy)NSArray * data;
@property(nonatomic,copy)NSArray * picData;
@property (nonatomic,copy)CellEventBlock block;
+(instancetype)sharePopView;
-(void)showInVC:(UIViewController *)VC;
-(void)dismiss;
-(void)updateTable;

@end
