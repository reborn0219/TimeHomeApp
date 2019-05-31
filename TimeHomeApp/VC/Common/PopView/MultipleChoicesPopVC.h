//
//  MultipleChoicesPopVC.h
//  TimeHomeApp
//
//  Created by us on 16/3/16.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 *  多选集合
 */
#import "BaseViewController.h"

///多选数据
@interface MultipleChoicesModel: NSObject
///id
@property(nonatomic,strong) NSString * ID;
///显示
@property(nonatomic,strong) NSString * title;
///选中 YES  没有选中NO
@property(nonatomic,assign) BOOL isSelect;

///正在选择中 YES选中  NO没有选中
@property(nonatomic,assign) BOOL isSelecting;

///是否点了确认 YES是
@property(nonatomic,assign) BOOL isOK;

@end


@interface MultipleChoicesPopVC : BaseViewController

/**
 *  标题
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Title;
/**
 *  集合
 */
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

/**
 *  多选数据
 */
@property(nonatomic,strong)NSArray * arryLabTitle;
/**
 *  事件回调
 */
@property(nonatomic,copy) ViewsEventBlock eventCallBack;
/**
 *  默认开始位置
 */
@property(nonatomic,assign) int start;
/**
 *  默认结束位置
 */
@property(nonatomic,assign) int end;

/**
 *  获取实例
 *
 *  @return return value PricePopVC
 */
+(MultipleChoicesPopVC *)getInstance;


/**
 *  显示
 *
 *  @param parent       上级控制器
 *  @param data     标尺段标题数据
 *  @param callBack 事件回调
 */
-(void)showPopView:(UIViewController *) parent data:(NSArray *) data eventCallBack:(ViewsEventBlock) callBack;
@end
