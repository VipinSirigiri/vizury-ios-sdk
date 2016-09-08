//
//  ViewController.m
//  HelloVizuryIos
//
//  Created by Anurag on 9/8/16.
//  Copyright (c) 2016 Vizury. All rights reserved.
//

#import "ViewController.h"
#import <VizuryEventLogger/VizuryEventLogger.h>


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)testInAppEvent {
    NSDictionary *attributeDictionary  =   [[NSDictionary alloc] initWithObjectsAndKeys:
                                            @"AKSJDASNBD",@"productid",
                                            @"789", @"productPrice",
                                            @"Shirt",@"category",
                                            nil];
    
    [VizuryEventLogger logEvent:@"productPage" WithAttributes:attributeDictionary];
}
@end
