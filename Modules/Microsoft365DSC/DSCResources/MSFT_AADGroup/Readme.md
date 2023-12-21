# AADGroup

## Description

This resource configures an Azure Active Directory group. IMPORTANT: It does not support mail enabled security groups or mail enabled groups that are not unified or dynamic groups.

If using with AADUser, be aware that if AADUser->MemberOf is being specified and the referenced group is configured with AADGroup->Member then a conflict may arise if the two don't match. It is usually best to choose only one of them. See AADUser
