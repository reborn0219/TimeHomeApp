//
//  THCarAuthoriedDetailsTVC2.m
//  TimeHomeApp
//
//  Created by 世博 on 16/4/26.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THCarAuthoriedDetailsTVC2.h"

@implementation THCarAuthoriedDetailsTVC2

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUp];
        
    }
    return self;
}

- (void)setUp {

    _rightLabel = [[UILabel alloc]init];
    _rightLabel.textAlignment = NSTextAlignmentRight;
    _rightLabel.textColor = TEXT_COLOR;
    _rightLabel.font = DEFAULT_FONT(14);
    [self.contentView addSubview:_rightLabel];
    _rightLabel.sd_layout.rightSpaceToView(self.contentView,15+13+5).topSpaceToView(self.contentView,15).widthIs(80).heightIs(20);
    
    _rightImage= [[UIImageView alloc]init];
    _rightImage.image = [UIImage imageNamed:@"设置_房产权限_续租"];
    [self.contentView addSubview:_rightImage];
    _rightImage.sd_layout.rightSpaceToView(self.contentView,15).centerYEqualToView(_rightLabel).widthIs(13).heightEqualToWidth();
    
    _topLabel = [[UILabel alloc]init];
//    _topLabel.backgroundColor = [UIColor redColor];
    _topLabel.textColor = TITLE_TEXT_COLOR;
    _topLabel.font = DEFAULT_FONT(14);
    [self.contentView addSubview:_topLabel];
    _topLabel.sd_layout.leftSpaceToView (self.contentView,15).topSpaceToView(self.contentView,15).widthIs(100).heightIs(20);
//    [_topLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.textColor = TITLE_TEXT_COLOR;
    _timeLabel.font = DEFAULT_FONT(14);
    [self.contentView addSubview:_timeLabel];
    _timeLabel.sd_layout.leftSpaceToView(self.contentView,15).topSpaceToView(_topLabel,5).rightSpaceToView(_rightLabel,5).heightIs(20);
    
    [self setupAutoHeightWithBottomViewsArray:@[_rightImage,_rightLabel,_topLabel,_timeLabel] bottomMargin:15];

}
- (void)setOwnerResidenceUser:(OwnerResidenceUser *)ownerResidenceUser {
    _ownerResidenceUser = ownerResidenceUser;
    
    _rightLabel.text = @"续  租";
    
    _topLabel.text = @"租 期";
    
    
    NSString *string = @"";
    if (![XYString isBlankString:ownerResidenceUser.rentbegindate]) {

        NSString *getDateString = [ownerResidenceUser.rentbegindate substringToIndex:10];
        NSDate *date = [XYString NSStringToDate:getDateString withFormat:@"yyyy-MM-dd"];
        NSString *dateString = [XYString NSDateToString:date withFormat:@"yyyy/MM/dd"];

        string = [string stringByAppendingFormat:@"%@",dateString];
    }
    if (![XYString isBlankString:ownerResidenceUser.rentenddate]) {
        NSString *getDateString = [ownerResidenceUser.rentenddate substringToIndex:10];
        NSDate *date = [XYString NSStringToDate:getDateString withFormat:@"yyyy-MM-dd"];
        NSString *dateString = [XYString NSDateToString:date withFormat:@"yyyy/MM/dd"];
        string = [string stringByAppendingFormat:@" - %@",dateString];
    }
    _timeLabel.text = string;
    
}

@end
