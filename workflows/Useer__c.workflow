<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_Email_on_creation_of_the_user</fullName>
        <description>Send Email on creation of the user</description>
        <protected>false</protected>
        <recipients>
            <field>User_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/Username_and_Password_Information</template>
    </alerts>
    <rules>
        <fullName>Send Username and Password Information</fullName>
        <actions>
            <name>Send_Email_on_creation_of_the_user</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Useer__c.User_Name__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Useer__c.Password__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Useer__c.IsActive__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>This is used to send the username and password of the timesheet employee.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
