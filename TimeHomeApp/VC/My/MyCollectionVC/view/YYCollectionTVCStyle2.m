//
//  YYCollectionTVCStyle2.m
//  TimeHomeApp
//
//  Created by 世博 on 16/7/21.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "YYCollectionTVCStyle2.h"
#import "DateUitls.h"

@implementation YYCollectionTVCStyle2

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUp];
        
    }
    return self;
}
- (void)setUp {
    
    
    _title_Label = [[UILabel alloc]init];
    _title_Label.font = DEFAULT_FONT(16);
    _title_Label.textColor = TITLE_TEXT_COLOR;
    [self.contentView addSubview:_title_Label];
    [_title_Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@20);
    }];
    
    _detail_Label = [[UILabel alloc]init];
    _detail_Label.font = DEFAULT_FONT(14);
    _detail_Label.textColor = TEXT_COLOR;
    [self.contentView addSubview:_detail_Label];
    [_detail_Label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_title_Label);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(_title_Label.mas_right);
        make.height.equalTo(@20);
        
    }];
    
    _price_Label = [[UILabel alloc]init];
    _price_Label.font = DEFAULT_FONT(15);
    _price_Label.textColor = kNewRedColor;
    [self.contentView addSubview:_price_Label];
    [_price_Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_title_Label);
        make.width.equalTo(@200);
        make.height.equalTo(@20);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    _time_Label = [[UILabel alloc]init];
    _time_Label.font = DEFAULT_FONT(14);
    _time_Label.textColor = TEXT_COLOR;
    [self.contentView addSubview:_time_Label];
    _time_Label.textAlignment = NSTextAlignmentRight;
    [_time_Label mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView).offset(-10);
        
    }];
    
    
}

- (void)setUserCar:(UserPublishCar *)userCar {
    
    _userCar = userCar;
    
    NSString *dateString = [userCar.releasedate substringToIndex:19];
    NSString *timeString = [DateUitls formateDateWithDateString:dateString];
    
    _time_Label.text = timeString;
    
    _title_Label.text = userCar.title;
    if ([XYString isBlankString:userCar.communityname]) {
        _detail_Label.text = [NSString stringWithFormat:@"%@",userCar.countyname];
        
    }else {
        _detail_Label.text = [NSString stringWithFormat:@"%@ - %@",userCar.countyname,userCar.communityname];
        
    }
    
        //已发布
        switch (userCar.sertype.intValue) {
            case 0:
            {

                if (![XYString isBlankString:userCar.money]) {
                    _price_Label.text = [NSString stringWithFormat:@"%@ 元/月",userCar.money];
                    NSString *moneyString = [NSString stringWithFormat:@"%@",userCar.money];
                    NSArray *array = [moneyString componentsSeparatedByString:@"."];
                    if (array.count > 1) {
                        NSString *secondString = array[1];
                        if (secondString.floatValue == 0.00) {
                            _price_Label.text = [NSString stringWithFormat:@"%@ 元/月",array[0]];
                        }
                    }
                }
                
            }
                break;
            case 1:
            {

                if (![XYString isBlankString:userCar.money]) {
                    _price_Label.text = [NSString stringWithFormat:@"%@ 万元",userCar.money];
                    NSString *moneyString = [NSString stringWithFormat:@"%@",userCar.money];
                    NSArray *array = [moneyString componentsSeparatedByString:@"."];
                    if (array.count > 1) {
                        NSString *secondString = array[1];
                        if (secondString.floatValue == 0.00) {
                            _price_Label.text = [NSString stringWithFormat:@"%@ 万元",array[0]];
                        }
                    }
                }
            }
                break;
            case 2:
            {
                
                if (userCar.moneybegin.floatValue == 0.00) {
                    _price_Label.text = [NSString stringWithFormat:@"%@ 元以下/月",userCar.moneyend];
                    NSString *moneyString = [NSString stringWithFormat:@"%@",userCar.moneyend];
                    NSArray *array = [moneyString componentsSeparatedByString:@"."];
                    if (array.count > 1) {
                        NSString *secondString = array[1];
                        if (secondString.floatValue == 0.00) {
                            _price_Label.text = [NSString stringWithFormat:@"%@ 元以下/月",array[0]];
                        }
                    }
                }else if (userCar.moneyend.floatValue == 0.00) {
                    _price_Label.text = [NSString stringWithFormat:@"%@ 元以上/月",userCar.moneybegin];
                    NSString *moneyString = [NSString stringWithFormat:@"%@",userCar.moneybegin];
                    NSArray *array = [moneyString componentsSeparatedByString:@"."];
                    if (array.count > 1) {
                        NSString *secondString = array[1];
                        if (secondString.floatValue == 0.00) {
                            _price_Label.text = [NSString stringWithFormat:@"%@ 元以上/月",array[0]];
                        }
                    }
                }else {
                    NSString *moneyString1 = [NSString stringWithFormat:@"%@",userCar.moneybegin];
                    NSArray *array1 = [moneyString1 componentsSeparatedByString:@"."];
                    if (array1.count > 1) {
                        NSString *secondString = array1[1];
                        if (secondString.floatValue == 0.00) {
                            moneyString1 = array1[0];
                        }
                    }
                    NSString *moneyString2 = [NSString stringWithFormat:@"%@",userCar.moneyend];
                    NSArray *array2 = [moneyString2 componentsSeparatedByString:@"."];
                    if (array2.count > 1) {
                        NSString *secondString = array2[1];
                        if (secondString.floatValue == 0.00) {
                            moneyString2 = array2[0];
                        }
                    }
                    _price_Label.text = [NSString stringWithFormat:@"%@ - %@元/月",moneyString1,moneyString2];
                }
                
                
            }
                break;
            case 3:
            {

                if (userCar.moneybegin.floatValue == 0.00) {
                    _price_Label.text = [NSString stringWithFormat:@"%@ 万元以下",userCar.moneyend];
                    NSString *moneyString = [NSString stringWithFormat:@"%@",userCar.moneyend];
                    NSArray *array = [moneyString componentsSeparatedByString:@"."];
                    if (array.count > 1) {
                        NSString *secondString = array[1];
                        if (secondString.floatValue == 0.00) {
                            _price_Label.text = [NSString stringWithFormat:@"%@ 万元以下",array[0]];
                        }
                    }
                }else if (userCar.moneyend.floatValue == 0.00) {
                    _price_Label.text = [NSString stringWithFormat:@"%@ 万元以上",userCar.moneybegin];
                    NSString *moneyString = [NSString stringWithFormat:@"%@",userCar.moneybegin];
                    NSArray *array = [moneyString componentsSeparatedByString:@"."];
                    if (array.count > 1) {
                        NSString *secondString = array[1];
                        if (secondString.floatValue == 0.00) {
                            _price_Label.text = [NSString stringWithFormat:@"%@ 万元以上",array[0]];
                        }
                    }
                }else {
                    NSString *moneyString1 = [NSString stringWithFormat:@"%@",userCar.moneybegin];
                    NSArray *array1 = [moneyString1 componentsSeparatedByString:@"."];
                    if (array1.count > 1) {
                        NSString *secondString = array1[1];
                        if (secondString.floatValue == 0.00) {
                            moneyString1 = array1[0];
                        }
                    }
                    NSString *moneyString2 = [NSString stringWithFormat:@"%@",userCar.moneyend];
                    NSArray *array2 = [moneyString2 componentsSeparatedByString:@"."];
                    if (array2.count > 1) {
                        NSString *secondString = array2[1];
                        if (secondString.floatValue == 0.00) {
                            moneyString2 = array2[0];
                        }
                    }
                    _price_Label.text = [NSString stringWithFormat:@"%@ - %@ 万元",moneyString1,moneyString2];
                }
                
            }
                break;
            default:
                break;
        }
        
    
}

@end
