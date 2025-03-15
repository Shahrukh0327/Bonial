/**
 * @description       : 
 * @author            : Shahrukh Ahmed 
 * @last modified on  : 15-03-2025
 * @last modified by  : Shahrukh Ahmed 
**/
import { LightningElement, wire } from 'lwc';
import { getRelatedListRecords } from 'lightning/uiRelatedListApi';
const columns = [

    {
        label: 'Contact', fieldName: 'Url', type: 'url',
        typeAttributes: { label: { fieldName: "Name" }, target: "_self" },
    },
    { label: 'Title', fieldName: 'Title' },
    { label: 'Phone', fieldName: 'Phone', type: 'phone' },
    { label: 'Email', fieldName: 'Email', type: 'email' },
    {
        label: "Actions",
        type: "button-icon",
        fieldName: "Actions",
        wrapText: true,
        cellAttributes: { alignment: "center" },
        typeAttributes: {
            iconName: "utility:edit",
            variant: "brand",
            name: "Edit",
            title: "Edit",
            value: "edit",
            iconPosition: "left",
            alternativeText: "Edit"
        }
    },
];

export default class AccountContactPicker extends LightningElement {

    accountId;
    title = 'Account Related Contact';
    label = 'Account';
    objectApiName = 'Account';
    relatedObject;
    isModalOpen = false;
    columns = columns;
    relatedContacts;
    isDataTable = false;
    selectedContactId;
    error;
    handleAccountChange(event) {
        this.error = '';
        this.accountId = event.detail.recordId;
        if (!this.accountId) {
            this.isDataTable = false;
        }
    }


    @wire(getRelatedListRecords, {
        parentRecordId: '$accountId',
        relatedListId: 'Contacts',
        fields: ['Contact.Name', 'Contact.Id', 'Contact.Title', 'Contact.Phone', 'Contact.Email'],
        sortBy: ['Contact.Name']
    })
    listInfo({ error, data }) {

        if (data && data.records.length > 0) {
            this.relatedObject = data.records[0].apiName;
            this.relatedContacts = data.records.map(record => ({
                Id: record.fields.Id.value,
                Name: record.fields.Name.value,
                Url: `/lightning/r/${record.fields.Id.value}/view`,
                Title: record.fields.Title.value,
                Phone: record.fields.Phone.value,
                Email: record.fields.Email.value,
            }));

            this.isDataTable = true;
            this.error = '';

        } else if (error) {
            console.error(error);
            this.error = error;
            this.relatedContacts = '';
        }
        else if (data && data.records.length === 0) {
            this.error = "No records Found!";
        }
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        if (actionName === "Edit") {
            this.selectedContactId = event.detail.row.Id;
            this.isModalOpen = true;
        }
    }

    // Close Modal
    handleModalClose() {
        this.isModalOpen = false;
    }

    // Close Error
    handleErrorClose() {
        this.error = '';
    }

}