//
//  loadStoryBoard.m
//  CENTRO
//
//  Created by Marcio R. Arantes on 10/18/13.
//  Copyright (c) 2013 Silvio Salierno. All rights reserved.
//

#import "loadStoryBoard.h"

@implementation loadStoryBoard


-(void)segueStoryboard: (NSString *) withName fromVC: (UIViewController *) VC Animation: (BOOL) animation Bundle: (id) bundle useTransitionStyle: (int) style{
    UIStoryboard *profileStoryBoard = [UIStoryboard storyboardWithName: withName bundle: bundle];
    UIViewController *initProfileView = [profileStoryBoard instantiateInitialViewController];
    initProfileView.modalTransitionStyle = style;
    [VC presentViewController:initProfileView animated: animation completion: NULL];
}

-(void)dismissStoryboard: (UIViewController *) VC Animation: (BOOL) animation{
    [VC dismissViewControllerAnimated:animation completion: NULL];
}

@end
