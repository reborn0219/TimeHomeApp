//
//  CarDetectionController.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/8/11.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "CarDetectionController.h"
#import "YYTopCheckView.h"
#import "YYCarCheckTVC.h"

#import "YYCarInfoModel.h"
/**
 *  弹出框
 */
#import "CarPopupView.h"
/**
 *  网络请求
 */
#import "CarManagerPresenter.h"

@interface CarDetectionController ()<UITableViewDelegate, UITableViewDataSource>
{
    /**
     *  计时器时间
     */
    CGFloat timersInter;
}

/**
 *  表格
 */
@property(nonatomic, strong)UITableView *tableView;

/**
 *  请求获得的数据
 */
@property (nonatomic, strong) NSMutableArray *resultArray;

/**
 *  加上错误之后重新排序的数据
 */
@property (nonatomic, strong) NSMutableArray *dataArray;

/**
 *  上方的检测view
 */
@property (nonatomic, strong) YYTopCheckView *topView;

/**
 *  计时器
 */
@property (nonatomic, strong) NSTimer *timer;
/**
 *  已检测的个数
 */
@property (nonatomic, assign) NSInteger count;
/**
 *  分数
 */
@property (nonatomic, strong) NSString *point;
/**
 *  是否显示图片
 */
@property (nonatomic, assign) BOOL isShowImage;
/**
 *  检测时间
 */
@property (nonatomic, assign) NSInteger timeInterval;

/**
 *  进度条
 */
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation CarDetectionController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [_timer invalidate];
    _timer = nil;
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self getCarCodeInfo];              //读取carCode数据

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    
    self.navigationItem.title = @"车况检测";
    
    [self initData];                    //初始化数据
    
    [self setupTopView];                //设置上方的检测view
    
    [self createTableView];             //表的创建
    

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
/**
 *  读取carCode本地数据
 */
- (void)getCarCodeInfo {
    
    _resultArray = [[NSMutableArray alloc] init];
    _dataArray = [[NSMutableArray alloc] init];

    NSString *path = [[NSBundle mainBundle] pathForResource:@"carCodeInfo" ofType:@"txt"];
    NSString *contents = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *contentsArray = [contents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    NSInteger idx;
    for (idx = 0; idx < contentsArray.count; idx++) {
        NSString* currentContent = [contentsArray objectAtIndex:idx];
        NSArray* timeDataArr = [currentContent componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\t"]];
        
        YYCarInfoModel *model = [[YYCarInfoModel alloc] init];
        model.number        = [timeDataArr objectAtIndex:0];
        model.code          = [timeDataArr objectAtIndex:1];
        model.title         = [timeDataArr objectAtIndex:2];
        model.titleEnglish  = [timeDataArr objectAtIndex:3];
        model.type          = [timeDataArr objectAtIndex:4];
        model.content       = [timeDataArr objectAtIndex:5];
        model.isFault       = NO;

        [_resultArray addObject:model];
    }
    
    [_dataArray removeAllObjects];
    [_dataArray addObjectsFromArray:_resultArray];
    
    [_tableView reloadData];
    
    [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];


//    NSLog(@"_resultArray.count====%ld",_resultArray.count);
    
//    if (_resultArray.count > _timeInterval/0.02) {
//        _timeInterval = 10;
//    }else {
//        _timeInterval = (int)((_resultArray.count + 1) * 0.02);
//    }

//    @WeakObj(self);

    /** 获得最后一次检测的结果 */
    /*
    [CarManagerPresenter getLastTestingWithUcarid:_ucarid UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];

            if(resultCode == SucceedCode)
            {
                selfWeak.isShowImage = YES;
                
//处理请求数据-------------------------------------------------------------------------------
                //字典
                selfWeak.point = [NSString stringWithFormat:@"%@",[data objectForKey:@"score"]];
                
                
                for (NSDictionary *diction in [data objectForKey:@"errlist"]) {
                    
                    for (int k = 0; k < selfWeak.resultArray.count; k++) {
                        
                        YYCarInfoModel *model = selfWeak.resultArray[k];
                        if ([model.code isEqualToString:[diction objectForKey:@"faultcode"]]) {
                            [selfWeak.dataArray removeObject:model];
                            model.isFault = YES;
                            [selfWeak.dataArray insertObject:model atIndex:0];
                        }
                        
                    }
                    
                    
                }
                
                NSArray *dailylistArray = [YYCarInfoModel mj_objectArrayWithKeyValuesArray:[data objectForKey:@"dailylist"]];
                for (int i = 0; i < dailylistArray.count; i++) {
                    
                    YYCarInfoModel *model = dailylistArray[i];
                    
                    [selfWeak.resultArray insertObject:model atIndex:i];
                    [selfWeak.dataArray insertObject:model atIndex:i];
                    
                }
                
//处理请求数据-------------------------------------------------------------------------------
                
            }else {
                
            }
            
            [_tableView reloadData];

        });
        
    }];
     */
    
    
    
//    NSLog(@"时间======%ld",(long)_timeInterval);
}

/**
 *  初始化数据
 */
- (void)initData {
    
    _timeInterval       = 10;
    _isShowImage        = NO;
    _count              = 0;
    _point              = @"0";
    timersInter = 0.08;

}
/**
 *  进度条动画
 */
- (void)showAnimation {
    
    if (_shapeLayer) {
        [_shapeLayer removeFromSuperlayer];
    }
    
    UIBezierPath* aPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(SCREEN_WIDTH/2.f - (WidthSpace(236) - 10)/2.f, WidthSpace(64)+5, WidthSpace(236)-10, WidthSpace(236)-10)];
    
    aPath.lineWidth = 1.0;
    aPath.lineCapStyle = kCGLineCapRound; //线条拐角
    aPath.lineJoinStyle = kCGLineCapRound; //终点处理
    
    [aPath stroke];
    
    
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.lineCap = @"round";
    _shapeLayer.lineJoin = @"round";
    _shapeLayer.lineWidth = 1;
    _shapeLayer.strokeColor = [UIColor colorWithWhite:1 alpha:0.5].CGColor;
    _shapeLayer.strokeStart = 0;
    _shapeLayer.strokeEnd = 1;
    _shapeLayer.path = aPath.CGPath;
    _shapeLayer.fillColor = CLEARCOLOR.CGColor;
    [_topView.layer addSublayer:_shapeLayer];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(0.0);
    animation.toValue = @(1);
    _shapeLayer.autoreverses = NO;
    animation.duration = _timeInterval+timersInter;
    
    // 设置layer的animation
    [_shapeLayer addAnimation:animation forKey:nil];
    
}

/**
 *  设置上方的检测view
 */
- (void)setupTopView {
    
    _topView = [[YYTopCheckView alloc] initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH-10, WidthSpace(392))];
    _topView.carNumbel_Label.text = _carNum;
    [self.view addSubview:_topView];

    
    @WeakObj(_topView);
    @WeakObj(self);
    
    //开始检测...
    _topView.checkButtonBlock = ^(UIButton *button) {
        
        //开始检测...
        NSLog(@"开始检测...");
        
        [[THIndicatorVC sharedTHIndicatorVC] startAnimating:selfWeak.tabBarController];
        
        /** 开始检测请求 */
        [CarManagerPresenter startTestingWithUcarid:selfWeak.ucarid UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                
                if(resultCode == SucceedCode) {
                    
                    if (data == nil || [data objectForKey:@"score"] == nil) {
                        
                        selfWeak.topView.checkButton.selected = NO;
                        [selfWeak showToastMsg:@"网络连接错误" Duration:3.0];
                        return ;
                    }
                    
                    [selfWeak.dataArray removeAllObjects];
                    [selfWeak.dataArray addObjectsFromArray:selfWeak.resultArray];
//处理请求数据-------------------------------------------------------------------------------
                    
                    selfWeak.point = [NSString stringWithFormat:@"%@",[data objectForKey:@"score"]];
                    
                    for (NSDictionary *diction in [data objectForKey:@"errlist"]) {
                    
                        for (int k = 0; k < selfWeak.resultArray.count; k++) {
                            
                            YYCarInfoModel *model = selfWeak.resultArray[k];
                            if ([model.code isEqualToString:[diction objectForKey:@"faultcode"]]) {
                                [selfWeak.dataArray removeObject:model];
                                model.isFault = YES;
                                [selfWeak.dataArray insertObject:model atIndex:0];
                            }
                            
                        }
                        
                    }

                    NSArray *dailylistArray = [YYCarInfoModel mj_objectArrayWithKeyValuesArray:[data objectForKey:@"dailylist"]];
                    for (int i = 0; i < dailylistArray.count; i++) {
                        
                        YYCarInfoModel *model = dailylistArray[i];
                        model.isFault = YES;
                        [selfWeak.dataArray insertObject:model atIndex:i];
                        
                    }
//处理请求数据-------------------------------------------------------------------------------
                    
                    
//开始动画-------------------------------------------------------------------------------
                    
                    _count = 0;
                    
                    _isShowImage = NO;
                    
                    [selfWeak.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                    [selfWeak.tableView reloadData];
                    
                    _topViewWeak.backgroundColor = UIColorFromRGB(0xFD8D00);
                    
                    _topViewWeak.checkButton.titleLabel.font = DEFAULT_BOLDFONT(35);
                    
                    [_topViewWeak.checkButton setTitle:@"" forState:UIControlStateNormal];
                    
                    _topViewWeak.check_Label.hidden = NO;
                    _topViewWeak.check_Label.text = @"检测中......";
                    
                    _topViewWeak.rightTop_Label.hidden = NO;
                    
                    _topViewWeak.rightBottom_Label.hidden = NO;
                    
                    _isShowImage = YES;
                    
                    NSLog(@"时间间隔===%f",_timeInterval / _resultArray.count * 1.);
                    
                    _timer = [NSTimer scheduledTimerWithTimeInterval:timersInter target:self selector:@selector(onTimerSelector) userInfo:nil repeats:YES];
                    [selfWeak showAnimation];

//开始动画-------------------------------------------------------------------------------
                }else {
                    
                    selfWeak.topView.checkButton.selected = NO;
                    if ([data isKindOfClass:[NSString class]]) {
                        if (![XYString isBlankString:data]) {
                            [selfWeak showToastMsg:data Duration:3.0];
                        }else {
                            [selfWeak showToastMsg:@"网络连接错误" Duration:3.0];
                        }
                    }

                }
                
            });
            
        }];

    };
}
/**
 *  计时器开始
 *
 *  @param timer
 */
- (void)onTimerSelector {
    
    @WeakObj(self);

    if (_count == _dataArray.count) {
    
        [_timer invalidate];
        _timer = nil;
        
        _topView.checkButton.selected = NO;
        
        _topView.rightTop_Label.hidden = YES;

        _topView.check_Label.text = @"检测完成";
        
        if (_point.floatValue < 50.0) {
            _topView.backgroundColor = PURPLE_COLOR;
            
        }else if (_point.floatValue < 90.0) {
            
            _topView.backgroundColor = UIColorFromRGB(0xFD8D00);

        }else {
            _topView.backgroundColor = UIColorFromRGB(0x1EB21B);
        }
        
        _topView.rightBottom_Label.text = [NSString stringWithFormat:@"已检测%ld项",(unsigned long)_dataArray.count];
        
        [_topView.checkButton setTitle:[NSString stringWithFormat:@"%@",_point] forState:UIControlStateNormal];
        
        /**
         *  检测完成滑动到最上方
         */
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];

        return;
    }
    
    if ( (_dataArray.count - _count) == (_dataArray.count % (int)(_timeInterval / timersInter - 1))) {
        
        _count = _count + _dataArray.count % (int)(_timeInterval / timersInter - 1);
        
        
    }else {
        
        _count = _count + (_dataArray.count - _dataArray.count % (int)(_timeInterval / timersInter - 1) ) / (int)(_timeInterval / timersInter - 1);
        
    }
    
//    if ( (_dataArray.count - _count) == (_dataArray.count % (int)(_timeInterval / 0.02 - 1))) {
//        
//        _count = _count + _dataArray.count % (int)(_timeInterval / 0.02 - 1);
//
//        
//    }else {
//        
//        _count = _count + (_dataArray.count - _dataArray.count % (int)(_timeInterval / 0.02 - 1) ) / (int)(_timeInterval / 0.02 - 1);
//
//    }

    [_topView.checkButton setTitle:[NSString stringWithFormat:@"%.0f",_point.integerValue*(_count*1.f / _dataArray.count)] forState:UIControlStateNormal];
    
    _topView.rightBottom_Label.text = [NSString stringWithFormat:@"%ld项",(long)_count];

//    NSLog(@"====%ld========%f=========%ld========%ld",(long)_count,(_count*1.f / _dataArray.count),(_dataArray.count - _dataArray.count % (int)(_timeInterval / 0.02 - 1)) / (int)(_timeInterval / 0.02 - 1), _dataArray.count % (int)(_timeInterval / 0.02 - 1));
    
    
    [selfWeak.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    
    [UIView animateWithDuration:0.02 animations:^{
        
        [selfWeak.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        
    }];
        
    

    
}

/**
 *  表的创建
 */
- (void)createTableView {
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(5, WidthSpace(392)+10, SCREEN_WIDTH-10, SCREEN_HEIGHT-64-WidthSpace(392)-10) style:UITableViewStylePlain];

    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.backgroundColor = BLACKGROUND_COLOR;
    [_tableView registerClass:[YYCarCheckTVC class] forCellReuseIdentifier:NSStringFromClass([YYCarCheckTVC class])];
    
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    YYCarInfoModel *model = _dataArray[indexPath.row];
//    
//    if (model.rowHeight > 0) {
//    
//        return model.rowHeight;
//        
//    }else {
//        CGSize size = [model.title boundingRectWithSize:CGSizeMake(_tableView.frame.size.width - 12 - 15 - 2*10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:DEFAULT_FONT(14)} context:nil].size;
//        
//        model.rowHeight = size.height + 14;
//        
//        return model.rowHeight;
//    }
    return 28;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YYCarCheckTVC *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YYCarCheckTVC class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_dataArray.count > 0) {
        
        YYCarInfoModel *model = _dataArray[indexPath.row];
        
        cell.contentLabel.text = [NSString stringWithFormat:@"%@  %@",model.code,model.title];
        
        
        if (indexPath.row < _count) {
            
            if (_isShowImage) {
                
                if (model.isFault) {
                    cell.leftImageView.image = [UIImage imageNamed:@"汽车管家-车况检测-异常图标"];
                }else {
                    cell.leftImageView.image = [UIImage imageNamed:@"汽车管家-车况检测-正常图标"];
                }
                
            }else {
                
                cell.leftImageView.image = nil;
            }
            
        }else {
            
            cell.leftImageView.image = nil;
            
        }

    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YYCarInfoModel *model = _dataArray[indexPath.row];
    
    CarPopupView *popupView = [[CarPopupView alloc] init];
    
    if ([XYString isBlankString:model.code]) {
        popupView.hiddenFaultCode = YES;
    }else {
        popupView.hiddenFaultCode = NO;
        popupView.faultNum = model.code;
    }
    
    popupView.faultDescribe = model.title;
    popupView.details = model.content;
    
    [popupView show];
    
}




@end
