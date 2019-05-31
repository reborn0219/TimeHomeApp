//
//  PACarportInfoTableViewCell.h
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/9.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PACarSpaceDetailTableViewCell : UITableViewCell

@property (nonatomic, strong)NSString * infoString;

@property (nonatomic, copy)UpDateViewsBlock lockCarBlock;

/**
 是否展示锁车按钮

 @param show YES show
 */
- (void)showLockCar:(BOOL)show;

/**
 是否展示锁车按钮锁车状态
 
 @param show YES show
 */
- (void)showLockCarStateSelected:(BOOL)show;

@end
