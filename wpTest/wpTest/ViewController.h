//
//  ViewController.h
//  wpTest
//
//  Created by 大沼英喜 on 2015/01/26.
//  Copyright (c) 2015年 大沼英喜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>


//テーブルの一覧にセットする配列
@property NSArray* items;

//StoryBoardと紐付けたUITableView
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

