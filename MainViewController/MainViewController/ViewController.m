//
//  ViewController.m
//  ViewController
//
//  Created by 大沼英喜 on 2015/01/21.
//  Copyright (c) 2015年 大沼英喜. All rights reserved.
//

#import "ViewController.h"
#include <objc/runtime.h>

//カテゴリで機能拡張
@interface NSMutableArray (Extended)
@property (getter=isExtended) BOOL extended;
@end

@implementation NSMutableArray (Extended)
// アコーディオンが開いているかどうかを設定するところ
- (BOOL)isExtended
{
    return [objc_getAssociatedObject(self, @"extended") boolValue];
}
- (void)setExtended:(BOOL)extended
{
    objc_setAssociatedObject(self, @"extended", [NSNumber numberWithLongLong:extended], OBJC_ASSOCIATION_ASSIGN);
}
@end

// テーブルビュー
@interface ViewController ()
{
    NSMutableArray *topItems;
}
@end

@implementation ViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 親と子供をNSMutableArrayで2次元配列を作成
    NSMutableArray *subItems;
    topItems = [NSMutableArray array];
    subItems = [NSMutableArray array];
    [subItems addObject:@"テスト1"];
    subItems.extended = YES;
    [topItems addObject:subItems];
    
    subItems = [NSMutableArray array];
    subItems.extended = YES;
    [subItems addObject:@"テスト2"];
    [subItems addObject:@"テスト3"];
    [topItems addObject:subItems];
    
    subItems = [NSMutableArray array];
    subItems.extended = YES;
    [subItems addObject:@"テスト4"];
    [subItems addObject:@"テスト5"];
    [subItems addObject:@"テスト6"];
    [topItems addObject:subItems];
    
    subItems = [NSMutableArray array];
    subItems.extended = NO;
    [subItems addObject:@"テスト7"];
    [subItems addObject:@"テスト8"];
    [subItems addObject:@"テスト9"];
    [subItems addObject:@"テスト10"];
    [topItems addObject:subItems];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// ロード時に呼び出される。セクション数を返すように実装する
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [topItems count];
}

// ロード時に呼び出される。セクションに含まれるセル数を返すように実装する
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSMutableArray*)topItems[(NSUInteger) section]).extended ? [topItems[(NSUInteger) section] count] + 1 : 1;
}

// ロード時に呼び出される。セルの内容を返すように実装する
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ParentCellIdentifier = @"ParentCell";
    static NSString *ChildCellIdentifier = @"ChildCell";
    
    NSInteger  section = indexPath.section;
    NSInteger row =indexPath.row;
    NSMutableArray *subItems;
    subItems = topItems[(NSUInteger) section];
    
    UITableViewCell *cell;
    
    NSString *identifier;
    if(row == 0){
        identifier = ParentCellIdentifier;
    } else {
        identifier = ChildCellIdentifier;
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] ;
    }
    
    NSString * strText;
    if(row == 0){
        strText = [NSString stringWithFormat:@" ==== section [ %d ] ==== ", indexPath.section];
    }else{
        strText = [NSString stringWithFormat:@"row ( %d )", indexPath.row];
    }
    
    cell.textLabel.text = strText;
    
    // Configure the cell...
    
    return cell;
}

// タップされたときの動作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger  section = indexPath.section;
    NSInteger row =indexPath.row;
    
    NSMutableArray *subItems;
    
    subItems = topItems[(NSUInteger) section];
    
    if(row == 0){
        subItems.extended = !subItems.extended;
        
        if(subItems.extended == NO){
            [self collapseSubItemsAtIndex:row+1 maxRow:[subItems count]+1 section:section];
        }else{
            [self expandItemAtIndex:row+1 maxRow:[subItems count]+1 section:section];
        }
    }
}

// 縮小アニメーション
- (void)collapseSubItemsAtIndex:(int)firstRow maxRow:(int)maxRow section:(int)section {
    NSMutableArray *indexPaths = [NSMutableArray new];
    for(int i=firstRow;i<maxRow;i++)
    {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}
//拡張アニメーション
- (void)expandItemAtIndex:(int)firstRow maxRow:(int)maxRow section:(int)section {
    NSMutableArray *indexPaths = [NSMutableArray new];
    for(int i=firstRow;i<maxRow;i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:firstRow inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

@end