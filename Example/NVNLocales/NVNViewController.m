//
//  NVNViewController.m
//  NVNLocales
//
//  Created by Inigo Mato on 07/01/2016.
//  Copyright (c) 2016 Inigo Mato. All rights reserved.
//

#import "NVNViewController.h"
#import "NVNView.h"

@interface NVNViewController ()

@end

@implementation NVNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)loadView
{
    self.view = [[[self viewClass] alloc] initWithFrame:[self viewFrame]
                                               delegate:self];
}

- (Class)viewClass
{
    return [NVNView class];
}

- (CGRect)viewFrame
{
    return CGRectMake(0,
                      0,
                      [[UIScreen mainScreen] applicationFrame].size.width,
                      [[UIScreen mainScreen] applicationFrame].size.height);
}

@end
