//
//  SearchVCViewController.h
//  TimeHomeApp
//
//  Created by us on 16/4/1.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchVC : UIViewController<UITableViewDelegate>
///输入框背景
@property (weak, nonatomic) IBOutlet UIView *view_BgView;
///左连搜索图标
@property (weak, nonatomic) IBOutlet UIImageView *img_LeftIcon;
///分割线
@property (weak, nonatomic) IBOutlet UIView *view_HLine;
///输入搜索内容
@property (weak, nonatomic) IBOutlet UITextField *TF_SearchText;
///取消搜索
@property (weak, nonatomic) IBOutlet UIButton *btn_Cancel;
///搜索结果列表
@property (weak, nonatomic) IBOutlet UITableView *tableView;
///搜索到的结果
@property(nonatomic,strong) NSMutableArray *searchArray;

///列表点击事件回调处理
@property(nonatomic,copy)CellEventBlock cellEventBlock;
///控件事件回调处理
@property(nonatomic,copy)ViewsEventBlock viewEventBlock;

///列表视图数据赋值
@property(nonatomic,copy)CellEventBlock cellViewBlock;


/**
 *  返回实例
 *
 *  @return return value description
 */
+(SearchVC *)getInstance;
///显示
-(void)showVC:(UIViewController *) parent;

///显示
-(void)showVC:(UIViewController *) parent cellEvent:(CellEventBlock) cellEventBlock viewsEvent:(ViewsEventBlock ) viewEventBlock cellViewBlock:(CellEventBlock) cellViewBlock;

/**
 *  隐藏显示
 */
-(void)dismissVC;
@end
