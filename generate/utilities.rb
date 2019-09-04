def sort_by_to_h(h)
  h.sort_by {|k, v| k}
   .map {|a| Hash[*a]}
   .reduce(&:merge)
end

def sort_by_key(json)
  json.sort_by {|v| v[:id] }
end

def sort_by_value(json)
  json.sort_by {|v| v[:id] }
end

# def output_to_dist(regions, filename)
#   File.open("dist/#{filename}.json", 'w') do |f|
#     f.write JSON.pretty_generate(sort_by_key(regions))
#   end
#   File.open("dist/#{filename}.yaml", 'w') do |f|
#     f.write sort_by_key(regions).to_yaml
#   end
# end

def output_to_dist(regions, filename)
  File.open("dist/#{filename}.json", 'w') do |f|
    f.write JSON.pretty_generate({
      data:sort_by_value(regions[:data].to_a)
    })
  end
  File.open("dist/#{filename}.yaml", 'w') do |f|
    f.write regions.to_yaml
  end
end
