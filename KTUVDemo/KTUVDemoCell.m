//
//  KTUVDemoCell.m
//  KTUVDemo
//
//  Created by Kyle Truscott on 6/23/14.
//  Copyright (c) 2014 keighl. All rights reserved.
//

#import "KTUVDemoCell.h"
#import "UIImage+ImageEffects.h"

@interface KTUVDemoCell ()

@end

@implementation KTUVDemoCell

#define kBgColorOpacity .5f

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self)
  {
    self.contentView.layer.shouldRasterize = YES;
    self.contentView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.contentView.clipsToBounds = YES;

    self.bgImageView = [UIImageView new];
    self.bgImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.bgImageView.clipsToBounds = YES;
    [self.bgImageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.bgImageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.contentView addSubview:self.bgImageView];

    self.bgColorView = [UIView new];
    self.bgColorView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.bgColorView];

    // AUTOLAYOUT ////////////////

    NSDictionary *views = NSDictionaryOfVariableBindings(_bgImageView, _bgColorView);

    [self.contentView addConstraints:[KTUtil visualConstraints:@"|[_bgImageView]|" views:views]];
    [self.contentView addConstraints:[KTUtil visualConstraints:@"V:|[_bgImageView]|" views:views]];

    [self.contentView addConstraints:[KTUtil visualConstraints:@"|[_bgColorView]|" views:views]];
    [self.contentView addConstraints:[KTUtil visualConstraints:@"V:|[_bgColorView]|" views:views]];

    [self prepareForReuse];
  }
  return self;
}

- (void)prepareForReuse
{
  [super prepareForReuse];
  self.bgImageView.image = nil;
  self.bgColorView.layer.opacity = kBgColorOpacity;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
  [super applyLayoutAttributes:layoutAttributes];

  // Calculate how much the cell has 'grown' towards its active height
  // Featured cells will be 1.0
  // Default cells are 0.0
  // Incoming cells will be somewhere between
  CGFloat hardHeightDiff = kUVCellActiveHeight - kUVCellDefaultHeight;
  CGFloat amountGrown = kUVCellActiveHeight - layoutAttributes.frame.size.height;
  CGFloat percentOfGrowth = MIN(1 - (amountGrown / hardHeightDiff), 1.f);

  if (percentOfGrowth > 0.f)
  {
    CGFloat bgColorOpacity = kBgColorOpacity - (kBgColorOpacity * percentOfGrowth);
    self.bgColorView.layer.opacity = bgColorOpacity;
  }
  else
  {
    self.bgColorView.layer.opacity = kBgColorOpacity;
  }
}

@end
