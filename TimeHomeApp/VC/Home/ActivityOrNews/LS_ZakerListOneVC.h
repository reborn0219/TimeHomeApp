//
//  LS_ZakerListOneVC.h
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/1/8.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LS_ZakerListOneVC : BaseViewController
@property (nonatomic, copy) UITableView *table;
-(void)requestData:(NSString *)Channel;
@end
