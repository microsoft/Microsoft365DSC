# AADGroup

## Description

This resource configures an Entra Security group, or a Microsoft 365 group, with either assigned or dynamic membership. IMPORTANT: It does not support mail enabled security groups or mail enabled groups that are not unified or dynamic groups. Instead the EXODistributionGroup resource can be used. To configure the mail related attributes of a Microsoft 365 (Unified) group after it is created, the EXOGroupSettings resource can be used.

If using with AADUser, be aware that if AADUser->MemberOf is being specified and the referenced group is configured with AADGroup->Member then a conflict may arise if the two don't match. It is usually best to choose only one of them. See AADUser
