require 'pry'
require 'csv'
require 'json'
require 'set'
require 'yaml'
require 'open-uri'
require_relative 'generate/data'
require_relative 'generate/utilities'

thailand = {}
provinces = {
  data: Set[]
}
districts = {
  data: Set[]
}
subDistricts = {
  data: Set[]
}

districts_data.each do |row|
  provice_id = row[7].to_i
  district_id = row[4].to_i
  subDistrict_id = row[1].to_i

  province = {
    id: provice_id,
    name: {
      th: row[8].gsub(/จ\./, '').strip,
      en: row[9]
    }
  }
  provinces[:data].add?(province)

  district = {
    id: district_id,
    name: {
      th: row[5].gsub(/อ\.|เขต/, '').strip,
      en: row[6]
    },
    provice_id: provice_id
  }
  districts[:data].add?(district)

  subDistrict = {
    id: subDistrict_id,
    name: {
      th: row[2].gsub(/ต\.|แขวง/, '').strip,
      en: row[3]
    },
    coordinates: {
      lat: row[10].to_f,
      lng: row[11].to_f
    },
    zipcode: zip_code_data[row[1].to_i],
    provice_id: provice_id,
    district_id: district_id
  }
  subDistricts[:data].add?(subDistrict)
end

def combine_json(row)
  if thailand[row[7]].nil?
    thailand[row[7]] = {
      name: {
        th: row[8].gsub(/จ\./, '').strip,
        en: row[9]
      },
      districts: {}
    }
    provinces[row[7]] = {
      name: {
        th: row[8].gsub(/จ\./, '').strip,
        en: row[9]
      }
    }
  end

  if thailand[row[7]][:districts][row[4]].nil?
    thailand[row[7]][:districts][row[4]] = {
      name: {
        th: row[5].gsub(/อ\.|เขต/, '').strip,
        en: row[6]
      },
      subDistricts: {}
    }
    districts[row[4]] = {
      name: {
        th: row[5].gsub(/อ\.|เขต/, '').strip,
        en: row[6]
      },
      changwat_id: row[7]
    }
  end

  thailand[row[7]][:districts][row[4]][:subDistricts][row[1]] = {
    name: {
      th: row[2].gsub(/ต\.|แขวง/, '').strip,
      en: row[3]
    },
    coordinates: {
      lat: row[10],
      lng: row[11]
    },
    zipcode: zip_code_data[row[1].to_i]
  }
  subDistricts[row[1]] = {
    name: {
      th: row[2].gsub(/ต\.|แขวง/, '').strip,
      en: row[3]
    },
    coordinates: {
      lat: row[10],
      lng: row[11]
    },
    zipcode: zip_code_data[row[1].to_i],
    changwat_id: row[7],
    amphoe_id: row[4]
  }
end

thailand.each do |id, c|
  c[:districts].each do |id, a|
    a[:subDistricts] = sort_by_to_h(a[:subDistricts])
  end
  c[:districts] = sort_by_to_h(c[:districts])
end

thailand = sort_by_to_h(thailand)

# output_to_dist(thailand, 'thailand')
output_to_dist(provinces, 'provinces')
output_to_dist(districts, 'districts')
output_to_dist(subDistricts, 'subDistricts')

