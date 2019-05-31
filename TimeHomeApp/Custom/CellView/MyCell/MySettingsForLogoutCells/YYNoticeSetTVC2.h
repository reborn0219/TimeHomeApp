//
//  YYNoticeSetTVC2.h
//  TimeHomeApp
//
//  Created by 世博 on 16/7/21.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SwitchClick)(BOOL isClosed);

@interface YYNoticeSetTVC2 : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *leftTopTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *leftBottomDetailLabel;

@property (weak, nonatomic) IBOutlet UISwitch *rightSwitch;

@property (nonatomic, copy) SwitchClick switchClick;

@end
