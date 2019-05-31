//
//  THNickNameTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  带边框的输入框
 *
 *  @param nonatomic
 *  @param strong
 *
 *  @return
 */
#import "THABaseTableViewCell.h"
#import "CustomTextFIeld.h"

@interface THNickNameTVC : THABaseTableViewCell
/**
 *  输入框
 */
@property (nonatomic, strong) CustomTextFIeld *nickNameTF;

@end
