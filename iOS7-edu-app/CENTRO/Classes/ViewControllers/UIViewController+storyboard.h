//
//  UIViewController+storyboard.h
//  CENTRO
//
//  Created by Centro Community Partners on 10/19/13.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (storyboard)
-(void)segueStoryboard: (NSString *) withName fromVC: (UIViewController *) VC Animation: (BOOL) animation Bundle: (id) bundle useTransitionStyle: (int) style;
@end
