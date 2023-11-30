# AADUser

## Description

This resource allows users to create Azure AD Users and assign them licenses, roles and/or groups.

If using with AADGroup, be aware that if AADUser->MemberOf is being specified and the referenced group is configured with AADGroup->Member then a conflict may arise if the two don't match. It is usually best to choose only one of them. See AADGroup
