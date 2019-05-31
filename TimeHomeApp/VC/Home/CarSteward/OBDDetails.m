//
//  OBDDetails.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/8/11.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "OBDDetails.h"
#import "OBDDetailsCell.h"
#import "OBDShowAlertVC.h"
#import "CarManagerPresenter.h"
#import "ZSY_OBDModel.h"
@interface OBDDetails ()<UITableViewDelegate,UITableViewDataSource>
{
    
    NSIndexPath *tempIndexpath;
    NSInteger currentIndex;
    ZSY_OBDModel *currentModel;
}
@property (nonatomic,strong)UIView *topView;

@property (nonatomic,strong)UITableView *tableView;

/**
 * 数据项array  当前值array 单位array
 **/
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)NSMutableArray *currentArr;
@property (nonatomic,strong)NSMutableArray *data;


@end

@implementation OBDDetails

#pragma amrk ----------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BLACKGROUND_COLOR;
    self.navigationItem.title = @"OBD详情";
    
    [self createTableView];//列表
    [self createDataSource];//列表数据
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    ///数据统计
    AppDelegate * appdelegate = GetAppDelegates;
    [appdelegate markStatistics:QiCheGuanJia];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //数据统计
    AppDelegate * appdelegate = GetAppDelegates;
    [appdelegate addStatistics:@{@"viewkey":QiCheGuanJia}];
}


#pragma mark -- createView

- (void)createView {
    CGFloat navigation = self.navigationController.navigationBar.frame.size.height;
     /**
     *顶部view
     **/
    _topView = [[UIView alloc] init];
    _topView.backgroundColor = PURPLE_COLOR;
    [self.view addSubview:_topView];
    _topView.sd_layout.topSpaceToView(self.view,8).leftSpaceToView(self.view,8).rightSpaceToView(self.view,8).heightIs(navigation * 3 / 2);
    
    /**
     *左边label
     **/
    UILabel *leftLabel = [[UILabel alloc] init];
    leftLabel.textColor = [UIColor whiteColor];
    leftLabel.text = @"数据项";
    [_topView addSubview:leftLabel];
    leftLabel.font = [UIFont systemFontOfSize:14];
    leftLabel.sd_layout.leftSpaceToView(_topView,15).heightIs(21).centerYEqualToView(_topView);
    [leftLabel setSingleLineAutoResizeWithMaxWidth:60];
    
    
    /**
     *右边label
     **/
    UILabel *rightLabel = [[UILabel alloc] init];
    rightLabel.textColor = [UIColor whiteColor];
    rightLabel.text = @"当前值";
    rightLabel.font = [UIFont systemFontOfSize:14];
    [_topView addSubview:rightLabel];
    rightLabel.sd_layout.rightSpaceToView(_topView,15).heightIs(21).centerYEqualToView(_topView);
    [rightLabel setSingleLineAutoResizeWithMaxWidth:60];
    

    /**
     *竖线view
     **/
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor grayColor];
    [_topView addSubview:lineView];
    lineView.sd_layout.rightSpaceToView(rightLabel,20).heightIs(23).widthIs(6).centerYEqualToView(_topView);
    lineView.layer.cornerRadius = 3.0;
}
#pragma create tableView And dataSource
- (void)createTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(8, self.navigationController.navigationBar.frame.size.height * 3 / 2 + 8, SCREEN_WIDTH - 16, SCREEN_HEIGHT - 64 - (self.navigationController.navigationBar.frame.size.height * 3 / 2 + 8))];

    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = BLACKGROUND_COLOR;

    
    [self.view addSubview:_tableView];
    
    /** 注册 */
    [_tableView registerNib:[UINib nibWithNibName:@"OBDDetailsCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
}


/**
 * dataSource
 **/
- (void)createDataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    
    @WeakObj(self);
    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
    [indicator startAnimating:self.tabBarController];
    [CarManagerPresenter getOBDInfoWithYourCarID:_uCarID andBlock:^(id  _Nullable data, ResultCode resultCode) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator stopAnimating];
            if(resultCode == SucceedCode)
            {
                NSDictionary *dict = (NSDictionary *)data;
                
                
                [_dataSource removeAllObjects];
                NSArray *array = [ZSY_OBDModel mj_objectArrayWithKeyValuesArray:[dict objectForKey:@"map"]];
                
                [_dataSource addObjectsFromArray:array];
                [self createView];
                [selfWeak.tableView reloadData];
                
            }else {
                
                if (_dataSource.count == 0) {
                    
                    [self showNothingnessViewWithType:NoContentTypeData Msg:@"暂无数据" eventCallBack:nil];
                    selfWeak.tableView.hidden = YES;
                    [selfWeak.view sendSubviewToBack:selfWeak.nothingnessView];
                    
                }else {
                    selfWeak.tableView.hidden = NO;

                }
                

            }
            
            
        });

    }];
    
    
       if (!_data) {
        _data = [[NSMutableArray alloc] init];
    }
    [_data addObject:@"OBD标准"];
    
    
    if (!_currentArr) {
        _currentArr = [NSMutableArray array];
    }
    [_currentArr addObject:@"EOBD"];

}




#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_dataSource.count > 0) {
        
        if (section == 0) {
            return [_dataSource count];
        }else {
            
            return 1;
        }
    }else {
        
        return 0;
    }

}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == [_dataSource count] - 1) {
            return 80;
        }
    }
    

    return 50;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"Cell";
    OBDDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (_dataSource.count > 0) {
//        ZSY_OBDModel *OBDModel = _dataSource[indexPath.row];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.section == 1) {
            cell.backgroundColor = BLACKGROUND_COLOR;
            cell.dataItemLabel.textColor = PURPLE_COLOR;
            cell.currentLabel.textColor = PURPLE_COLOR;
            
            cell.dataItemLabel.text = [NSString stringWithFormat:@"%@",_data[indexPath.row]];
            cell.currentLabel.text = [NSString stringWithFormat:@"%@",_currentArr[indexPath.row]];
            
            
            cell.measureLabel.hidden = YES;
            
        }else {
            
            cell.dataItemLabel.textColor = TITLE_TEXT_COLOR;
            cell.currentLabel.textColor = TITLE_TEXT_COLOR;
            cell.backgroundColor = [UIColor whiteColor];
            
//            cell.currentLabel.text = OBDModel.datavalue;
//            cell.dataItemLabel.text = OBDModel.datakey;
//            cell.measureLabel.text = OBDModel.company;
            
            cell.currentLabel.text = _dataSource[indexPath.row];
            cell.dataItemLabel.text = _dataSource[indexPath.row];
            cell.measureLabel.text = _dataSource[indexPath.row];
            cell.measureLabel.hidden = NO;
        }
    }
    
    return cell;
    

}


#pragma mark -- 列表点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        return;
    }
    currentIndex = indexPath.row;
    
    currentModel = _dataSource[currentIndex];

    OBDShowAlertVC *showAlert = [OBDShowAlertVC getInstance];

    //[NSString stringWithFormat:@"什么是%@",currentModel.datakey]
    [showAlert showInVC:self withTitle:[NSString stringWithFormat:@"%@",currentModel.datakey] andSecondTitle:@"" andShowDetailLabelText:[NSString stringWithFormat:@"%@",currentModel.datacontent]];

    @WeakObj(showAlert)
     showAlert.block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index)
    {
        
        if (index == 1) {
            
             ///上一个
            if (currentIndex == 0) {
                currentIndex = _dataSource.count - 1;
            }else {
                currentIndex = currentIndex - 1;
            }
            
            currentModel = _dataSource[currentIndex];

            showAlertWeak.topTitleLabel.text = currentModel.datakey;
            showAlertWeak.topSecondLabel.text = @"";
            showAlertWeak.showDetailLabel.text = [NSString stringWithFormat:@"%@",currentModel.datacontent];
            
        }else if (index == 2) {
            
             ///下一个
            if (currentIndex == _dataSource.count - 1) {
                currentIndex = 0;
            }else {
                currentIndex = currentIndex + 1;
            }
            
            currentModel = _dataSource[currentIndex];

            showAlertWeak.topTitleLabel.text = currentModel.datakey;
            showAlertWeak.topSecondLabel.text = @"";
            showAlertWeak.showDetailLabel.text = [NSString stringWithFormat:@"%@",currentModel.datacontent];
            
        }
    };
}


@end
