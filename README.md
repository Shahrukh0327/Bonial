# Bonial
 
# Requirement 1: Account Contact Picker & Edit Form Modal

# Description
I have created two Lightning Web Components (LWC):
  1. accountContactPicker - Displays account records as picklist values. Upon selecting an account, its related contacts are displayed in a table.
  2. editFormModal - Opens a modal form to edit contact details when clicking a button in the contact table.

# Implementation Details
  1. No Apex Class Used: The solution utilizes Lightning Data Service (LDS) for CRUD operations, eliminating the need for custom Apex controllers.
  2. Picklist for Account Selection: Implemented using lightning-record-picker, which dynamically fetches account records.
  3. Contact Data Rendering: Contacts related to the selected account are retrieved and displayed in a lightning data table.
  4. Edit Contact in Modal: Clicking the edit button in the table opens the editFormModal component as a pop-up without navigating away from the page.

# Video Demonstration
A short video demonstrating the functionality has been added for reference.
https://github.com/user-attachments/assets/813ea66a-e40f-4dbe-8284-eb7882d2853b
https://github.com/user-attachments/assets/011879b1-a7ef-48af-91c0-2d4e62585425


