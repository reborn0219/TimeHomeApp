//
//  ChatMessageMainVC.h
//  TimeHomeApp
//
//  Created by UIOS on 16/3/9.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BaseViewController.h"

@interface ChatMessageMainVC : THBaseViewController
@property(nonatomic,strong)UITableView * msgTable;
@property(nonatomic,strong)UITableView * friendTable;
@property(nonatomic,assign)NSInteger Type;

@end
