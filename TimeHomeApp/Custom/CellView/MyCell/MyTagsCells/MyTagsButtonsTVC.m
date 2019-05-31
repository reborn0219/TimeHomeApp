//
//  MyTagsButtonsTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "MyTagsButtonsTVC.h"

@interface MyTagsButtonsTVC () <HXTagsViewDelegate>
{
    /**
     *  点击的是否是删除按钮
     */
    BOOL isCancelOrNot;
}
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) HXTagsView *tagsView;
@end

@implementation MyTagsButtonsTVC

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUp];
        
    }
    return self;
}

- (void)setUp {

}
- (HXTagsView *)tagsView {
    if (!_tagsView) {
        
        NSDictionary *propertyDic = @{@"type":@"1"};//可添加多个属性,1表示平铺
        _tagsView = [[HXTagsView alloc]init];
        _tagsView.propertyDic = propertyDic;
    }
    return _tagsView;
}
/**
 *  计算标签所在单元格的高度
 *
 *  @param tagsArray 标签数组
 *
 *  @return cell高度
 */
- (CGFloat)configureHeightForCellTagsArray:(NSArray *)tagsArray {
    
    NSDictionary *propertyDic = @{@"type":@"1"};//可添加多个属性,1表示平铺
    float  height = [HXTagsView getTagsViewHeight:tagsArray dic:propertyDic];
    return height;
}
#pragma mark HXTagsViewDelegate
/**
 *  tagsView代理方法
 *
 *  @param tagsView tagsView
 *  @param sender   tag:sender.titleLabel.text index:sender.tag
 */
- (void)tagsViewButtonAction:(HXTagsView *)tagsView button:(UIButton *)sender {
    
//    NSLog(@"tag:%@ index:%ld",sender.titleLabel.text,(long)sender.tag);
    
    if (isCancelOrNot == 1) {

        if (self.cancelCallBack) {
            self.cancelCallBack(sender.tag);
        }
        
    }else {
        
        if (self.selectedCallBack) {
            self.selectedCallBack(sender.tag);
        }
    }
}

- (void)configureCellTagsArray:(NSArray *)tagsArray atIndexPath:(NSIndexPath *)indexPath isCancelOrNot:(BOOL)isCancel {
    
    /**
     *  创建标签view
     */
    [self.contentView addSubview:self.tagsView];
    _tagsView.borderWidth = 1;
    _tagsView.masksToBounds = NO;
    _tagsView.titleSize = 14;
    _tagsView.titleNormalColor = TEXT_COLOR;
    _tagsView.titleSelectedColor = TEXT_COLOR;
    [_tagsView setTagAry:tagsArray isCancel:isCancel delegate:self];
    _tagsView.backgroundColor = [UIColor whiteColor];
    _tagsView.frame = CGRectMake(0, 10, SCREEN_WIDTH-14, [self configureHeightForCellTagsArray:tagsArray]);

    //点击的是否是删除按钮
    isCancelOrNot = isCancel;

    
}

@end
