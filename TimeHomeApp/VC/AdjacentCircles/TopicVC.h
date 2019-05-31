//
//  TopicVC.h
//  TimeHomeApp
//
//  Created by UIOS on 16/2/23.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BaseViewController.h"

@interface TopicVC : BaseViewController
- (IBAction)createQuanZi:(id)sender;
@property (nonatomic,strong)UIView * messageMenu;
- (IBAction)publishTieZi:(id)sender;

@end
