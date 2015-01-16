//
//  RootViewController.m
//  ShrinkHeaderSample
//
//  Created by Shuji OCHI <ponpoko1968@gmail.com> on 10/10/03.
//  Copyright http://life.ponpoko.tv 2010. All rights reserved.
//

#import "ShrinkHeaderTableViewController.h"

#define CELL_HEIGHT  (50.0f);

@implementation ShrinkHeaderTableViewController

@synthesize headerShrinkStates = headerShrinkStates_;
#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    self.headerShrinkStates = [NSArray arrayWithObjects:
                               [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithBool:YES], @"shrinked",
                                @"勤務地", @"title",
                                [NSArray arrayWithObjects:
                                 @"埼玉県",@"千葉県",@"東京都",nil],@"contents",nil],
                               [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithBool:YES], @"shrinked",
                                @"路線", @"title",
                                [NSArray arrayWithObjects:
                                 @"JR山手線",@"JR中央線(快速)",@"JR中央・総武線",nil],@"contents",nil],
                               [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithBool:YES], @"shrinked",
                                @"時給", @"title",
                                [NSArray arrayWithObjects:
                                 @"テスト",@"crow",@"eagle",@"hawk",nil],@"contents",nil],nil];
}
#pragma mark -
#pragma mark Table view data source


-(void) shrinkRowsInSection:(NSInteger)section {
  NSLog(@"%s:%d section=%d", __FUNCTION__, __LINE__,section );
  UITableView* tableView = (UITableView*)self.view;
  NSMutableArray* array = [NSMutableArray array];


  BOOL shrinked =    [[[self.headerShrinkStates objectAtIndex:section] objectForKey:@"shrinked"] boolValue];

  // prepare to tableView:heightForRowAtIndexPath:, flip and store shrink state
    [[self.headerShrinkStates objectAtIndex:section] setObject:[NSNumber numberWithBool: shrinked ? NO :YES] forKey:@"shrinked"];

  // store  cells to shrink(or expand) to array.
    
  for (int i = 0; i < [self tableView:tableView numberOfRowsInSection:section]; i++) {

//    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:section];
//    [array addObject:indexPath];

  }
  
  [tableView beginUpdates];
  // tell table view to  cells to shrink(or expand).
  [tableView reloadRowsAtIndexPaths:array
		   withRowAnimation:YES];

  [tableView endUpdates];

}


// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [headerShrinkStates_ count];
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [[[headerShrinkStates_ objectAtIndex:section] objectForKey:@"contents"] count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
  return [[headerShrinkStates_ objectAtIndex:section] objectForKey:@"title"];
}
// ヘッダーの高さ指定
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0f;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  NSString *content = [[[headerShrinkStates_ objectAtIndex:[indexPath section]] objectForKey:@"contents"] objectAtIndex:[indexPath row]];

  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:content];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:content] autorelease];
  }
  cell.textLabel.text = content;
  
  return cell;
}

#pragma mark -
#pragma mark Table view delegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  BOOL shrinked  = [[[self.headerShrinkStates objectAtIndex:[indexPath section]] objectForKey:@"shrinked"] boolValue];
  NSLog(@"%s:%d %d", __FUNCTION__, __LINE__, shrinked );

  return shrinked == YES ? 0.0f : CELL_HEIGHT;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
}


- (void)dealloc {
    [super dealloc];
}


@end

