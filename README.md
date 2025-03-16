# Bonial
 
Requirement 1: Account Contact Picker & Edit Form Modal
Description
I have created two Lightning Web Components (LWC):

accountContactPicker - Displays account records as picklist values. Upon selecting an account, its related contacts are displayed in a table.
editFormModal - Opens a modal form to edit contact details when clicking a button in the contact table.
Implementation Details
No Apex Class Used: The solution utilizes Lightning Data Service (LDS) for CRUD operations, eliminating the need for custom Apex controllers.
Picklist for Account Selection: Implemented using lightning-record-picker, which dynamically fetches account records.
Contact Data Rendering: Contacts related to the selected account are retrieved and displayed in a table.
Edit Contact in Modal: Clicking the edit button in the table opens the editFormModal component as a pop-up without navigating away from the page.
Video Demonstration
A short video demonstrating the functionality has been added for reference.
