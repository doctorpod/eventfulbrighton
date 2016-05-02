require "csv"
require "yaml"
require "base64"

output_folder = "_posts#{Time.now.to_i}"
Dir.mkdir output_folder

CSV.foreach(ARGV[0]) do |fields|
  file_content = "---
layout: #{fields[1]}
status: #{fields[2]}
published: #{fields[3]}
title: \"#{fields[4]}\"
author: #{fields[5]}
date: #{fields[6]}
date_gmt: #{fields[7]}
tags:
  - #{(fields[8] || '').split(",").join("\n  -")}
"
  unless fields[9].nil?
    file_content += "media:
  path: #{fields[9]}
  type: #{fields[10]}
  bytes: #{fields[11]}
"
  end

  unless fields[12].nil?
    file_content += "youtube:
  id: #{fields[12]}
  width: #{fields[13]}
  height: #{fields[14]}
"
  end

  file_content += "---
#{Base64.decode64(fields[15])}"

  File.open(File.join(output_folder, fields[0]), "w") {|f| f.write(file_content) }
end
