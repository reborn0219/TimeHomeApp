//
//  ModifyRemarkVC.h
//  TimeHomeApp
//
//  Created by UIOS on 16/4/7.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BaseViewController.h"

@interface ModifyRemarkVC : THBaseViewController
@property (weak, nonatomic) IBOutlet UITextField *remarkTF;
@property (weak, nonatomic) IBOutlet UILabel *nikeNameLb;
@property (nonatomic , copy) NSString * userID;
@property (nonatomic , copy) NSString * nikeName;
@property (nonatomic , copy) NSString * remarkname;

@end
