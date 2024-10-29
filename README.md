[![Ceasefire Now](https://badge.techforpalestine.org/default)](https://techforpalestine.org/learn-more)

# Boston 311 Data
This is a spreadsheet (CSV file) of 311 requests submitted to [https://311.boston.gov/](https://311.boston.gov/). The requests are scraped from the public API.

Download the spreadsheet: [boston311.csv](https://wokewindows-data.s3.amazonaws.com/boston311.csv)

The spreadsheet was last updated 2024-10-29 and contains 462213 requests (257M of data) from 2023-01-01 through 2024-10-27.

## BUILD
```
make download-dates # this takes daaaays
make generate-spreadsheet update-readme
make push-spreadsheet # only nathan can do this
```

## LICENSE
All code is released under the MIT License.
