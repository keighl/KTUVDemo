//
//  KTUVDemoController.m
//  KTUVDemo
//
//  Created by Kyle Truscott on 6/19/14.
//  Copyright (c) 2014 keighl. All rights reserved.
//

#import "KTUVDemoController.h"
#import "KTUVDemoLayout.h"
#import "UIColor+KTExtras.h"

@interface KTUVDemoController ()
@property (strong) UICollectionView *collectionView;
@property (strong) KTUVDemoLayout *layout;
@property (strong) NSArray *content;
@end

@implementation KTUVDemoController

#define kDragVelocityDampener .85

- (void)viewDidLoad
{
  [super viewDidLoad];

  self.view.backgroundColor = [UIColor blackColor];

  self.content = @[
                   @{
                     @"image" : @"1.jpg",
                     },
                   @{
                     @"image" : @"2.jpg",
                     },
                   @{
                     @"image" : @"3.jpg",
                     },
                   @{
                     @"image" : @"4.jpg",
                     },
                   @{
                     @"image" : @"5.jpg",
                     },
                   @{
                     @"image" : @"6.jpg",
                     },
                   @{
                     @"image" : @"7.jpg",
                     },
                   @{
                     @"image" : @"8.jpg",
                     },
                   @{
                     @"image" : @"1.jpg",
                     },
                   @{
                     @"image" : @"2.jpg",
                     },
                   @{
                     @"image" : @"3.jpg",
                     },
                   @{
                     @"image" : @"4.jpg",
                     },
                   @{
                     @"image" : @"5.jpg",
                     },
                   @{
                     @"image" : @"6.jpg",
                     },
                   @{
                     @"image" : @"7.jpg",
                     },
                   @{
                     @"image" : @"8.jpg",
                     },
                   ];

  self.layout = [KTUVDemoLayout new];
  self.layout.activeHeight = kUVCellActiveHeight;
  self.layout.defaultHeight = kUVCellDefaultHeight;
  self.layout.dragInterval = kUVCellDragInterval;

  self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
  self.collectionView.backgroundColor = [UIColor blackColor];
  self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
  self.collectionView.dataSource = self;
  self.collectionView.delegate = self;
  self.collectionView.alwaysBounceVertical = YES;
  self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast; // Faster deceleration!
  self.collectionView.scrollsToTop = YES;
  [self.collectionView registerClass:[KTUVDemoCell class] forCellWithReuseIdentifier:@"KTUVDemoCell"];
  [self.view addSubview:self.collectionView];

  // AUTOLAYOUT ////////////////

  NSDictionary *views = NSDictionaryOfVariableBindings(_collectionView);

  [self.view addConstraints:[KTUtil visualConstraints:@"|[_collectionView]|" views:views]];
  [self.view addConstraints:[KTUtil visualConstraints:@"V:|[_collectionView]|" views:views]];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:YES animated:animated];
  self.collectionView.contentInset = UIEdgeInsetsZero;

  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
  
  if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    [self setNeedsStatusBarAppearanceUpdate];

}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
  return UIStatusBarStyleLightContent;
}
#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return self.content.count;
}

#pragma mark UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  KTUVDemoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KTUVDemoCell"
                                                                         forIndexPath:indexPath];

  NSDictionary *dict = self.content[indexPath.row];

  cell.bgImageView.image = [UIImage imageNamed:dict[@"image"]];
  cell.bgColorView.backgroundColor = [UIColor blackColor];

  return cell;
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset
{
  /**
   * Here we target a specific cell index to move towards
   */

  NSInteger nextIndex;
  CGFloat currentY = scrollView.contentOffset.y;
  CGFloat yDiff = abs(targetContentOffset->y - currentY);

  if (velocity.y == 0.f)
  {
    // A 0 velocity means the user dragged and stopped (no flick)
    // In this case, tell the scroll view to animate to the closest index
    nextIndex = roundf(targetContentOffset->y / kUVCellDragInterval);
    *targetContentOffset = CGPointMake(0, nextIndex * kUVCellDragInterval);
  }
  else if (velocity.y > 0.f)
  {
    // User scrolled downwards
    // Evaluate to the nearest index
    // Err towards closer a index by forcing a slightly closer target offset
    nextIndex = ceil((targetContentOffset->y - (yDiff*kDragVelocityDampener)) / kUVCellDragInterval);
  }
  else
  {
    // User scrolled upwards
    // Evaluate to the nearest index
    // Err towards closer a index by forcing a slightly closer target offset
    nextIndex = floor((targetContentOffset->y + (yDiff*kDragVelocityDampener)) / kUVCellDragInterval);
  }

  // Return our adjusted target point
  *targetContentOffset = CGPointMake(0, MAX(nextIndex*kUVCellDragInterval, self.collectionView.contentInset.top));
}

@end
