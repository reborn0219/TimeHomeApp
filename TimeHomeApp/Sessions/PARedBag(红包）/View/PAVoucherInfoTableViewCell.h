//
//  PAVoucherInfoTableViewCell.h
//  TimeHomeApp
//
//  Created by WangKeke on 2018/2/7.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PAVoucherInfoTableViewCell : UITableViewCell

@property (copy,nonatomic) NSString *explanationUrl;

@property (copy,nonatomic) NSString *htmlString;

@property (copy,nonatomic) CellEventBlock heightCallBack;

@end
