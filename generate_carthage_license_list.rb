require "rexml/document"
require "pathname"

output_path = "CarthageLicenseList.plist"
carthage_path = "Carthage/Checkouts/*"

Dir.chdir(Pathname.new(__FILE__).parent.realpath)

doc = REXML::Document.new()
doc.add(REXML::XMLDecl.new("1.0", "UTF-8"))
doc.add(REXML::DocType.new("plist", "PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\""))

root_element = REXML::Element.new("plist")
root_element.add_attribute("version", "1.0")
doc.add_element(root_element)

root_dict = REXML::Element.new("dict")
root_element.add_element(root_dict)

root_array_title = REXML::Element.new("key")
root_array_title.add_text("PreferenceSpecifiers")
root_dict.add_element(root_array_title)

root_array = REXML::Element.new("array")
root_dict.add_element(root_array)

dirs = Dir.glob(carthage_path)

dirs.each do |d|
  license_path = "#{d}/LICENSE"
  license_md_path = "#{d}/LICENSE.md"

  if File.exist?(license_path)
    text = File.open(license_path, "r").read
  elsif File.exist?(license_md_path)
    text = File.open(license_md_path, "r").read
  else 
    next
  end

  license_dict = REXML::Element.new("dict")
  license_dict.add_element(license_dict)

  title_element = REXML::Element.new("key")
  title_element.add_text("Title")
  license_dict.add_element(title_element)

  license_title = REXML::Element.new("string")
  license_title.add_text(File.basename(d))
  license_dict.add_element(license_title)

  footer_text_element = REXML::Element.new("key")
  footer_text_element.add_text("FooterText")
  license_dict.add_element(footer_text_element)

  license_title = REXML::Element.new("string")
  license_title.add_text(text)
  license_dict.add_element(license_title) 

  type_element = REXML::Element.new("key")
  type_element.add_text("Type")
  license_dict.add_element(type_element)

  type_text = REXML::Element.new("string")
  type_text.add_text("PSGroupSpecifier")
  license_dict.add_element(type_text)   

  root_array.add_element(license_dict)
end

File.open(output_path, "w") do |outfile|
  pretty_formatter = REXML::Formatters::Pretty.new(0)
  pretty_formatter.compact = true
  pretty_formatter.write(doc, outfile)
end
