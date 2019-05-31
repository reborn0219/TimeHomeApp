

#import "TableViewDataSource.h"


@interface TableViewDataSource ()
@end


@implementation TableViewDataSource

- (id)init
{
    return nil;
}

- (id)initWithItems:(NSMutableArray *)anItems
     cellIdentifier:(NSString *)aCellIdentifier
 configureCellBlock:(TableViewCellSettingBlock)asettingCellBlock
{
    self = [super init];
    if (self) {
        self.items = anItems;
        self.cellIdentifier = aCellIdentifier;
        self.settingCellBlock = [asettingCellBlock copy];
    }
    return self;
}



- (id)itemDataAtIndexPath:(NSIndexPath *)indexPath
{
    id obj;
    if(self.isSection)
    {
        obj=[self.items[indexPath.section] objectAtIndex:indexPath.row];
    }
    else
    {
        obj=self.items[indexPath.row];
    }
    return obj;
}


#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count=0;
    if (self.isSection) {
        count=[[self.items objectAtIndex:section] count];
    }
    else
    {
        count=self.items.count;
    }
    return count;
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count=1;
    if(self.isSection)
    {
        count=[self.items count];
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if(self.isDefaultCell)
    {
        cell=[tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIdentifier];
        }

    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    }
    
    id item = [self itemDataAtIndexPath:indexPath];
    self.settingCellBlock(cell, item,indexPath);
    return cell;
}

@end
