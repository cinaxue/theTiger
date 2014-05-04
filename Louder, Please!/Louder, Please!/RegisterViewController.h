//
//  RegisterViewController.h
//  caijing
//
//  Created by Cina on 8/21/12.
//  Copyright (c) 2012 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
-(IBAction)goPreviousController:(id)sender;
-(IBAction)goRegister:(id)sender;
@property(nonatomic, retain) IBOutlet UINavigationBar *mNavigationBar;
@property (nonatomic, retain) IBOutlet UIImageView *mBackgroundImage;
@property (nonatomic, retain) IBOutlet UITableView *mTableView;
@property (nonatomic, retain) IBOutlet UIView *mMovingView;


@end
