Rake Sample usage
=================

Use gem to ensure, that rake is installed on your development box.

You can invoke the rake script by using the following command

rake default['smtp','foo@bar.com', 'Here is a new project build', 'this is some odd mail content. It doesn't matter just take the attachment','my_project_package.zip']

Parameters in this call
------------------------

If you've a look at the entire rake script you'll see, that each parameter is manditory for the script execution. The parameters are listed regarding to the position in the sample class
 * MailServer
 * Mail Recipient
 * Mail Subject
 * Mail Content
 * Package Name (will be attached to the mail)

