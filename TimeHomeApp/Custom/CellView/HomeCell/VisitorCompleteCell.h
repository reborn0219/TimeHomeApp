//
//  VisitorCompleteCell.h
//  TimeHomeApp
//
//  Created by us on 16/3/1.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 *  访客通行申请完成Cell
 *
 */

#import <UIKit/UIKit.h>

@interface VisitorCompleteCell : UITableViewCell
/**
 *  标题
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Title;
/**
 *  内容
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Content;
/**
 *  地址图标
 */
@property (weak, nonatomic) IBOutlet UIButton *img_Addr;
@property(nonatomic,strong) NSIndexPath * indexPath;

///点击地图图标按钮
@property(nonatomic,copy)CellEventBlock cellEventBlock;

@end
