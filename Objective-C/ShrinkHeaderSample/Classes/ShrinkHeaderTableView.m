//
//  ShringHeaderTableView.m
//  ShrinkHeaderSample
//
//  Created by Shuji OCHI <ponpoko1968@gmail.com> on 10/10/03.
//  Copyright 2010 http://life.ponpoko.tv. All rights reserved.
//

#import "ShrinkHeaderTableView.h"




@implementation ShrinkHeaderTableView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}


- (void)dealloc {
    [super dealloc];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
  UITouch* touch = [[touches allObjects] objectAtIndex:0];
  CGPoint pt = [touch locationInView:self];
  UITableView* tableView = self;
  for (int i=[self.dataSource numberOfSectionsInTableView:tableView]-1; i >= 0  ; i--) {
    CGRect headerArea =     [tableView rectForHeaderInSection:i];
    if(CGRectContainsPoint( headerArea, pt )){
      NSLog(@"%s:%d ", __FUNCTION__, __LINE__ );
      [self.delegate shrinkRowsInSection: i ];
      break;
    }
  }
}

@end
