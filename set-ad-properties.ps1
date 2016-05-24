#Purpose: update a set of properties in Active Directory (example is email)
#Updates email address to standard unless already exists
#
#Assume organization is acme.com and OU to update is employees
#Assume naming convention is first initial of first name with lastname @ acme.com
#Example: John Doe is jdoe@acme.com set to all lowercase
#Can be used to set properties (i.e., department, address, etc.) for any OU


Import-Module ActiveDirectory
$users = Get-ADUser -Filter * -Properties samaccountname, SurName, EmailAddress, givenName, Surname -SearchBase "OU=EMPLOYEES,DC=ACME,DC=COM"

foreach ($user in $users)
{
	$Firstname=$user.givenName
	$Lastname=$user.Surname
	$Username=$Firstname.substring(0,1)+$Lastname
	$Username=$Username.ToLower()+"@acmeinc.com"

	if($user.EmailAddress)
	{
		echo $user.EmailAddress "email already exists"
	}
	else
	{
		Set-ADUser -Identity $user.samaccountname -EmailAddress $Username
		echo $Username "email created"
	}
}