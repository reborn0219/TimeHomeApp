//
//  SignUpCell.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/7/14.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *签到设置cell
 */
#import <UIKit/UIKit.h>
typedef void(^SwitchClick)(BOOL isOpen);
@interface SignUpCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftTitle;
@property (weak, nonatomic) IBOutlet UISwitch *rightSwitch;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
@property (nonatomic, copy) SwitchClick switchBlock;
@end
