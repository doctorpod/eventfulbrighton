require "yaml"
require "base64"

def cell(key, front_matter)
  val = front_matter

  key.split('.').each do |k|
    val = val[k]
    return '' if val.nil?
  end

  val = val.join(', ') if val.class == Array

  "\"#{val}\""
end

keys = %w{ file_name layout status published title author date date_gmt tags media.path media.type media.bytes youtube.id youtube.width youtube.height content }
puts keys.join(', ')

Dir.glob("_posts/*.md").each do |path|
  front_matter = YAML.load_file path
  content = File.read(path).sub(/^---\n.+---\n/m,"")
  puts keys.map { |key| cell key, {"file_name" => File.basename(path)}.merge(front_matter.merge("content" => Base64.encode64(content))) }.join(',')
end

# {"layout"=>"post", "status"=>"publish", "published"=>true, "title"=>"Knock Knock - Antik - Brighton Festival Fringe 2011", "author"=>"sarah", "date"=>"2011-05-27 20:39:53 +0100", "date_gmt"=>"2011-05-27 20:39:53 +0100", "tags"=>["Fringe festival", "theatre", "Fringe 2011", "Brighton Festival Fringe Podcast"], "media"=>{"path"=>"BFFP/fringe2011-knock-knock.m4v", "type"=>"video/x-m4v", "bytes"=>73022938}, "youtube"=>{"id"=>"xGJcWoRIFWw", "width"=>480, "height"=>360}}
