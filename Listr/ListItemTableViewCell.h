//
//  ListItemTableViewCell.h
//  Listr
//
//  Created by Robert Figueras on 9/12/14.
//
//

#import <UIKit/UIKit.h>

@interface ListItemTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UITextField *listItemDescriptionTextField;
@property (strong, nonatomic) IBOutlet UIButton *checkMarkToggleButton;
@end
