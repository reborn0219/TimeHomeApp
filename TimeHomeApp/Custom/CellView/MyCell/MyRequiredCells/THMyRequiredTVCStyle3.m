//
//  THMyRequiredTVCStyle3.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/22.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THMyRequiredTVCStyle3.h"


@implementation THMyRequiredTVCStyle3
{
    SDWeiXinPhotoContainerView *_picContainerView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setup];
        
    }
    return self;
}

- (void)setup {
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = @"详细描述";
    _titleLabel.font = DEFAULT_FONT(16);
    _titleLabel.textColor = TITLE_TEXT_COLOR;
    [self.contentView addSubview:_titleLabel];
    _titleLabel.sd_layout.leftSpaceToView(self.contentView,15).topSpaceToView(self.contentView,15).heightIs(20).rightSpaceToView(self.contentView,15);
    
    _describeLabel = [[UILabel alloc]init];
    _describeLabel.font = DEFAULT_FONT(16);
    _describeLabel.textColor = TEXT_COLOR;
    [self.contentView addSubview:_describeLabel];
    _describeLabel.sd_layout.leftSpaceToView(self.contentView,15).topSpaceToView(_titleLabel,15).rightSpaceToView(self.contentView,15).autoHeightRatio(0);
    
    _picContainerView = [[SDWeiXinPhotoContainerView alloc] init];
    [self.contentView addSubview:_picContainerView];
    _picContainerView.sd_layout.leftEqualToView(_describeLabel);
    
    [self setupAutoHeightWithBottomView:_picContainerView bottomMargin:15];
}
- (void)setUserInfo:(UserReserveInfo *)userInfo {
    
    _userInfo = userInfo;
    
    _describeLabel.text = userInfo.feedback;
    
    NSMutableArray *picArray = [[NSMutableArray alloc]init];
    for (UserReservePic *pic in userInfo.piclist) {
        [picArray addObject:pic.fileurl];
    }
    /**
     *  图片数组
     */
    _picContainerView.picPathStringsArray = picArray;
    _picContainerView.sd_layout.topSpaceToView(_describeLabel,15);
    if (picArray.count == 0) {
        [self setupAutoHeightWithBottomView:_describeLabel bottomMargin:15];

    }else {
        [self setupAutoHeightWithBottomView:_picContainerView bottomMargin:15];
    }
    [self updateLayout];
    
}
- (void)setUserComplaint2:(UserComplaint *)userComplaint2 {
    _userComplaint2 = userComplaint2;
    _describeLabel.text = userComplaint2.content;
    NSMutableArray *picArray = [[NSMutableArray alloc]init];
    for (UserReservePic *pic in userComplaint2.piclist) {
        [picArray addObject:pic.fileurl];
    }
    /**
     *  图片数组
     */
    _picContainerView.picPathStringsArray = picArray;
    _picContainerView.sd_layout.topSpaceToView(_describeLabel,15);
    [self setupAutoHeightWithBottomView:_picContainerView bottomMargin:15];
    [self updateLayout];

}


@end
