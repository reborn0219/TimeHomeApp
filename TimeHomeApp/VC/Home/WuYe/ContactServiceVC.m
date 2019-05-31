//
//  ContactServiceVC.m
//  TimeHomeApp
//
//  Created by us on 16/3/3.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ContactServiceVC.h"
#import "TableViewDataSource.h"
#import "ContactServiceCell.h"
#import "CommunityManagerPresenters.h"
#import "SysPresenter.h"

@interface ContactServiceVC () <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray * contactData;
    /**
     *  数据源
     */
    TableViewDataSource * dataSource;
}
/**
 *  显示物业联系人列表
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation ContactServiceVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [TalkingData trackPageBegin:@"lianxiwuye"];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    [TalkingData trackPageEnd:@"lianxiwuye"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initView];
    
    if (_fromType == 1 || _fromType == 3) {
        
        NSMutableArray *tempMarr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        if (tempMarr.count > 0) {
            
            [tempMarr removeObjectAtIndex:tempMarr.count-2];
            [tempMarr removeObjectAtIndex:tempMarr.count-2];
            [self.navigationController setViewControllers:tempMarr animated:NO];
            
        }
        
    }
    
    if (_fromType == 2 || _fromType == 4 || _fromType == 5 || _fromType == 6) {
        
        NSMutableArray *tempMarr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        if (tempMarr.count > 0) {
            
            [tempMarr removeObjectAtIndex:tempMarr.count-2];
            
            [self.navigationController setViewControllers:tempMarr animated:NO];
            
        }
        
    }
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getWuYeData];
}

#pragma mark ----------初始化--------------
/**
 *  初始化视图
 */
-(void)initView {
    
    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(0xf7f7f7);
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor clearColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ContactServiceCell" bundle:nil] forCellReuseIdentifier:@"ContactServiceCell"];

    /**
     *  测试数据
     */
    contactData=[NSMutableArray new];

    
}

#pragma mark ----------关于列表数据及协议处理--------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return contactData.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

/**
 *  设置列表高度
 *
 *  @param tableView tableView description
 *  @param indexPath indexPath description
 *
 *  @return return value description
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContactServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactServiceCell"];
    
    L_ContactPropertyModel *model = contactData[indexPath.section];
    cell.model = model;
    
    return cell;
}

//事件处理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    L_ContactPropertyModel *model = contactData[indexPath.section];
    [SysPresenter callPhoneStr:[NSString stringWithFormat:@"%@",model.telephone] withVC:self];

}


#pragma mark --------------网络数据----------------
//获取物业数据
-(void)getWuYeData
{
    if (!_isFromBikeInfo) {
        
        [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self];
        [CommunityManagerPresenters getPropertyPhoneUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                if(resultCode==SucceedCode)
                {
                    if (((NSArray *)data).count > 0) {
                        
                        NSArray *arr = [L_ContactPropertyModel mj_objectArrayWithKeyValuesArray:data];
                        [contactData removeAllObjects];
                        [contactData addObjectsFromArray:arr];
                        [self.tableView reloadData];
                        
                    }else {
                        
                        [self showNothingnessViewWithType:NoContentTypeData Msg:@"没有找到物业资料" eventCallBack:nil];
                        
                    }

                }
                else if(resultCode==FailureCode)
                {
                    if(data==nil||![data isKindOfClass:[NSDictionary class]])
                    {
                        [self showToastMsg:data Duration:5.0];
                    }else {
                        NSDictionary *dicJson=(NSDictionary *)data;

                        NSString * errmsg=[dicJson objectForKey:@"errmsg"];
                        [self showToastMsg:errmsg Duration:5.0];
                    }

                    [self showNothingnessViewWithType:NoContentTypeData Msg:@"没有找到物业资料" eventCallBack:nil];
                    
                }
                else if(resultCode==NONetWorkCode)//无网络处理
                {
                    [self showNothingnessViewWithType:NoContentTypeNetwork Msg:@"链接失败，请检查网络!" eventCallBack:nil];
                    
                }
                
            });
            
        }];

    }else {
        
        [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self];
        
        [CommunityManagerPresenters getPropertyPhoneWithCommunityID:_communityID UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                if(resultCode==SucceedCode)
                {
                    if (((NSArray *)data).count > 0) {
                        
                        NSArray *arr = [L_ContactPropertyModel mj_objectArrayWithKeyValuesArray:data];
                        [contactData removeAllObjects];
                        [contactData addObjectsFromArray:arr];
                        [self.tableView reloadData];
                        
                    }else {
                        
                        [self showNothingnessViewWithType:NoContentTypeData Msg:@"没有找到物业资料" eventCallBack:nil];
                        
                    }

                }
                else if(resultCode==FailureCode)
                {
                    if(data==nil||![data isKindOfClass:[NSDictionary class]])
                    {
                        [self showToastMsg:data Duration:5.0];
                    }else {
                        NSDictionary *dicJson=(NSDictionary *)data;
//                        NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
                        NSString * errmsg=[dicJson objectForKey:@"errmsg"];
                        [self showToastMsg:errmsg Duration:5.0];
                    }

                    [self showNothingnessViewWithType:NoContentTypeData Msg:@"没有找到物业资料" eventCallBack:nil];
                    
                }
                else if(resultCode==NONetWorkCode)//无网络处理
                {
                    [self showNothingnessViewWithType:NoContentTypeNetwork Msg:@"链接失败，请检查网络!" eventCallBack:nil];
                    
                }
                
            });
            
        }];
        
    }
    
}


@end
