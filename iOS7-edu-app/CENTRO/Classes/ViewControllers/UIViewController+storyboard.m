//
//  UIViewController+storyboard.m
//  CENTRO
//
//  Created by Centro Community Partners on 10/19/13.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "UIViewController+storyboard.h"

@implementation UIViewController (storyboard)


-(void)segueStoryboard: (NSString *) withName fromVC: (UIViewController *) VC Animation: (BOOL) animation Bundle: (id) bundle useTransitionStyle: (int) style{
    UIStoryboard *profileStoryBoard = [UIStoryboard storyboardWithName: withName bundle: bundle];
    UIViewController *initProfileView = [profileStoryBoard instantiateInitialViewController];
    initProfileView.modalTransitionStyle = style;
    //[VC presentViewController:initProfileView animated: animation completion: NULL];
    
    [self.navigationController pushViewController:initProfileView animated:YES];
}


@end
