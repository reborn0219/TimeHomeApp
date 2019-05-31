//
//  ActionSheetVC.h
//  TimeHomeApp
//
//  Created by UIOS on 16/3/8.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BaseViewController.h"

@interface ActionSheetVC : UIViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewH;
//@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) UITableView *table;

@property (nonatomic,copy)CellEventBlock block;
@property (nonatomic,copy)NSArray * data;

+(instancetype)shareActionSheet;
-(void)showInVC:(UIViewController *)VC;
-(void)dismiss;
-(void)updateTable;
@end
