//
//  SSAboutCENTROViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSAboutCENTROViewController.h"

@interface SSAboutCENTROViewController ()

@end

@implementation SSAboutCENTROViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //UIImage *bg40 = [UIImage imageNamed:@"bg-568h@2x.png"];
    //UIImage *bg35R = [UIImage imageNamed:@"bg.png"];
    
    //CGRect screenBounds = [[UIScreen mainScreen] bounds];
    //if (screenBounds.size.height == 568) {
    //    self.backgroundImageView.image = bg40;
    //} else {
    //    self.backgroundImageView.image = bg35R;
    //}
    
    self.navigationItem.title = @"CENTRO";
    
    
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *build = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    
    self.aboutTextView.text = [NSString stringWithFormat:@"Centro Community Partners is a leading provider of entrepreneurship education and training support.  Our goal is to provide entrepreneurs with tools to grow their businesses and access capital.\n\nWe welcome you to use this app as a first step toward creating your business plan.  We hope you find it useful and welcome all feedback at comments@centrocommunity.org\n\nPTo learn about partnership licensing opportunities, contact partners@centrocommunity.org\n\nVersion: %@. Build: %@.", version, build];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end