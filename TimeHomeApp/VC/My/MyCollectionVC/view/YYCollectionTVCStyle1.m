//
//  YYCollectionTVCStyle1.m
//  TimeHomeApp
//
//  Created by 世博 on 16/7/21.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "YYCollectionTVCStyle1.h"
#import "DateUitls.h"

@interface YYCollectionTVCStyle1 ()

@end

@implementation YYCollectionTVCStyle1

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        [self setUp];
        
    }
    return self;
}

- (void)setUp {
    
    _left_ImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:_left_ImageView];
    if (iPhone6Plus) {
        _left_ImageView.sd_layout.leftEqualToView(self.contentView).topEqualToView(self.contentView).widthIs(WidthSpace(252)).heightIs(WidthSpace(196));
    }else {
        if (SCREEN_WIDTH == 320) {
            _left_ImageView.sd_layout.leftEqualToView(self.contentView).topEqualToView(self.contentView).widthIs(110).heightIs(98);
        }else {
            _left_ImageView.sd_layout.leftEqualToView(self.contentView).topEqualToView(self.contentView).widthIs(WidthSpace(252)).heightIs(98);
        }
    }
    
    _title_Label = [[UILabel alloc]init];
    _title_Label.font = DEFAULT_FONT(15);
    _title_Label.textColor = TITLE_TEXT_COLOR;
    [self.contentView addSubview:_title_Label];
    _title_Label.numberOfLines = 2;
    _title_Label.sd_layout.leftSpaceToView(_left_ImageView,10).topSpaceToView(self.contentView,5).rightSpaceToView(self.contentView,10).heightIs(36);
    
    _detail_Label = [[UILabel alloc]init];
    _detail_Label.font = DEFAULT_FONT(14);
    _detail_Label.textColor = TITLE_TEXT_COLOR;
    [self.contentView addSubview:_detail_Label];
    _detail_Label.sd_layout.leftEqualToView(_title_Label).topSpaceToView(_title_Label,5).rightEqualToView(_title_Label).heightIs(20);
    
    _price_Label = [[UILabel alloc]init];
    _price_Label.font = DEFAULT_FONT(13);
    _price_Label.textColor = kNewRedColor;
    [self.contentView addSubview:_price_Label];
    _price_Label.sd_layout.leftSpaceToView(_left_ImageView,10).bottomSpaceToView(self.contentView,5).heightIs(16);
    [_price_Label setSingleLineAutoResizeWithMaxWidth:200];
    
    _time_Label = [[UILabel alloc]init];
    [self.contentView addSubview:_time_Label];
    _time_Label.textColor = TEXT_COLOR;
    _time_Label.font = DEFAULT_FONT(14);
//    _time_Label.text = @"2016-08-12";
    _time_Label.sd_layout.rightEqualToView(_title_Label).bottomEqualToView(_price_Label).heightIs(16).widthIs(120);
    _time_Label.textAlignment = NSTextAlignmentRight;

}
- (void)setUserRoom:(UserPublishRoom *)userRoom {
    _userRoom = userRoom;
    
    if (userRoom.piclist.count > 0) {
        [_left_ImageView sd_setImageWithURL:[NSURL URLWithString:((UserReservePic *)userRoom.piclist[0]).fileurl] placeholderImage:PLACEHOLDER_IMAGE];
    }else {
        _left_ImageView.image = [UIImage imageNamed:@"未上传照片"];
    }
    
    NSString *dateString = [userRoom.releasedate substringToIndex:19];
    NSString *timeString = [DateUitls formateDateWithDateString:dateString];
    
    _time_Label.text = timeString;
    
    if ([XYString isBlankString:userRoom.newness]) {
        //房源
        _title_Label.text = userRoom.title;
        if ([XYString isBlankString:userRoom.bedroom] || userRoom.bedroom.intValue == -1 || userRoom.bedroom.intValue == 0) {
            if ([XYString isBlankString:userRoom.communityname]) {
                _detail_Label.text = [NSString stringWithFormat:@"%@",userRoom.countyname];
            }else {
                _detail_Label.text = [NSString stringWithFormat:@"%@-%@",userRoom.countyname,userRoom.communityname];
            }
        }else {
            
            if ([XYString isBlankString:userRoom.communityname]) {
                _detail_Label.text = [NSString stringWithFormat:@"%@室-%@",userRoom.bedroom,userRoom.countyname];
            }else {
                _detail_Label.text = [NSString stringWithFormat:@"%@室-%@-%@",userRoom.bedroom,userRoom.countyname,userRoom.communityname];
            }
            
        }

            //已发布
            switch (userRoom.sertype.intValue) {
                case 0:
                {
                    
                    if (![XYString isBlankString:userRoom.money] && userRoom.money.intValue != -1) {
                        _price_Label.text = [NSString stringWithFormat:@"￥%@元/月",userRoom.money];
                        NSString *moneyString = [NSString stringWithFormat:@"%@",userRoom.money];
                        NSArray *array = [moneyString componentsSeparatedByString:@"."];
                        if (array.count > 1) {
                            NSString *secondString = array[1];
                            if (secondString.floatValue == 0.00) {
                                _price_Label.text = [NSString stringWithFormat:@"￥%@元/月",array[0]];
                            }
                        }
                        
                    }else {
                        _price_Label.text = @"";
                    }
                    
                    
                }
                    break;
                case 1:
                {

                    if (![XYString isBlankString:userRoom.money] && userRoom.money.intValue != -1) {
                        _price_Label.text = [NSString stringWithFormat:@"￥%@万元",userRoom.money];
                        NSString *moneyString = [NSString stringWithFormat:@"%@",userRoom.money];
                        NSArray *array = [moneyString componentsSeparatedByString:@"."];
                        if (array.count > 1) {
                            NSString *secondString = array[1];
                            if (secondString.floatValue == 0.00) {
                                _price_Label.text = [NSString stringWithFormat:@"￥%@万元",array[0]];
                            }
                        }
                        
                    }else {
                        _price_Label.text = @"";
                    }
                }
                    break;
                case 2:
                {
                    
                    if (userRoom.moneyend.floatValue == 0.00 && userRoom.moneybegin.floatValue == 0.00) {
                        _price_Label.text = @"";
                    }else if (userRoom.moneyend.floatValue == 0.00) {
                        
                        _price_Label.text = [NSString stringWithFormat:@"￥%@元以上/月",userRoom.moneybegin];
                        NSString *moneyString = [NSString stringWithFormat:@"%@",userRoom.moneybegin];
                        NSArray *array = [moneyString componentsSeparatedByString:@"."];
                        if (array.count > 1) {
                            NSString *secondString = array[1];
                            if (secondString.floatValue == 0.00) {
                                _price_Label.text = [NSString stringWithFormat:@"￥%@元以上/月",array[0]];
                            }
                        }
                        
                    }else if (userRoom.moneybegin.floatValue == 0.00) {
                        
                        _price_Label.text = [NSString stringWithFormat:@"￥%@元以下/月",userRoom.moneyend];
                        NSString *moneyString = [NSString stringWithFormat:@"%@",userRoom.moneyend];
                        NSArray *array = [moneyString componentsSeparatedByString:@"."];
                        if (array.count > 1) {
                            NSString *secondString = array[1];
                            if (secondString.floatValue == 0.00) {
                                _price_Label.text = [NSString stringWithFormat:@"￥%@元以下/月",array[0]];
                            }
                        }
                        
                    }else {
                        
                        NSString *moneyString1 = [NSString stringWithFormat:@"%@",userRoom.moneybegin];
                        NSArray *array1 = [moneyString1 componentsSeparatedByString:@"."];
                        if (array1.count > 1) {
                            NSString *secondString = array1[1];
                            if (secondString.floatValue == 0.00) {
                                moneyString1 = array1[0];
                            }
                        }
                        NSString *moneyString2 = [NSString stringWithFormat:@"%@",userRoom.moneyend];
                        NSArray *array2 = [moneyString2 componentsSeparatedByString:@"."];
                        if (array2.count > 1) {
                            NSString *secondString = array2[1];
                            if (secondString.floatValue == 0.00) {
                                moneyString2 = array2[0];
                            }
                        }
                        _price_Label.text = [NSString stringWithFormat:@"￥%@-%@元/月",moneyString1,moneyString2];
                    }
                    NSArray * tmp=@[@"整租一室",@"整租两室",@"整租三室",@"整租四室及以上",@"单间合租"];
                    if([userRoom.bedroom integerValue]==99)
                    {
                        _detail_Label.text=@"单间合租";
                    }
                    else{
                        if([userRoom.bedroom integerValue]-1>=0&&[userRoom.bedroom integerValue]-1<tmp.count)
                        {
                            _detail_Label.text=[NSString stringWithFormat:@"%@ - %@",[tmp objectAtIndex:[userRoom.bedroom integerValue]-1],userRoom.countyname];
                        }
                        
                    }
                    
                }
                    break;
                case 3:
                {

                    if (userRoom.moneyend.floatValue == 0.00 && userRoom.moneybegin.floatValue == 0.00) {
                        _price_Label.text = @"";
                    }else if (userRoom.moneyend.floatValue == 0.00) {
                        _price_Label.text = [NSString stringWithFormat:@"￥%@万元以上",userRoom.moneybegin];
                        NSString *moneyString = [NSString stringWithFormat:@"%@",userRoom.moneybegin];
                        NSArray *array = [moneyString componentsSeparatedByString:@"."];
                        if (array.count > 1) {
                            NSString *secondString = array[1];
                            if (secondString.floatValue == 0.00) {
                                _price_Label.text = [NSString stringWithFormat:@"￥%@万元以上",array[0]];
                            }
                        }
                    }else if (userRoom.moneybegin.floatValue == 0.00) {
                        _price_Label.text = [NSString stringWithFormat:@"￥%@万元以下",userRoom.moneyend];
                        NSString *moneyString = [NSString stringWithFormat:@"%@",userRoom.moneyend];
                        NSArray *array = [moneyString componentsSeparatedByString:@"."];
                        if (array.count > 1) {
                            NSString *secondString = array[1];
                            if (secondString.floatValue == 0.00) {
                                _price_Label.text = [NSString stringWithFormat:@"￥%@万元以下",array[0]];
                            }
                        }
                    }else {
                        NSString *moneyString1 = [NSString stringWithFormat:@"%@",userRoom.moneybegin];
                        NSArray *array1 = [moneyString1 componentsSeparatedByString:@"."];
                        if (array1.count > 1) {
                            NSString *secondString = array1[1];
                            if (secondString.floatValue == 0.00) {
                                moneyString1 = array1[0];
                            }
                        }
                        NSString *moneyString2 = [NSString stringWithFormat:@"%@",userRoom.moneyend];
                        NSArray *array2 = [moneyString2 componentsSeparatedByString:@"."];
                        if (array2.count > 1) {
                            NSString *secondString = array2[1];
                            if (secondString.floatValue == 0.00) {
                                moneyString2 = array2[0];
                            }
                        }
                        _price_Label.text = [NSString stringWithFormat:@"￥%@-%@万元",moneyString1,moneyString2];
                    }
                    
                    if ([XYString isBlankString:userRoom.bedroom] || userRoom.bedroom.intValue == -1 || userRoom.bedroom.intValue == 0) {
                        if ([XYString isBlankString:userRoom.communityname]) {
                            _detail_Label.text = [NSString stringWithFormat:@"%@",userRoom.countyname];
                        }else {
                            _detail_Label.text = [NSString stringWithFormat:@"%@-%@",userRoom.countyname,userRoom.communityname];
                        }
                    }else {
                        
                        if ([XYString isBlankString:userRoom.livingroom] || userRoom.livingroom.intValue == -1) {
                            if ([XYString isBlankString:userRoom.communityname]) {
                                _detail_Label.text = [NSString stringWithFormat:@"%@室0厅-%@",userRoom.bedroom,userRoom.countyname];
                            }else {
                                _detail_Label.text = [NSString stringWithFormat:@"%@室0厅-%@-%@",userRoom.bedroom,userRoom.countyname,userRoom.communityname];
                            }
                        }else {
                            if ([XYString isBlankString:userRoom.communityname]) {
                                _detail_Label.text = [NSString stringWithFormat:@"%@室%@厅-%@",userRoom.bedroom,userRoom.livingroom,userRoom.countyname];
                            }else {
                                _detail_Label.text = [NSString stringWithFormat:@"%@室%@厅-%@-%@",userRoom.bedroom,userRoom.livingroom,userRoom.countyname,userRoom.communityname];
                            }
                        }
                        
                    }
                    
                }
                    break;
                default:
                    break;
            }
            
        
    }else {
        //二手物品
        _title_Label.text = userRoom.name;
        NSString *string = @"";
        if (userRoom.newness.intValue <= 4 && userRoom.newness.intValue > 0) {
            string = @"五成新以下";
        }else {
            switch (userRoom.newness.intValue) {
                case 5:
                {
                    string = @"五成新";
                }
                    break;
                case 6:
                {
                    string = @"六成新";
                }
                    break;
                case 7:
                {
                    string = @"七成新";
                }
                    break;
                case 8:
                {
                    string = @"八成新";
                }
                    break;
                case 9:
                {
                    string = @"九成新";
                }
                    break;
                case 10:
                {
                    string = @"全新";
                }
                    break;
                default:
                    break;
            }
        }
        if ([XYString isBlankString:string]) {
            if ([XYString isBlankString:userRoom.communityname]) {
                _detail_Label.text = [NSString stringWithFormat:@"%@",userRoom.countyname];
            }else {
                _detail_Label.text = [NSString stringWithFormat:@"%@-%@",userRoom.countyname,userRoom.communityname];
            }
            
        }else {
            if ([XYString isBlankString:userRoom.communityname]) {
                _detail_Label.text = [NSString stringWithFormat:@"%@-%@",string,userRoom.countyname];
            }else {
                _detail_Label.text = [NSString stringWithFormat:@"%@-%@-%@",string,userRoom.countyname,userRoom.communityname];
            }
            
        }
        if (userRoom.flag.intValue == 0) {

            if (![XYString isBlankString:userRoom.money]) {
                _price_Label.text = [NSString stringWithFormat:@"￥%@元",userRoom.money];
                NSString *moneyString = [NSString stringWithFormat:@"%@",userRoom.money];
                NSArray *array = [moneyString componentsSeparatedByString:@"."];
                if (array.count > 1) {
                    NSString *secondString = array[1];
                    if (secondString.floatValue == 0.00) {
                        _price_Label.text = [NSString stringWithFormat:@"￥%@元",array[0]];
                    }
                }
                _price_Label.textColor = kNewRedColor;
            }
        }
        
    }
    
    
}

@end
