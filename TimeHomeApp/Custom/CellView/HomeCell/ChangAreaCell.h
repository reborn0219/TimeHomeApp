//
//  ChangAreaCell.h
//  TimeHomeApp
//
//  Created by us on 16/3/7.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityCommunityModel.h"

@interface ChangAreaCell : UITableViewCell

/**
 *  小区名称
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_AreaName;
/**
 *  小区地址
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Addrs;
/**
 *  单选按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_Selected;
/**
 *  单选事件回调
 */
@property(nonatomic,copy) CellEventBlock cellSelectCallBack;
/**
 *  在列表中的位置
 */
@property(nonatomic,strong) NSIndexPath * indexPath;

@property (nonatomic,strong) CityCommunityModel *cityModel;

@end
