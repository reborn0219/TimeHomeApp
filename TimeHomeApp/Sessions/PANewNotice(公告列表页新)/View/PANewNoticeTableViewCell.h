//
//  PANewNoticeTableViewCell.h
//  TimeHomeApp
//
//  Created by Evagrius on 2018/8/28.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PANewNoticeModel.h"
@interface PANewNoticeTableViewCell : UITableViewCell

@property (nonatomic, strong)PANewNoticeModel * noticeModel;
@property (nonatomic, strong)UpDateViewsBlock loadImageSuccess;

@end
