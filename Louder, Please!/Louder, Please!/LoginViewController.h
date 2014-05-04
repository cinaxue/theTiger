//
//  LoginViewController.h
//  caijing
//
//  Created by Cina on 8/21/12.
//  Copyright (c) 2012 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
-(IBAction)goPreviousController:(id)sender;
-(IBAction)goRegisterController:(id)sender;
-(IBAction)goLoginController:(id)sender;
@property (nonatomic, retain) IBOutlet UIView *mMovingView;
@property(nonatomic, retain) IBOutlet UINavigationBar *mNavigationBar;
@property (nonatomic, retain) IBOutlet UIImageView *mBackgroundImage;
@property (nonatomic, retain) IBOutlet UITableView *mTableView;

@end
