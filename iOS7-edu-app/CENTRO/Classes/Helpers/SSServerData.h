//
//  SSServerData.h
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSServerData : NSObject

-(void) pullAndShowHUDInViewController: (UIViewController *) viewController;
-(void) pushAndShowHUDinViewController: (UIViewController *) viewController logOutAfter:(BOOL) logOut;

@end