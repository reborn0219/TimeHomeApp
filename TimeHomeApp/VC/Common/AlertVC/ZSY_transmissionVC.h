//
//  ZSY_transmissionVC.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/8/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSY_transmissionVC : UIViewController
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic,weak)IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (nonatomic,copy)ViewsEventBlock block;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view_H;

/**
 *  获取实例
 *
 *  @return return value description
 */
+(ZSY_transmissionVC *)getInstance;

+(instancetype)sharetransmissionAlert;

-(void)showInVC:(UIViewController *)VC withTitle:(NSString *)title andData:(NSMutableArray *)dataSource andBlcok:(ViewsEventBlock)blcok;
-(void)showInVC:(UIViewController *)VC andBlcok:(ViewsEventBlock)blcok;
-(void)dismiss;


@end
