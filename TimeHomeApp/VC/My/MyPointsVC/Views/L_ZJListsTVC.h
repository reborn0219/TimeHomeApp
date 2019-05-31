//
//  L_ZJListsTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/7/19.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "L_RecordListModel.h"

@interface L_ZJListsTVC : UITableViewCell
/**
 左边标题
 */
@property (weak, nonatomic) IBOutlet UILabel *leftTitle_Label;
/**
 右边标题
 */
@property (weak, nonatomic) IBOutlet UILabel *rightDetail_Label;

@property (nonatomic, strong) L_RecordListModel *model;

@end
