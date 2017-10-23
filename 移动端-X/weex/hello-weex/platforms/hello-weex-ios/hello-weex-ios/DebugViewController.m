//
//  ViewController.m
//  demo
//
//  Created by Neeeo on 2017/3/12.
//  Copyright © 2017年 NO. All rights reserved.
//

#import "DebugViewController.h"
#import "WeexViewController.h"

@interface DebugViewController ()

@end

@implementation DebugViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)open:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://localhost:8088/weex/trending-list.js"];
    WeexViewController *controller = [[WeexViewController alloc] initWithSourceURL:url];
    
    [self.navigationController pushViewController:controller animated:YES];
}

@end
