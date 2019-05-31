//
//  MyTagsButtonsTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THABaseTableViewCell.h"
#import "HXTagsView.h"

typedef void (^ SelectedCallBack)(NSInteger selectedIndex);
typedef void (^ CancelCallBack)(NSInteger selectedIndex);
@interface MyTagsButtonsTVC : THABaseTableViewCell
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

@end
