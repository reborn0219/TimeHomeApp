//
//  SearchFriendsVC.m
//  TimeHomeApp
//
//  Created by UIOS on 16/3/15.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "SearchFriendsVC.h"

#import "FriendsCell.h"
#import "ChatPresenter.h"
#import "RecentlyFriendModel.h"
#import "DateTimeUtils.h"
#import "ChatViewController.h"
#import "PersonalDataVC.h"
#import "THMyInfoPresenter.h"
#import "WebViewVC.h"

#import "personListViewController.h"
@interface SearchFriendsVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>


{
    UITableView * table;
    NSMutableArray * searchArr;
    
}
@end

@implementation SearchFriendsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchV.layer.borderWidth = 1;
    self.searchV.layer.borderColor = LINE_COLOR.CGColor;
    self.searchTF.delegate = self;
    searchArr = [[NSMutableArray alloc]initWithCapacity:0];
    
    // Do any additional setup after loading the view.
    table = [[UITableView alloc]initWithFrame:CGRectMake(10,44+statuBar_Height, SCREEN_WIDTH-20, SCREEN_HEIGHT-(44+statuBar_Height)) style:UITableViewStyleGrouped];
    table.delegate =self;
    table.dataSource=self;
    [self.view setBackgroundColor:UIColorFromRGB(0xf1f1f1)];
    [table setBackgroundColor:UIColorFromRGB(0xf1f1f1)];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
    [table registerNib:[UINib nibWithNibName:@"FriendsCell" bundle:nil] forCellReuseIdentifier:@"friendsCell"];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self.searchTF becomeFirstResponder];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = NO;

}

#pragma mark - tableviewDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FriendsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"friendsCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    RecentlyFriendModel * RFML = [searchArr objectAtIndex:indexPath.row];
    cell.nameLb.text = RFML.nickname;
    cell.ageLb.text = RFML.age;
    cell.contentLb.text = RFML.signature;
    [cell.imgV sd_setImageWithURL:[NSURL URLWithString:RFML.userpic] placeholderImage:PLACEHOLDER_IMAGE];
    
    [cell.timeLb setHidden:YES];
    

    return cell;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return searchArr.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 80;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RecentlyFriendModel * UIML = [searchArr objectAtIndex:indexPath.row];
    
    if ([XYString isBlankString:UIML.userID]) {
        return;
    }
    
    //点赞头像点击
    personListViewController *personList = [[personListViewController alloc]init];
    [personList getuserID:UIML.userID];
    personList.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personList animated:YES];
   
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma  mark - UITextFieldDelegate

- (IBAction)editingChanged:(id)sender {
    
    if ([XYString isBlankString:self.searchTF.text]) {
        [searchArr removeAllObjects];
        [table reloadData];

        return;
    }
    @WeakObj(table)
    [ChatPresenter getAppSearchuser:^(id  _Nullable data, ResultCode resultCode) {

        NSLog(@"%@",data);
        NSLog(@"searchArr－－－%@",data);
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            switch (resultCode) {
                case SucceedCode:
                {
                    [searchArr removeAllObjects];
                    [searchArr addObjectsFromArray:data];
                    [tableWeak reloadData];
                    
                }
                    break;
                case FailureCode:
                {
                    NSLog(@"没有数据");
                    [searchArr removeAllObjects];
                    [tableWeak reloadData];

                }
                    break;
                    
                default:
                    break;
            }

        });
        

    } withPage:@"1" andName:self.searchTF.text];
    
}
@end
