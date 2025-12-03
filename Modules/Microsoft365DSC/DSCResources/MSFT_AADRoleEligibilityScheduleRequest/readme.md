
# AADRoleEligibilityScheduleRequest

## Description

Represents a request for a role eligibility for a principal through PIM. The role eligibility can be permanently eligible without an expiry date or temporarily eligible with an expiry date.

**Please note:** The difference between start and end times of assignments must be at least 5 minutes. Lower assignment times will result in an error.
Also, if you attempt to remove or update an assignment less than 5 minutes after the last modification, it will fail as well.
