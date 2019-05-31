//
//  MMDateView.h
//  MMPopupView
//
//  Created by Ralph Li on 9/7/15.
//  Copyright © 2015 LJC. All rights reserved.
//

#import "MMPopupView.h"
typedef void(^confirmClick)(NSString *data);
@interface MMDateView : MMPopupView

/**
 *  确认block
 */
@property (nonatomic, strong) confirmClick confirm;
/**
 *  标题
 */
@property (nonatomic, strong) UILabel *titleLabel;
/**
 *  时间选择器
 */
@property (nonatomic, strong) UIDatePicker *datePicker;

+(instancetype)shareDateAlert;

@end
