# Phone

A library for converting plain number to desired country's phone format.
Supports ISO2 codes for 232 countries/

## Usage

Say we want to format this number 2345678912 to the US format +1 (234) 567-8912,

```elm
import Phone

output = Phone.format "us" 2345678912

--> output == "+1 (234) 567-8912"
```

To get list of all countries

```elm
import Phone

countries = Phone.getAllCountries

--> countries = [(Name, ISO2, IntDialCode, Maybe Format), ...]
```

## Credits
This library is inspired by https://github.com/razagill/react-phone-input

## License

Copyright © 2016 Thomas Loh
Distributed under MIT license.



