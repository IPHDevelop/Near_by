//
//  AgreeViewController.m
//  SimlpeNear
//
//  Created by Admini on 1/22/17.
//  Copyright © 2017 Admini. All rights reserved.
//

#import "AgreeViewController.h"

@interface AgreeViewController ()

@end

@implementation AgreeViewController

-(IBAction)onCancel:(id)sender{
    exit(0);
}
- (IBAction)onAgree:(id)sender {
//    [SVProgressHUD showWithStatus:@"Loading..."];
//    
//    AFHTTPSessionManager* sessionManager = [AFHTTPSessionManager manager];
//    [sessionManager GET:URL_SERVER parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        
//        NSArray *arrData = [responseObject valueForKey :KEY_AEDS];
//        NSMutableArray *arrLocation = [[NSMutableArray alloc] init];
//        
//        for (int i = 0; i < [arrData count]; i ++) {
//            NSDictionary *dicItem = [arrData objectAtIndex:i];
//            Location *locationItem  = [[Location alloc] initWithInfo:dicItem];
//            
//            [arrLocation addObject:locationItem];
//        }
//        
//        [DataManager sharedManager].arrData = [arrLocation mutableCopy];
//        
//        [SVProgressHUD showSuccessWithStatus:@"Success!"];
    
        UIViewController *vcNext = [self.storyboard instantiateViewControllerWithIdentifier:VC_MAP_VIEW];
        
        [self.navigationController pushViewController:vcNext animated:YES];
        
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@", error.localizedDescription);
//        [SVProgressHUD showErrorWithStatus:@"Loading Fail!"];
//    }
//     
//     ];
//    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
