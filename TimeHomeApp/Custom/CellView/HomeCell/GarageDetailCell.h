//
//  GarageDetailCell.h
//  TimeHomeApp
//
//  Created by us on 16/2/25.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 *  车库详情Cell
 *
 *  
 */
#import <UIKit/UIKit.h>

@protocol GarageDetailCellDelegate <NSObject>
/**
 *  锁车事件回调
 *
 *  @param indexPath indexPath description
 */
-(void)lockCarClikeWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface GarageDetailCell : UITableViewCell
/**
 *  属性标题
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Title;
/**
 *  内容
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Content;
/**
 *  锁车按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_Lock;
/**
 *  所在索引
 */
@property(nonatomic,weak) NSIndexPath * indexPath;
/**
 *  事件回调协议
 */
@property(weak,nonatomic) id <GarageDetailCellDelegate> delegate;

@end
