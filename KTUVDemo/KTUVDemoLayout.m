//
//  KTUVDemoLayout.m
//  KTUVDemo
//
//  Created by Kyle Truscott on 6/19/14.
//  Copyright (c) 2014 keighl. All rights reserved.
//

#import "KTUVDemoLayout.h"

@interface KTUVDemoLayout ()

/**
 * Storage for all layoutAttributes
 */
@property (strong) NSDictionary *layoutInfo;

@end

@implementation KTUVDemoLayout

- (id)init
{
  self = [super init];
  if (self)
  {
    self.layoutInfo = [NSDictionary new];
  }
  return self;
}

- (void)prepareLayout
{
  NSMutableDictionary *newLayoutInfo = [NSMutableDictionary new];
  NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
  NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
  CGFloat contentOffsetTop = self.collectionView.contentOffset.y;

  int currentIndex = MAX(contentOffsetTop / self.dragInterval, 0);
  float currentIndexF = contentOffsetTop / self.dragInterval;

  // The current 'inbetween' index value. Used to size position the featured cell, and size the incoming cell
  float interpolation = currentIndexF - currentIndex;

  // Holds frame info for the previous calculated cell
  CGRect lastRect;

  for (NSInteger item = 0; item < itemCount; item++)
  {
    indexPath = [NSIndexPath indexPathForItem:item inSection:0];

    UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

    // Cells overlap each other ascending
    itemAttributes.zIndex = item;

    CGFloat yOffset = 0.f;

    // The current featured cell
    if (currentIndex == item)
    {
      // Is the content offset past the top inset?
      if (contentOffsetTop > self.collectionView.contentInset.top)
      {
        // Place the feautured cell at the current content offset, and back it off the screen based on how close we are to the next index
        CGFloat yDelta = self.defaultHeight * (interpolation);
        yOffset = ceilf(contentOffsetTop - yDelta);
      }

      // Build that frame, yo! Set the height to the activeHeight value
      itemAttributes.frame = CGRectMake(0, yOffset, self.collectionView.bounds.size.width, self.activeHeight);
      lastRect = itemAttributes.frame;
    }
    // The 'incoming' cell
    else if (item == currentIndex + 1)
    {
      // Calculate how much the cell should 'grow' based on how close it is to becomming featured
      CGFloat heightDelta = MAX((self.activeHeight - self.defaultHeight) * interpolation, 0);
      CGFloat height = ceilf(self.defaultHeight + heightDelta);

      // Position the BOTTOM of this cell [defaultHeight] pts below the featured cell (lastRect). This is how they visually overlap
      CGFloat yOffset = lastRect.origin.y + lastRect.size.height + self.defaultHeight - height;
      itemAttributes.frame = CGRectMake(0, yOffset, self.collectionView.bounds.size.width, height);
      lastRect = itemAttributes.frame;
    }
    // Cells before the current featured cell
    else if (item < currentIndex)
    {
      // Hide that shit offscreen!
      itemAttributes.frame = CGRectMake(0, -5.f, self.collectionView.bounds.size.width, 0);
    }
    else
    // Cells beyond the featured/incoming cells
    {
      // Stack it below the last frame
      yOffset = lastRect.origin.y + lastRect.size.height;
      itemAttributes.frame = CGRectMake(0, yOffset, self.collectionView.bounds.size.width, self.defaultHeight);
      lastRect = itemAttributes.frame;
    }

    // Store the itemAttributes
    newLayoutInfo[indexPath] = itemAttributes;
  }

  // Store all the new layoutAttributes
  self.layoutInfo = newLayoutInfo;
}

- (CGSize)collectionViewContentSize
{
  NSInteger items = [self.collectionView numberOfItemsInSection:0];
  CGSize size = CGSizeMake(self.collectionView.bounds.size.width, (items * self.dragInterval) + (self.collectionView.frame.size.height - self.dragInterval));
  return size;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
  NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:self.layoutInfo.count];

  [self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attributes, BOOL *innerStop) {
    if (CGRectIntersectsRect(rect, attributes.frame))
      [allAttributes addObject:attributes];
  }];

  return allAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
  return self.layoutInfo[indexPath];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
  return YES;
}

@end
