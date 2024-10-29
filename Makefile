.PHONY: download-dates
download-dates:
	ruby lib/download_dates.rb

.PHONY: generate-spreadsheet
generate-spreadsheet:
	ruby lib/generate_spreadsheet.rb > output/boston311.csv

.PHONY: update-readme
update-readme:
	ruby lib/update_readme.rb

.PHONY: push-spreadsheet
push-spreadsheet:
	AWS_PROFILE=wokewindows aws s3 cp output/boston311.csv "s3://wokewindows-data/boston311.csv" --acl public-read
