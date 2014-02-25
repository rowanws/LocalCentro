//
//  loadStoryBoard.h
//  CENTRO
//
//  Created by Marcio R. Arantes on 10/18/13.
//  Copyright (c) 2013 Silvio Salierno. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface loadStoryBoard : NSObject

-(void)segueStoryboard: (NSString *) withName fromVC: (UIViewController *) VC Animation: (BOOL) animation Bundle: (id) bundle useTransitionStyle: (int) style;
-(void)dismissStoryboard: (UIViewController *) VC Animation: (BOOL) animation;

@end
