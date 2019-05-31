//
//  rightPushCarNumber.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/8/15.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "rightPushCarNumber.h"
#import "ZSY_RightPushCell.h"
#import "CarStewardFirstVC.h"

#import "CarManagerPresenter.h"
#import "ZSY_RightCarListModel.h"
#import "LS_CarInfoModel.h"

#define W [UIScreen mainScreen].bounds.size.width/4
@implementation rightPushCarNumber

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createTableView];
        [self createDataSource];
        _shadowHidden = YES;
       
        
    }
    return self;
}

- (void)setDataSource:(NSMutableArray *)dataSource {
    
//    _dataSource = dataSource;
}
#pragma mark -- 设置阴影
- (void)setShadowHidden:(BOOL)shadowHidden {
    
    if (shadowHidden != YES) {
        
        self.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
        self.layer.shadowOffset = CGSizeMake(1, 1);//偏移距离
        self.layer.shadowOpacity = 0.8;//不透明度
        self.layer.shadowRadius = 15.0;//半径
    }
    
}



- (void)createTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, W - 10, SCREEN_HEIGHT - 10 - (44+statuBar_Height)) style:UITableViewStyleGrouped];
//    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, W, [UIScreen mainScreen].bounds.size.height)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"ZSY_RightPushCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
}

#pragma amrk -- tableView数据源
- (void)createDataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    @WeakObj(_tableView);
    [CarManagerPresenter getCarlist:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            if (resultCode == SucceedCode) {
                
                _dataSource = [LS_CarInfoModel mj_objectArrayWithKeyValuesArray:data];
//                [_dataSource addObject:arr];
                [_tableViewWeak reloadData];
                
            }
            
            
        });
        
        
    }];
    

}


#pragma mark -- tableViewDataSource And tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataSource.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        return W-10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZSY_RightPushCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    tableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (_dataSource.count != 0) {
        LS_CarInfoModel * LCIML = [_dataSource objectAtIndex:indexPath.row];
        
        //    _carList = _dataSource[indexPath.row];
        
        
        tableViewCell.carNumber.text = LCIML.card;
//        [tableViewCell.carIcon sd_setImageWithURL:[NSURL URLWithString:LCIML.picurl] placeholderImage:[UIImage imageNamed:@"图片加载失败"]];
//        [tableViewCell.carIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_PIC_URL,LCIML.picurl]] placeholderImage:[UIImage imageNamed:@"图片加载失败"]];
        [tableViewCell.carIcon sd_setImageWithURL:[NSURL URLWithString:LCIML.picurl] placeholderImage:[UIImage imageNamed:@"图片加载失败"]];

    }
    
//    tableViewCell.carNumber.text = [NSString stringWithFormat:@"%@",_dataSource[indexPath.row]];
    
    return tableViewCell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LS_CarInfoModel * LCIML = [_dataSource objectAtIndex:indexPath.row];
    
//    ZSY_RightPushCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
//    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:LCIML.carID,@"textOne", nil];
    NSDictionary *dic = @{@"textOne":LCIML.carID,@"carNumber":LCIML.card};
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"switchCarTongZhi" object:nil userInfo:dic];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    
    
//    self.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, 0, 0, [UIScreen mainScreen].bounds.size.height);
    
//    [_tableView removeFromSuperview];
    [self removeFromSuperview];

    
}



@end
