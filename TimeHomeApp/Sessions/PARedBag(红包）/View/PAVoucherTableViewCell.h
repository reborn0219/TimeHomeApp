//
//  PAVoucherTableViewCell.h
//  TimeHomeApp
//
//  Created by WangKeke on 2018/2/7.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PARedBagDetailModel.h"


@interface PAVoucherTableViewCell : UITableViewCell


@property (strong,nonatomic) PARedBagDetailModel *voucher;

-(void)hidenDetailLabel:(BOOL)isHidden;


/**
 立即领取红包Block
 */
@property (nonatomic, copy)CellEventBlock cellEventBlock;
@end
