//
//  L_CertifyAddBaseTVC2.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/8/7.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface L_CertifyAddBaseTVC2 : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *leftTitle_Label;

@property (weak, nonatomic) IBOutlet UITextField *right_TF;

//1.20字 2.6字
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) ViewsEventBlock textFieldBlock;

@end
