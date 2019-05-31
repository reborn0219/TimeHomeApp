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

- (void)showLockCar:(BOOL)show;
@end
