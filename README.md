# Bonial

# Requirement 1: Account Contact Picker & Edit Form Modal

# Description
I have created two Lightning Web Components (LWC):
  1. accountContactPicker - Displays account records as picklist values. Upon selecting an account, its related contacts are displayed in a table.
  2. editFormModal - Opens a modal form to edit contact details when clicking a button in the contact table.

# Implementation Details:
    1. No Apex Class Used: The solution utilizes Lightning Data Service (LDS) for CRUD operations, eliminating the need for custom Apex controllers.
    2. Picklist for Account Selection: Implemented using lightning-record-picker, which dynamically fetches account records.
    3. Contact Data Rendering: Contacts related to the selected account are retrieved and displayed in a lightning data table.
    4. Edit Contact in Modal: Clicking the edit button in the table opens the editFormModal component as a pop-up without navigating away from the page.

# Video Demonstration
A short video demonstrating the functionality has been added for reference.


https://github.com/user-attachments/assets/7e92a578-7fd0-4f99-b2ec-56d5e827e6a5



https://github.com/user-attachments/assets/2b5acf1d-cfc5-4b51-a74b-5080d319c3bd

# Requirement 2: Restricting Sales Team to One Opportunity Per Week
 **Description**
This implementation ensures that a sales team member can create only one opportunity per week. If a user tries to create a new opportunity within the same week while an existing one is still open, they will receive an error message. The user must close the existing opportunity as "Closed Won" or "Closed Lost" before creating a new one.

# Implementation Details
 **- Trigger Implementation:**
    Created an Apex Trigger (OpportunityTrigger) that enforces the validation on before insert and before update.
    Used the Trigger Handler Framework for a structured and scalable approach.
  
 **- Handler and Utility Classes:**
    OpportunityTriggerHandler → Handles logic for before insert and update.
    OpportunityValidationUtility → To avoid repeatition of code and ensures validation logic is reusable.

 **- Permission Set Check:**
    Created a Permission Set to control this restriction.
    The trigger checks if the opportunity owner has the required permission set. If they do and already have an open opportunity in the same week, they cannot create or update another opportunity until the            previous one is Closed Won or Closed Lost.

 **- Salesforce Limitation: Hyperlink Appears as Plain Text in Error Message:**
    Salesforce does not allow hyperlinks in addError() messages. However, the Opportunity link is included in the error message, but it appears as plain text instead of a clickable hyperlink. Users must copy and  
    paste the link manually to access the opportunity.

 **- References:**
    Salesforce Idea: [URL Link in Validation Rule Error Message](https://ideas.salesforce.com/s/idea/a0B8W00000GdlM3UAJ/urllink-on-a-validation-rule-error-message)
    Salesforce Documentation: [addError() Limitation](https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_methods_system_sobject.htm#apex_System_SObject_addError_4)


# Requirement 4: Preventing Unauthorized Access to Customer Data
**Description**
A separate document has been created for the solution to Requirement 4. You can find it in the repository under the name:

# 📂 "Preventing Unauthorized Access to Customer Data"

This document details the security measures implemented to restrict access to financial data, ensuring that:

- Only Relationship Managers can view financial details (transactions).
- Agents can only see customer transactions assigned to them.

For full implementation details, please refer to the document in the repository. ✅
