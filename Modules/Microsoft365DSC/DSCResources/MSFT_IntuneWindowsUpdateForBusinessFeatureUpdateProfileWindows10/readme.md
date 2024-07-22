
# IntuneWindowsUpdateForBusinessFeatureUpdateProfileWindows10

## Description

Intune Windows Update For Business Feature Update Profile for Windows10

## RolloutSettings

The RolloutSettings for this resource have the following constraints and notes: 

* When creating a policy:
    * If only a start date is specified, then the start date must be at least today. 
        * If the desired state date is before the current date, it will be adjusted to the current date.
    * If a start and end date is specified, the start date must be the current date + 2 days, and  
      the end date must be at least one day after the start date.
        * If the start date is before the current date + 2 days, it will be adjusted to this date.
* When updating a policy:
    * If only a start date is specified, then the start date must either be the date from the current   
      configuration or the current date (or later). 
        * If the desired state date is before the current date, it will be adjusted to the current date.
    * If a start and end date is specified, the start date must be the current date + 2 days, and  
      the end date must be at least one day after the start date.
        * If the start date is before the current date + 2 days, it will be adjusted to this date.
* When testing a policy:
    * If the policy is missing and the start and end date are before the current date, it will return true.
    * If the start date is different but before the current start date or time, it will return true.
