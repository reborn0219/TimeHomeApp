//
//  RaiN_LabelCustomCell.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/2/14.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THABaseTableViewCell.h"
#import "RaiN_LabelsView.h"

typedef void (^ SelectedCallBack)(NSInteger selectedIndex);
typedef void (^ CancelCallBack)(NSInteger selectedIndex);
@interface RaiN_LabelCustomCell : THABaseTableViewCell
@property (nonatomic, strong) RaiN_LabelsView *tagsView;
/**
*  删除标签回调
*/
@property (copy, nonatomic) CancelCallBack cancelCallBack;
/**
 *  选中标签回调
 */
@property (copy, nonatomic) SelectedCallBack selectedCallBack;
/**
 *  计算标签所在单元格的高度
 *
 *  @param tagsArray 标签数组
 *
 *  @return cell高度
 */
- (CGFloat)configureHeightForCellTagsArray:(NSArray *)tagsArray;

- (void)configureCellTagsArray:(NSArray *)tagsArray atIndexPath:(NSIndexPath *)indexPath isCancelOrNot:(BOOL)isCancel;
/**
 *  显示信息的label
 */
@property (nonatomic,strong)UILabel *showMassageLabel;

@end
