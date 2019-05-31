//
//  RaiN_LabelCustomCell.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/2/14.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "RaiN_LabelCustomCell.h"
@interface RaiN_LabelCustomCell () <HXTagsViewDelegate>
{
    /**
     *  点击的是否是删除按钮
     */
    BOOL isCancelOrNot;
}

@property (nonatomic, strong) UIButton *cancelButton;

@end
@implementation RaiN_LabelCustomCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUp];
        
    }
    return self;
}

- (void)setUp {
    /**_myTitleLabel = [[UILabel alloc]init];
     _myTitleLabel.font = DEFAULT_BOLDFONT(15);
     _myTitleLabel.textColor = TITLE_TEXT_COLOR;
     [self.contentView addSubview:_myTitleLabel];
     [_myTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
     make.left.equalTo(_leftImageView.mas_right).offset(WidthSpace(24));
     make.centerY.equalTo(_leftImageView.mas_centerY);
     }];*/
    
    _showMassageLabel = [[UILabel alloc] init];
    _showMassageLabel.textColor = TEXT_COLOR;
    _showMassageLabel.font = DEFAULT_FONT(14);
    _showMassageLabel.text = @"添加标签后贴子更容易被搜到噢!";
    [self.contentView addSubview:_showMassageLabel];
    [_showMassageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    //    _showMassageLabel.hidden = YES;
    
    
}

- (RaiN_LabelsView *)tagsView {
    if (!_tagsView) {
        
        NSDictionary *propertyDic = @{@"type":@"1"};//可添加多个属性,1表示平铺
        _tagsView = [[RaiN_LabelsView alloc]init];
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
    float  height = [RaiN_LabelsView getTagsViewHeight:tagsArray dic:propertyDic];
    return height;
}
#pragma mark HXTagsViewDelegate
/**
 *  tagsView代理方法
 *
 *  @param tagsView tagsView
 *  @param sender   tag:sender.titleLabel.text index:sender.tag
 */
- (void)tagsViewButtonAction:(RaiN_LabelsView *)tagsView button:(UIButton *)sender {
    
    //    NSLog(@"tag:%@ index:%ld",sender.titleLabel.text,(long)sender.tag);
    
    if (isCancelOrNot == 1) {
        
        if (self.cancelCallBack) {
            self.cancelCallBack(sender.tag);
            _tagsView.titleNormalColor = kNewRedColor;
        }
        
    }else {
        
        if (self.selectedCallBack) {
            self.selectedCallBack(sender.tag);
            _tagsView.titleNormalColor = [UIColor yellowColor];
        }
    }
}

- (void)configureCellTagsArray:(NSArray *)tagsArray atIndexPath:(NSIndexPath *)indexPath isCancelOrNot:(BOOL)isCancel {
    
    /**
     *  创建标签view
     */
    [self.contentView addSubview:self.tagsView];
    
    _tagsView.scrollEnabled = NO;
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
