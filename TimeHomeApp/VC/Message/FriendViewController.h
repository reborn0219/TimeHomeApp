//
//  FriendViewController.h
//  TimeHomeApp
//
//  Created by UIOS on 16/7/22.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 邻友
 */
@interface FriendViewController : THBaseViewController

@property(nonatomic,strong)UITableView * msgTable;

@property(nonatomic,strong)UITableView * friendTable;

@property(nonatomic,assign)NSInteger Type;

@end
