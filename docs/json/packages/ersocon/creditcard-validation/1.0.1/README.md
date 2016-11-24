# creditcard-validation
Helper functions to check if a given number is a valid cred card number or not

### Description
This library can be used to validate a credit card number. It implements
the Luhn algorithm which checks for the checksum of the card. In general it
works with credit card numbers of all types (Visa, Mastercard, Maestro,
American Express, ...).

Behind the scenes it transforms the given number into a list of strings to
create single digits. This implementation may change in future. API will stay
as is.

The main use case is the validation of credit card numbers entered by users in
an input field. To avoid dependencies to parser libraries there is no
function with the signature of String -> Bool.
