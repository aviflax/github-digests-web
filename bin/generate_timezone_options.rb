require 'timezone'

Timezone::Configure.begin do |c|
  c.order_list_by = :title
end

options = Timezone::Zone.list.map do |z|
  prefix = z[:utc_offset] > 0 ? '+' : ''
  "<option value=\"#{z[:zone]}\">#{z[:title]} (#{prefix}#{z[:utc_offset]})</option>"
end

puts options.join()
