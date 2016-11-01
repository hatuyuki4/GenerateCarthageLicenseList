# GenerateCarthageLicenseList

Generate license property list from carthage check outs

## Usage

Copy `generate_carthage_license_list.rb` on your project directory and customize output_path,carthage_path.

```
output_path = "CarthageLicenseList.plist"
carthage_path = "Carthage/Checkouts/*"
```

Execute this command.

```
ruby generate_carthage_license_list.rb
```