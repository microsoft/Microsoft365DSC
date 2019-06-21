# Description

This resource allows users to configure a Site Collection as Hub Site
Collection and configure its properties.

NOTE:
The AllowedToJoin parameter accepts e-mail addresses (for users, Office
365 Groups and Mail-Enabled Security groups) or DisplayName (for
Security groups). However, when using DisplayName it is required that
there is only one group with that name. The resource will throw an
exception if there are multiple groups with that name found!
