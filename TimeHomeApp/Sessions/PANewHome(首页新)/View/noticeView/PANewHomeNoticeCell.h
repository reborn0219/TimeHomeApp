//
//  PANewHomeNoticeCell.h
//  TimeHomeApp
//
//  Created by ning on 2018/7/31.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PANewHomeNoticeCell : UITableViewCell

typedef void (^callback) (UIViewController *controller);

@property (nonatomic,copy) callback callback;

@property (nonatomic,strong) NSArray *notificArray;

@end
