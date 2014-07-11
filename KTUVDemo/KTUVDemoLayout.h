//
//  KTUVDemoLayout.h
//  KTUVDemo
//
//  Created by Kyle Truscott on 6/19/14.
//  Copyright (c) 2014 keighl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTUVDemoUtils.h"

/**
 * A fun Ultravisual-like layout clone!
 *
 * Some inspiration from:
 * http://stackoverflow.com/questions/20250470/ultravisual-iphone-app-like-uiview-or-uitableview-scroll
 * https://github.com/RobotsAndPencils/RPSlidingMenu
 */

@interface KTUVDemoLayout : UICollectionViewLayout

/**
 * The distance the user has drag in order to transition to the next 'featured' cell
 */
@property CGFloat dragInterval;

/**
 * The height of the 'featured' cell
 */
@property CGFloat activeHeight;

/**
 * The default of normal cells (not featured)
 */
@property CGFloat defaultHeight;

@end
